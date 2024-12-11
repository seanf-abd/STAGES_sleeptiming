
#Load library 
library(readr)
# Load data
data <- read_csv("C:/Users/sefarrell/Downloads/STAGES_PSG/BOGN00001/BOGN00001 (1).csv")

# Convert Start Time to POSIXct (HH:MM:SS format)
data$`Start Time` <- as.POSIXct(data$`Start Time`, format = "%H:%M:%S")

# Ensure Event column is a character vector
data$Event <- as.character(data$Event)

# Loop through the rows to find the first occurrence of "Stage1" in the Event column
for(i in 1:nrow(data)) {
  if(data$Event[i] == "Stage1") {
    # Format the Start Time to display only the time (HH:MM:SS), without the date part
    formatted_time <- format(data$`Start Time`[i], format = "%H:%M:%S")
    
    # Print the formatted start time of the first occurrence of Stage1
    print(formatted_time)
    break  # Exit the loop once the first Stage1 is found
  }
}

