# Install necessary libraries
install.packages("jsonlite")
install.packages("dplyr")
install.packages("lubridate")
install.packages("ggplot2")
# Load libraries
library(jsonlite)
library(dplyr)
library(lubridate)
library(ggplot2)
# Load the JSON file
# Load the JSON file
data <- fromJSON('C:/Users/sefarrell/Downloads/Actigraphy Final to Post/Actigraphy/Final to Post/BOGN00001/minbymin/min_2018-04-01-2019-08-30.json')

# Convert to a dataframe
df <- as.data.frame(data$items)  # Assuming 'items' is the key for records

# Clean df to remove excess activeness values
df <- df[df$activeness != 20, ]

# Mobile time is where activity >= 2
df$mobile_time <- ifelse(df$activeness >= 2, 1, 0)

k <- 0.88888  # Constant used in paper
# Wake threshold calculation also used in paper 
wake_threshold <- (sum(df$activeness[df$mobile_time == 1]) / sum(df$mobile_time)) * k

# Convert minute into hours and minutes
df$hour <- df$minute %/% 60  # Extract the hour
df$minute <- df$minute %% 60  # Extract the minute

# Create timestamp column
df$timestamp <- as.POSIXct(paste(df$date, sprintf("%02d:%02d", df$hour, df$minute)), format="%Y-%m-%d %H:%M")

# Create shifted columns for E1, E-1, E2, E-2
df$E1 <- c(NA, df$activeness[-nrow(df)])  # Shift by 1 (next minute)
df$E_1 <- c(df$activeness[-1], NA)        # Shift by 1 (previous minute)
df$E2 <- c(rep(NA, 2), df$activeness[-(1:2)])  # Shift 2 steps forward
df$E_2 <- c(df$activeness[-(1:2)], rep(NA, 2))  # Shift 2 steps backward

# Calculate Total Activity
df$Total_Activity <- df$activeness + 0.2 * df$E1 + 0.2 * df$E_1 + 0.04 * df$E2 + 0.04 * df$E_2

# Classify epochs as sleep or wake based on total activity vs. wake threshold
df$sleep_wake <- ifelse(df$Total_Activity <= wake_threshold, "Sleep", "Wake")

# Plot activity levels with sleep/wake classification
ggplot(df, aes(x = timestamp, y = activeness)) +
  geom_line() +
  geom_point(aes(color = sleep_wake)) +
  labs(title = "Activity with Sleep/Wake Status", x = "Time", y = "Activity Level")
