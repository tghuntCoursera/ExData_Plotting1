#library(sqldf)

localFile = 'household_power_consumption.zip'

# If the local file does not exist, download it
if (!file.exists(localFile)) {
  dataUrl = 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
  print("Attempting to download file to local dir")
  if (Sys.info()['sysname'] == "Windows") {
    print("Downloading on Windows")
    download.file(dataUrl, destfile = localFile)
  }
  else {
    # If something other than windows add curl
    print("Downloading on Mac/Linux with curl")
    download.file(dataUrl, destfile = localFile, method = 'curl')
  }
  
  # Check to see if the file is present
  # If not print an error message and stop
  if (!file.exists(localFile)) {
    print('Unable to download the file')
    stop()
  }
} else {
  print("Skipping download, the file already exists")
}

# If the pcData object does not exist or it is less than 2075259 rows then read it.
if (!exists("pcData") || nrow(pcData) < 2075259) {
  # Update to read only the valid section?
  pcData <- read.table(unz(description=localFile, filename='household_power_consumption.txt'), header=TRUE, sep=';', na.strings = "?", skipNul = TRUE )
  
  # Create a DateTime column to be used for ploting.
  pcData$DateTime <- (as.POSIXct(strptime(paste(pcData$Date," ",pcData$Time), "%d/%m/%Y %H:%M:%S")))
} else {
  print("Skipping file read.  rm(pcData) to force re-read")
}

print("Creating chartData set")
chartData <- subset(pcData, Date == "1/2/2007" | Date == "2/2/2007")

# Remove the existing pcData object
rm(pcData)

# Plot the data
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Open a png device
png(file="plot2.png", bg="white", width = 480, height = 480, units = "px")

# Generate an X/Y line plot with global active power on the Y and date/time on the x
plot(chartData$DateTime, chartData$Global_active_power, type = "l", xlab="", ylab = "Global Active Power (kilowatts)")

# Close the png device
dev.off()

# Clean up, remove the chartData object.
rm(chartData)
