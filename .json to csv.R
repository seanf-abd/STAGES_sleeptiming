library(lubridate)
library(dplyr)
library(jsonlite)

# Path to the raw JSON file
json_file_path <- "C:/Users/sefarrell/Downloads/Actigraphy Final to Post/Actigraphy/Final to Post/BOGN00004/minbymin/min_2018-04-01-2019-08-30.json"

# Read the raw content from the JSON file
raw_json <- readLines(json_file_path)

# Find the line where the actual JSON data starts (after the HTTP headers)
json_start_line <- grep("\\{", raw_json)[1]  # Find the line with the first '{'

# Extract the actual JSON content starting from that line
clean_json <- paste(raw_json[json_start_line:length(raw_json)], collapse = "\n")

# Parse the cleaned JSON content into a dataframe
df <- fromJSON(clean_json)

# Extract the 'items' part of the JSON
df <- df$items

# Clean up column names (remove spaces or any special characters)
colnames(df) <- trimws(colnames(df))

# Convert 'minute' into hours and minutes
df$hour <- df$minute %/% 60  # Get the number of full hours (integer division)
df$minute_remainder <- df$minute %% 60  # Get the remaining minutes

# Convert 'date' to Date format
df$date <- as.Date(df$date, format="%Y-%m-%d")  # Ensure the date format is correct

# Combine 'date', 'hour', and 'minute_remainder' to create a 'timestamp' column
df$timestamp <- as.POSIXct(paste(df$date, sprintf("%02d:%02d", df$hour, df$minute_remainder)), 
                           format="%Y-%m-%d %H:%M")

# Check if the timestamp is being generated correctly
cat("First few rows with timestamp:\n")
head(df$timestamp)

# Add device information
df$device <- "BOGN00001"  # This can be any identifier for your device

# Extract the relevant columns: 'timestamp', 'activity', 'device'
df <- df[, c("timestamp", "activeness", "device")]

# Path for the CSV file output
csv_file_path <- 'C:/Users/sefarrell/Downloads/Actigraphy Final to Post/Actigraphy/Final to Post/BOGN00001/minbymin/processed_data.csv'

# Rename the columns to match the required CSV format
colnames(df) <- c("timestamp", "activity", "device")

# Debug check: See if the final dataframe is correct
cat("First few rows of the final dataframe:\n")
head(df)

# Save the dataframe to a CSV file
write.csv(df, csv_file_path, row.names = FALSE)

# Confirm successful save
cat("Data saved successfully to CSV at ", csv_file_path, "\n")
library(lubridate)
library(dplyr)
library(jsonlite)

# Path to the raw JSON file
json_file_path <- "C:/Users/sefarrell/Downloads/Actigraphy Final to Post/Actigraphy/Final to Post/BOGN00004/minbymin/min_2018-04-01-2019-08-30.json"

# Read the raw content from the JSON file
raw_json <- readLines(json_file_path)

# Find the line where the actual JSON data starts (after the HTTP headers)
json_start_line <- grep("\\{", raw_json)[1]  # Find the line with the first '{'

# Extract the actual JSON content starting from that line
clean_json <- paste(raw_json[json_start_line:length(raw_json)], collapse = "\n")

# Parse the cleaned JSON content into a dataframe
df <- fromJSON(clean_json)

# Extract the 'items' part of the JSON
df <- df$items

# Clean up column names (remove spaces or any special characters)
colnames(df) <- trimws(colnames(df))

# Convert 'minute' into hours and minutes
df$hour <- df$minute %/% 60  # Get the number of full hours (integer division)
df$minute_remainder <- df$minute %% 60  # Get the remaining minutes

# Convert 'date' to Date format
df$date <- as.Date(df$date, format="%Y-%m-%d")  # Ensure the date format is correct

# Combine 'date', 'hour', and 'minute_remainder' to create a 'timestamp' column
df$timestamp <- as.POSIXct(paste(df$date, sprintf("%02d:%02d", df$hour, df$minute_remainder)), 
                           format="%Y-%m-%d %H:%M")

# Check if the timestamp is being generated correctly
cat("First few rows with timestamp:\n")
head(df$timestamp)

# Add device information
df$device <- "BOGN00001"  # This can be any identifier for your device

# Extract the relevant columns: 'timestamp', 'activity', 'device'
df <- df[, c("timestamp", "activeness", "device")]

# Path for the CSV file output
csv_file_path <- 'C:/Users/sefarrell/Downloads/Actigraphy Final to Post/Actigraphy/Final to Post/BOGN00004/minbymin/processed_data.csv'

# Rename the columns to match the required CSV format
colnames(df) <- c("timestamp", "activity", "device")

# Debug check: See if the final dataframe is correct
cat("First few rows of the final dataframe:\n")
head(df)

# Save the dataframe to a CSV file
write.csv(df, csv_file_path, row.names = FALSE)

# Confirm successful save
cat("Data saved successfully to CSV at ", csv_file_path, "\n")
