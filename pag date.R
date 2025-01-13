library(dplyr)
library(readxl)

# Define the function to process PSG start date
get_psg_date <- function(subject_id) {
  # Define the file path directly
  psg_date_file <- "C:/Users/sefarrell/Downloads/STAGES_PSG/PSG_date/STAGES PSG DATES.xlsx"
  
  # Read the PSG date Excel file
  psg_date_data <- read_excel(psg_date_file)
  
  # Clean column names to avoid any issues with extra spaces
  colnames(psg_date_data) <- trimws(colnames(psg_date_data))  # Remove any extra spaces
  
  # Print the column names to debug
  print("Column names in the PSG data:")
  print(colnames(psg_date_data))  # DEBUG
  
  # Filter the data for the specific subject_id
  psg_date_row <- psg_date_data %>%
    filter(subject_id == !!subject_id)  # Filter for the specific subject_id
  
  # Print the filtered row for debugging
  print(paste("Filtered data for subject:", subject_id))  # DEBUG
  print(psg_date_row)  # DEBUG
  
  # If no row is found, return NA
  if (nrow(psg_date_row) == 0) {
    return(NA)
  }
  
  # Extract the PSG start date (which might be in Excel serial format)
  psg_date_value <- psg_date_row$`modified.date_of_evaluation`[1]  # Correct column reference
  
  # Handle NA values in modified.date_of_evaluation
  if (is.na(psg_date_value) || psg_date_value == "") {
    return(NA)  # If it's NA or empty, return NA
  }
  
  # Convert to numeric if necessary (handling both character and numeric types)
  psg_date_value <- as.numeric(psg_date_value)  # Convert to numeric if not already
  
  # Check if the conversion was successful
  print(paste("Numeric value for", subject_id, ":", psg_date_value))  # DEBUG
  
  # Handle Excel date serial format: Convert the serial number to Date
  # Excel uses 1900 as the starting year (with a bug for leap years), so use "1900-01-01"
  if (!is.na(psg_date_value) && psg_date_value > 0) {
    # Fix for Excel date bug: Excel erroneously counts 1900-02-29 as valid
    psg_date <- as.Date(psg_date_value - 2, origin = "1900-01-01")  # Subtract 2 due to Excel's base date bug
  } else {
    psg_date <- NA
  }
  
  # Check if the conversion was successful and return the date
  if (inherits(psg_date, "Date")) {
    return(format(psg_date, "%Y-%m-%d"))  # Return the date in "YYYY-MM-DD" format
  } else {
    return(NA)  # Return NA if the conversion fails
  }
}

# Test the function with a specific subject ID
print(get_psg_date("BOGN00001"))
print(get_psg_date("BOGN00002"))
print(get_psg_date("BOGN00003"))
print(get_psg_date("BOGN00004"))
