# Load required libraries
library(jsonlite)
library(dplyr)
library(readr)
library(readxl)

# Define the path to the actigraphy and PSG folders
actigraphy_folder <- "C:/Users/sefarrell/Downloads/STAGES_PSG/BOGN Actigraphy/"
psg_folder <- "C:/Users/sefarrell/Downloads/STAGES_PSG/BOGN PSG/"

# Function to process actigraphy data from a single JSON file for each subject
process_actigraphy <- function(subject_id) {
  
  # Construct the path to the subject's minbymin folder
  subject_folder <- file.path(actigraphy_folder, subject_id, "minbymin")
  
  # List the JSON file in the minbymin folder for the subject
  actigraphy_file <- list.files(subject_folder, pattern = "\\.json$", full.names = TRUE)
  
  # Check if any JSON files are found for the subject
  if (length(actigraphy_file) == 0) {
    message("No actigraphy file found for subject: ", subject_id)
    return(data.frame(Subject_ID = subject_id, Actigraphy_Start_Date = NA, Actigraphy_End_Date = NA))
  }
  
  # Read the raw content of the JSON file to inspect it
  raw_content <- readLines(actigraphy_file)
  
  # Find the line where the JSON data starts (first occurrence of "date":)
  start_line <- grep('"date":"', raw_content)
  
  if (length(start_line) == 0) {
    message("Error: No valid JSON data found in file: ", actigraphy_file)
    return(data.frame(Subject_ID = subject_id, Actigraphy_Start_Date = NA, Actigraphy_End_Date = NA))
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
    return(data.frame(Subject_ID = subject_id, Actigraphy_Start_Date = NA, Actigraphy_End_Date = NA))
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

# Function to get the PSG start date for each subject
get_psg_date <- function(subject_id) {
  # Construct the path to the PSG file for the subject
  psg_file <- file.path(psg_folder, paste0(subject_id, ".csv"))
  
  # Check if the PSG file exists
  if (!file.exists(psg_file)) {
    message("No PSG file found for subject: ", subject_id)
    return(NA)
  }
  
  # Read the PSG CSV file
  psg_data <- read_csv(psg_file, col_types = cols(`Start Time` = col_character())) %>%
    select(`Start Time`, Event)
  
  # Clean up leading/trailing spaces in 'Event' column
  psg_data$Event <- trimws(psg_data$Event)
  
  # Remove non-numeric and non-colon characters from 'Start Time'
  psg_data$`Start Time` <- gsub("\\s", "", psg_data$`Start Time`)  # Remove all spaces
  psg_data$`Start Time` <- gsub("[^0-9:]", "", psg_data$`Start Time`)  # Remove non-numeric and non-colon characters
  
  # Convert 'Start Time' to POSIXct format
  psg_data$Start_Time <- as.POSIXct(psg_data$`Start Time`, format = "%H:%M:%S", tz = "UTC")
  
  # Check for NA values after conversion
  if (any(is.na(psg_data$Start_Time))) {
    stop("Error: Some Start Time values could not be converted. Check the format.")
  }
  
  # Extract Sleep Onset (First "Stage1")
  sleep_onset_row <- which(psg_data$Event == "Stage1")[1]
  if (is.na(sleep_onset_row)) {
    stop("Error: No 'Stage1' event found in the data.")
  }
  sleep_onset_time <- psg_data[sleep_onset_row, "Start_Time"]
  
  # Return the PSG start date
  return(as.Date(sleep_onset_time))
}

# Get the list of subject IDs by listing the folders in the BOGN Actigraphy directory
subject_ids <- list.dirs(actigraphy_folder, full.names = FALSE, recursive = FALSE)
subject_ids <- basename(subject_ids)  # Extract folder names (i.e., subject IDs)

# Process actigraphy data for each subject
actigraphy_results <- lapply(subject_ids, process_actigraphy)

# Filter out NULL results (subjects with no valid data)
actigraphy_results <- actigraphy_results[!sapply(actigraphy_results, is.null)]

# Combine the results into a data frame
actigraphy_summary <- do.call(rbind, actigraphy_results)

# Get the PSG dates for each subject
psg_dates <- sapply(subject_ids, get_psg_date)

# Add the PSG dates to the actigraphy summary
actigraphy_summary$PSG_Start_Date <- psg_dates[match(actigraphy_summary$Subject_ID, subject_ids)]

# Output the summary data to a CSV file
write.csv(actigraphy_summary, "C:/Users/sefarrell/Downloads/actigraphy_psg_summary.csv", row.names = FALSE)

# Print a message to indicate the file has been saved
message("Actigraphy and PSG summary saved to 'C:/Users/sefarrell/Downloads/actigraphy_psg_summary.csv'")

# Print Sleep Onset Time
print("Sleep Onset Time:")
print(format(sleep_onset_time, "%H:%M:%S"))

# Print Wake Time
print("Wake Time:")
print(format(wake_time, "%H:%M:%S"))
