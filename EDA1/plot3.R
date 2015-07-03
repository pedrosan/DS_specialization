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

png(filename="plot3.png", width=plotXsize, height=plotYsize, bg="transparent")

par(cex = plotXsize/480)

plot(c(data$newTime,data$newTime,data$newTime),
     c(data$Sub_metering_1,data$Sub_metering_2,data$Sub_metering_3),
     type="n",
     xlab="",
     ylab="Energy sub metering",
     main="",
     pty="s",
     bg="transparent")

lines(data$newTime,data$Sub_metering_1,col="black")
lines(data$newTime,data$Sub_metering_3,col="blue")
lines(data$newTime,data$Sub_metering_2,col="red")
legend(x="topright",
       col=c("black","red","blue"),
       legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       lty=c(1,1,1))

dev.off()

#------------------------------------------------------------------------------
