# Load necessary libraries
library(GGIR)
library(lubridate)

# Set directories
datadir <- "C:/Users/sefarrell/Documents/Stages GGIR/Input/"
output_dir <- "C:/Users/sefarrell/Documents/Stages GGIR/Output"

# Step 1: Use read.myacc.csv to load cleaned CSV data
cat("\n### STEP 1: LOADING CLEANED CSV DATA ###\n")

# Use read.myacc.csv to read the cleaned CSV file
data_file <- "C:/Users/sefarrell/Documents/Stages GGIR/Input/activity_data.csv"  # Adjust path as needed

# Read the data using the read.myacc.csv function from GGIR
# Here, 'rmc.firstrow.acc' refers to the row containing the actual accelerometer data
data <- read.myacc.csv(
  rmc.file = data_file,  # Specify the path to your CSV file
  desiredtz = "Europe/London",  # Convert to Europe/London time zone
  rmc.firstrow.acc = 2,  # Start reading acceleration data from row 2
  rmc.firstrow.header = 1,  # Header is in the first row
  rmc.unit.acc = "g",  # Acceleration unit is in g
  rmc.col.time = 1,  # Time is in the first column
  rmc.unit.time = "UNIXsec",  # Use UNIX timestamp format
  rmc.format.time = "%Y-%m-%d",  # Date format as year-month-day (adjust if needed)
  rmc.sf = 60  # Sample rate is 60 seconds (1 minute)
)
# Display the first few rows of the loaded data for verification
cat("\nFirst few rows of the loaded data:\n")
head(data)

# Step 2: Run GGIR analysis with the loaded data (excluding ENMO)
cat("\n### STEP 2: RUN GGIR ###\n")

# Running GGIR analysis on the loaded data (excluding ENMO calculation)
GGIR(
  datadir = datadir,
  outputdir = output_dir,
  extEpochData_timeformat = "%d/%m/%Y %H:%M:%S",  # Adjust timestamp format for day/month/year
  mode = c(1:2),  # Analyze raw data and activity data (ignoring ENMO)
  do.imp = FALSE,
  do.cal = FALSE,
  do.anglez = FALSE,  # No angles available, so don't attempt angle calculations
  do.ENMO = FALSE,  # Disable ENMO calculation since we don't have accelerometer data
  verbose = TRUE,
  windowsizes = c(60, 900, 3600),  # 1 minute, 15 minutes, and 1 hour windows
  visualreport = FALSE,
  outliers.only = FALSE,
  HASIB.algo = "Sadeh1994",  # Use the available algorithm for sleep/wake detection
  minimumFileSizeMB = .00001,
  def.noc.sleep = c(),
  studyname = "MyStudy",
  ignore_missing_data = TRUE  # Instruct GGIR to handle missing data gracefully
)

cat("\nGGIR analysis completed. Check the output directory for results.\n")
