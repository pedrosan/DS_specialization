#-------------------------------------------------------------------------------
# Q2: Have total emissions decreased in Baltimore between 1999 and 2008?
#     - Use 'base' plotting system
#-------------------------------------------------------------------------------
library(plyr)
library(reshape2)
library(ggplot2)

#---------------------------------------
# data loading
#---------------------------------------
# SCC <- readRDS("Source_Classification_Code.rds")
NEI <- readRDS("./data/summarySCC_PM25.rds")

#---------------------------------------
# data preparation
#---------------------------------------
NEI.balto <- subset(NEI, fips=="24510")
balto.ktotal <- ddply(NEI.balto, .(year), summarize, emissions=sum(Emissions)/1000.)

#---------------------------------------
# plotting section
#---------------------------------------
forYscale <- 1.3
y1y2s <- range(balto.ktotal$emissions)*c(1/forYscale,forYscale)

fig.width <- 640
fig.height <- 640
fig.res <- 108
#png(filename=paste("q2_r",fig.res,".png",sep=""),width=fig.width,height=fig.width,bg="white",res=fig.res)
png(filename="plot2_tmp.png", width=fig.width, height=fig.width, bg="white", res=fig.res)

par(cex = 1.00)
par(cex.main = 1.00)
plot(balto.ktotal, 
     type="n", 
     xlim=c(1998,2009), 
     ylim=y1y2s,
     log="y",
     lwd=3,
     las=1,
     xlab="Year",
     ylab="Emission [1000 tons]",
     main="Baltimore City\nPM2.5 Emission from all sources")
par(col.lab="red")
par(cex = 0.8)
axis(3, at=c(1999,2002,2005,2008), col.ticks="red", padj=1.2, col.lab="red")
par(cex = 1.0)
par(col.lab="black")
lines(balto.ktotal, col="orange", lwd=2 , lty=2)
points(balto.ktotal, pch=22, col="red2", bg="orange", lwd=3)
par(cex = 1.0)

dev.off()

#-------------------------------------------------------------------------------
