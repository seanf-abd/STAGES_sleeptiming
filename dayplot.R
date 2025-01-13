# Load necessary libraries
library(dplyr)
library(lubridate)
library(ggplot2)

# Read the CSV file
data <- 'C:/Users/sefarrell/Downloads/Actigraphy Final to Post/Actigraphy/Final to Post/BOGN00004/minbymin/processed_data.csv'
df <- read.csv(data)

# Ensure the timestamp column is in the correct format
df$timestamp <- as.POSIXct(df$timestamp, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")

# Remove rows where timestamp is NA or invalid
df <- df %>% filter(!is.na(timestamp))

# Extract the date part from the timestamp and ensure it's properly formatted
df$date <- as.Date(df$timestamp)

# Remove rows where the date is NA (which should now only happen if the timestamp was invalid)
df <- df %>% filter(!is.na(date))

# Convert activity to numeric, handling any non-numeric values (like NA's)
df$activity <- as.numeric(df$activity)

# Remove rows where activity is NA
df <- df %>%
  filter(!is.na(activity))

# Check the structure of the data (to debug and ensure the columns are correct)
print(head(df))
print(summary(df))

# Check for any NA values in the date column and count them
na_dates <- sum(is.na(df$date))
print(paste("Number of NA values in date column:", na_dates))

# Check how many unique dates we have
unique_dates <- unique(df$date)
print(length(unique_dates))  # Number of unique dates
print(head(unique_dates))  # Show first few dates

# Limit the number of dates to, say, the first 10 unique dates
df_subset <- df %>%
  filter(date %in% unique_dates[!is.na(unique_dates)][1:15])  # Use first 10 unique dates, excluding NAs

# Print a quick check to see the structure of the subset data
print(head(df_subset))  # Check the first few rows of the subset

# Verify the number of points in the subset
num_points <- nrow(df_subset)
print(paste("Number of points in the subset:", num_points))

# Create the plot with faceting for the first 15 dates
p <- ggplot(df_subset, aes(x = timestamp, y = activity)) +
  geom_point(color = "blue", size = 0.3, alpha = 0.5) +  # Smaller points with transparency
  facet_wrap(~ date, ncol = 3, scales = "free_x") +  # Limit to 3 columns per row
  theme_minimal() +
  labs(title = "Activity Counts for the First 10 Days",
       x = "Time of Day", y = "Activity Count") +
  theme(
    strip.text = element_text(size = 10, face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1)  # Rotate x-axis labels
  )

# Print a message to confirm plot creation
print("Plot created")

# Render the plot in RStudio (or save as an image)
print(p)  # This will display the plot in the RStudio viewer

# Optional: Save the plot to a file with larger dimensions
ggsave("activity_plot.png", plot = p, width = 16, height = 20, units = "in", dpi = 300)
