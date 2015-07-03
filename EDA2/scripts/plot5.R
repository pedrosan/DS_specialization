#-------------------------------------------------------------------------------
# Q5: How have emissions from MOTOR VEHICLE SOURCES changed between 1998 and 2008
#     in Baltimore?
#-------------------------------------------------------------------------------
library(plyr)
library(reshape2)
library(ggplot2)

#---------------------------------------
# data loading
#---------------------------------------
SCC <- readRDS("Source_Classification_Code.rds")
NEI <- readRDS("./data/summarySCC_PM25.rds")

#---------------------------------------
# data preparation
#---------------------------------------
filter.OnRoad <- (grepl("On-Road", SCC$EI.Sector, perl=TRUE))
SCC.OnRoad <- as.character(SCC$SCC[filter.OnRoad])

NEI.balto <- subset(NEI, fips=="24510")
NEI.balto.OnRoad<- subset(NEI.balto, SCC %in% SCC.OnRoad)

balto.OnRoad.total <- ddply(NEI.balto.OnRoad, .(year), summarize, emissions=sum(Emissions))
forYscale <- 1.1
y1y2s <- range(balto.OnRoad.total$emissions)*c(1/forYscale,forYscale)

#---------------------------------------
# plotting section
#---------------------------------------
fig.width <- 640
fig.height <- 640
fig.res <- 108

# png(filename=paste("q5log_r",fig.res,".png",sep=""),width=fig.width,height=fig.width,bg="white",res=fig.res)
png(filename="plot5_tmp.png", width=fig.width, height=fig.width, bg="white", res=fig.res)

par(cex = 1.00)
par(cex.main = 0.80)
plot(balto.OnRoad.total, 
     type="n", 
     xlim=c(1998,2009), 
     ylim=y1y2s,
     log="y",
     lwd=3,
     las=1,
     xlab="Year",
     ylab="tons",
     main="Baltimore City\nPM2.5 Emission from Motor Vehicle sources")

par(col.lab="red")
par(cex = 0.8)
axis(3, at=c(1999,2002,2005,2008), col.ticks="red", padj=1.2, col.lab="red")

par(cex = 1.0)
par(col.lab="black")
lines(balto.OnRoad.total, col="orange", lwd=2 , lty=2)
points(balto.OnRoad.total, pch=22, col="red2", bg="orange", lwd=3)

par(cex = 1.0)

dev.off()

#-------------------------------------------------------------------------------
