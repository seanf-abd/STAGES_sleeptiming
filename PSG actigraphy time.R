# Load necessary libraries
library(jsonlite)
library(dplyr)
library(lubridate)
library(readxl)  # For reading Excel files

# Define paths
actigraphy_folder <- "C:/Users/sefarrell/Downloads/STAGES_PSG/BOGN Actigraphy/"
psg_date_file <- "C:/Users/sefarrell/Downloads/STAGES_PSG/PSG_date/STAGES PSG DATES.xlsx"  # Correct path to your PSG dates file

# Function to process actigraphy data from a single JSON file for each subject
process_actigraphy <- function(subject_id) {
  
  # Construct the path to the subject's minbymin folder
  subject_folder <- file.path(actigraphy_folder, subject_id, "minbymin")
  
  # List the JSON file in the minbymin folder for the subject
  actigraphy_file <- list.files(subject_folder, pattern = "\\.json$", full.names = TRUE)
  
  # Check if any JSON files are found for the subject
  if (length(actigraphy_file) == 0) {
    message("No actigraphy file found for subject: ", subject_id)
    return(NULL)
  }
  
  # Print the file being processed for debugging
  message("Processing actigraphy file: ", actigraphy_file)
  
  # Read the raw content of the JSON file to inspect it
  raw_content <- readLines(actigraphy_file)
  
  # Find the line where the JSON data starts (first occurrence of "date":)
  start_line <- grep('"date":"', raw_content)
  
  if (length(start_line) == 0) {
    message("Error: No valid JSON data found in file: ", actigraphy_file)
    return(NULL)
  }
  
  # Extract the valid JSON content from the file
  valid_json <- paste(raw_content[start_line:length(raw_content)], collapse = "\n")
  
  # Parse the valid JSON content
  actigraphy_data <- fromJSON(valid_json)
  
  # Extract the 'items' field that contains the actigraphy data
  items <- actigraphy_data$items
  
  # Check if there is any actigraphy data available
  if (length(items) == 0) {
    message("No actigraphy data found for subject: ", subject_id)
    return(NULL)
  }
  
  # Convert the 'date' field to Date format (ignoring time)
  items_df <- as.data.frame(items)
  
  # Get the start and end dates of the actigraphy data
  actigraphy_start <- min(as.Date(items_df$date))
  actigraphy_end <- max(as.Date(items_df$date))
  
  # Return a data frame with the subject ID and actigraphy start and end dates
  return(data.frame(Subject_ID = subject_id, 
                    Actigraphy_Start_Date = actigraphy_start,
                    Actigraphy_End_Date = actigraphy_end))
}

# Updated function to get PSG start date for a given subject from the Excel file
get_psg_date <- function(subject_id) {
  # Read the PSG date Excel file
  psg_date_data <- read_excel(psg_date_file)
  
  # Clean column names to avoid any issues with extra spaces
  colnames(psg_date_data) <- trimws(colnames(psg_date_data))  # Remove any extra spaces
  
  # Filter the data for the specific subject_id
  psg_date_row <- psg_date_data %>%
    filter(subject_id == !!subject_id)  # Use the correct filtering
  
  # If no row is found, return NA
  if (nrow(psg_date_row) == 0) {
    return(NA)
  }
  
  # Extract the PSG start date (modified.date_of_evaluation)
  psg_date_value <- psg_date_row$modified.date_of_evaluation[1]
  
  # Convert to Date if necessary (if it's in Excel serial date format)
  if (is.character(psg_date_value)) {
    psg_date_value <- as.numeric(psg_date_value)
  }
  
  if (is.numeric(psg_date_value)) {
    psg_date_value <- as.Date(psg_date_value, origin = "1899-12-30")
  }
  
  # Return the PSG date (if it's a valid Date)
  if (inherits(psg_date_value, "Date")) {
    return(format(psg_date_value, "%Y-%m-%d"))
  } else {
    return(NA)
  }
}

# Function to get subject IDs from the actigraphy folder
get_subject_ids <- function(actigraphy_folder) {
  # List the folders in the BOGN Actigraphy directory (which represent subject IDs)
  subject_ids <- list.dirs(actigraphy_folder, full.names = FALSE, recursive = FALSE)
  subject_ids <- basename(subject_ids)  # Extract folder names (i.e., subject IDs)
  return(subject_ids)
}

# Get the list of subject IDs
subject_ids <- get_subject_ids(actigraphy_folder)

# Print subject IDs to debug
print(subject_ids)  # DEBUG

# Process actigraphy data for each subject
actigraphy_results <- lapply(subject_ids, process_actigraphy)

# Filter out NULL results (subjects with no valid data)
actigraphy_results <- actigraphy_results[!sapply(actigraphy_results, is.null)]

# Combine the results into a data frame for actigraphy
actigraphy_summary <- do.call(rbind, actigraphy_results)

# Get PSG dates for each subject using the updated PSG function
psg_dates <- sapply(subject_ids, get_psg_date)

# Create a data frame for PSG dates
psg_data <- data.frame(Subject_ID = subject_ids,
                       PSG_Start_Date = psg_dates,
                       stringsAsFactors = FALSE)

# Merge actigraphy and PSG data based on Subject_ID
final_summary <- merge(actigraphy_summary, psg_data, by = "Subject_ID", all = TRUE)

# Print the final summary to debug
print(head(final_summary))  # DEBUG

# Output the final data to a CSV file
write.csv(final_summary, "C:/Users/sefarrell/Downloads/final_summary.csv", row.names = FALSE)

# Print a message to indicate the file has been saved
message("Final summary saved to 'C:/Users/sefarrell/Downloads/final_summary.csv'")
