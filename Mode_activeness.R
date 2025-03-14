library(ggplot2)
library(lubridate)
library(dplyr)
library(jsonlite)

# Load the JSON data (adjust the path as needed)
df <- fromJSON("C:/Users/sefarrell/Downloads/Actigraphy Final to Post/Actigraphy/Final to Post/BOGN00001/minbymin/min_2018-04-01-2019-08-30.json")

# Extract the 'items' part of the JSON
df <- df$items

# Clean up column names (remove spaces or any special characters)
colnames(df) <- trimws(colnames(df))
# Convert 'minute' into hours and minutes
df$hour <- df$minute %/% 60  # Get the number of full hours (integer division)
df$minute_remainder <- df$minute %% 60  # Get the remaining minutes

#Convert 'date' to Date format
df$date <- as.Date(df$date, format="%Y-%m-%d")  # Ensure the date format is correct

#Combine 'date', 'hour', and 'minute_remainder' to create a 'timestamp' column
df$timestamp <- as.POSIXct(paste(df$date, sprintf("%02d:%02d", df$hour, df$minute_remainder)), 
                           format="%Y-%m-%d %H:%M")

# Check if the timestamp is being generated correctly
cat("First few rows with timestamp:\n")
head(df$timestamp)

# Add device information
df$device <- "BOGN00001"  # This can be any identifier for your device

# Extract the relevant columns: 'timestamp', 'steps', 'activity', 'device', 'mode'
df <- df[, c("timestamp", "activeness", "device")]

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