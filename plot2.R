## Sets FileUrl
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

## Check if file exists
if (!file.exists("household_power_consumption.zip")) {
  ## if not download file
  download.file(fileUrl, destfile="household_power_consumption.zip", mode = "wb")
  ## unzip file
  unzip("household_power_consumption.zip")
  
  ## Read data into a table with appropriate classes
  power.df <- read.table("household_power_consumption.txt", header=TRUE,
                         sep=";", na.strings="?",
                         colClasses=c(rep("character", 2), 
                                      rep("numeric", 7)))
  
  ## Set Start and End date of analysis
  startDate <- as.Date("2007-02-01", format="%Y-%m-%d") 
  endDate <- as.Date("2007-02-02", format="%Y-%m-%d") 

  ## Filter Data
  power.df <- subset(power.df, as.Date(power.df$Date, format="%d/%m/%Y") >= startDate
                     & as.Date(power.df$Date, format="%d/%m/%Y") <= endDate)
  
  
  # convert Date and Time variables to Date/Time classes
  power.df$Time <- paste(power.df$Date, power.df$Time, sep=" ")
  power.df$Date <- as.Date(power.df$Date , "%d/%m/%Y")
  power.df$Time <- strptime(power.df$Time, "%d/%m/%Y %H:%M:%S")
  
  ## Save file
  saveRDS(power.df, file="power-data.rds")

} else {
  ## Read file previous processed
  power.df <- readRDS("power-data.rds")
}

## Open png device
png(filename="plot2.png", width = 480, height = 480)

## Make plot
plot(power.df$Time, power.df$Global_active_power,
     ylab="Global Active Power (kilowatts)", xlab=" ", type="l")

## Turn off device
dev.off()