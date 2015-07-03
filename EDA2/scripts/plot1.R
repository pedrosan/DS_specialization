#-------------------------------------------------------------------------------
# Q1: Have Total Emissions decreased between 1999 and 2008?
#     - Use 'base' plotting system
#     - Show 'total' emission from all sources for each of the years
#-------------------------------------------------------------------------------
library(plyr)
library(reshape2)
library(ggplot2)

#---------------------------------------
# data loading
#---------------------------------------
# REMEMBER TO UNCOMMENT
# SCC <- readRDS("Source_Classification_Code.rds")
NEI <- readRDS("./data/summarySCC_PM25.rds")

#---------------------------------------
# data preparation
#---------------------------------------
UStot.mtons <- ddply(NEI, .(year), summarize, emissions=sum(Emissions)/1.0e6)
years.all <- 1998:2009
years.data <- UStot.mtons$year

#---------------------------------------
# plotting section
#---------------------------------------
fig.width <- 640
fig.height <- 640
fig.res <- 108

png(filename="plot1_tmp.png", width=fig.width, height=fig.width, bg="white", res=fig.res)

par(cex = 1.00)
plot(UStot.mtons, 
     xlim=c(1998,2009), 
     ylim=c(0.0,8.0), 
     type="n", 
     las=1,
     ylab="million tons",
     main="Total PM2.5 emission from all sources")
axis(3, at=years.data, col.ticks="red", padj=1, col.lab="red")
lines(UStot.mtons, col="orange", lty=3, lwd=3)
points(UStot.mtons, pch=23, col="red", lwd=3, bg="yellow")
par(cex = 1.00)

dev.off()

#-------------------------------------------------------------------------------
