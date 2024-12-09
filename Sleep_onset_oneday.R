library(dplyr)
library(jsonlite)

# Load the JSON data (replace with your file path)
data <- fromJSON('C:/Users/sefarrell/Downloads/Actigraphy Final to Post/Actigraphy/Final to Post/BOGN00001/minbymin/min_2018-04-01-2019-08-30.json')

# Convert JSON to dataframe
df <- as.data.frame(data$items)

# Example date for testing
date_example <- "2018-10-03"

# Filter data for one specific day
single_day <- df %>% filter(date == date_example)

# Define inactivity periods (activeness <= 2 is considered inactive)
single_day <- single_day %>%
  mutate(sleep_inactive = ifelse(activeness <= 2, 1, 0))

# Track consecutive inactivity periods
single_day <- single_day %>%
  mutate(consecutive_inactive = ifelse(sleep_inactive == 1, 
                                       cumsum(sleep_inactive), 
                                       0))

# Detect sleep onset: first 5+ consecutive minutes of inactivity
onset_index <- which(single_day$consecutive_inactive >= 5)[1]

if (!is.na(onset_index)) {
  sleep_onset_minute <- single_day$minute[onset_index]
  
  # Convert minute to HH:MM format
  sleep_onset_time <- sprintf("%02d:%02d", sleep_onset_minute %/% 60, sleep_onset_minute %% 60)
  
  print(paste("Sleep onset for", date_example, "is at", sleep_onset_time))
} else {
  print(paste("No sleep onset detected for", date_example))
}

# View the result for consecutive inactivity tracking
head(single_day[, c("minute", "activeness", "sleep_inactive", "consecutive_inactive")])
