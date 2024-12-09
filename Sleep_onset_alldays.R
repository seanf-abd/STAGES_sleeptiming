library(dplyr)
library(jsonlite)

# Load the JSON data (replace with your file path)
data <- fromJSON('C:/Users/sefarrell/Downloads/Actigraphy Final to Post/Actigraphy/Final to Post/BOGN00001/minbymin/min_2018-04-01-2019-08-30.json')

# Convert JSON to dataframe
df <- as.data.frame(data$items)

# Define inactivity periods (activeness <= 2 is considered inactive)
df <- df %>%
  mutate(sleep_inactive = ifelse(activeness <= 2, 1, 0))

# Track consecutive inactivity periods for each date
df <- df %>%
  group_by(date) %>%
  mutate(consecutive_inactive = ifelse(sleep_inactive == 1, 
                                       cumsum(sleep_inactive), 
                                       0))

# Detect sleep onset for each day: first 5+ consecutive minutes of inactivity
sleep_onset_results <- df %>%
  group_by(date) %>%
  mutate(onset_index = which(consecutive_inactive >= 5)[1]) %>%  # Find first instance of sleep onset
  filter(!is.na(onset_index)) %>%
  slice(1) %>%  # Take only the first detected sleep onset for the day
  ungroup() %>%
  mutate(sleep_onset_time = sprintf("%02d:%02d", onset_index %/% 60, onset_index %% 60)) %>%
  select(date, sleep_onset_time)

# View the sleep onset results for all days
print(sleep_onset_results)

# Save the results to a CSV file
write.csv(sleep_onset_results, "all_sleep_onset_times.csv", row.names = FALSE)
