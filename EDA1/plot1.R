#------------------------------------------------------------------------------
plotXsize <- 480
plotYsize <- 480

readClasses <- c(rep("character",2), rep("numeric",7))
#data <- read.csv("household_power_consumption.txt", header=TRUE, sep=";", na.strings="?", stringsAsFactors=FALSE, colClasses=readClasses)

# Reads file into data.frame
# NOTE: for practical reasons I set a limit on nrow to read just past the range
#       that includes the dates that we want to examine.  It is a quick hack
#       to save some time.  
#       The script does an actual filtering on the dates in anycase.

data <- read.csv("household_power_consumption.txt", 
                  nrow=100000, 
		  header=TRUE, 
		  sep=";", 
		  na.strings="?", 
		  stringsAsFactors=FALSE, 
		  colClasses=readClasses)

# Converts 'Date' column into a proper date format
data$Date <- as.POSIXct(strptime(data$Date,"%d/%m/%Y"))

# Filters the data.frame on wanted dates
data <- data[data$Date == as.POSIXct("2007-02-01") | data$Date == as.POSIXct("2007-02-02"),]

# Creates new time column combining date and time
data$newTime <- as.POSIXct(strptime( paste(as.character(data$Date),data$Time), "%F %T"))

# Actual PLOT begins here.

png(filename="plot1.png", width=plotXsize, height=plotYsize, bg="transparent")

par(cex = plotXsize/480)

hist(data$Global_active_power,
     xlab="Global Active Power (kilowatts)", 
     col="red", 
     main="Global Active Power",
     pty="s",
     bg="transparent")

dev.off()

#------------------------------------------------------------------------------
