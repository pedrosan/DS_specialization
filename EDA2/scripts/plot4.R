#-------------------------------------------------------------------------------
# Q4: Across the US, how have emissions from COAL COMBUSTION RELATED sources
#     changed between 1998 and 2008?
#-------------------------------------------------------------------------------
library(plyr)
library(reshape2)
library(ggplot2)

#---------------------------------------
# data loading
#---------------------------------------
# REMEMBER TO UNCOMMENT
#SCC <- readRDS("Source_Classification_Code.rds")
#NEI <- readRDS("./data/summarySCC_PM25.rds")

#---------------------------------------
# data preparation
#---------------------------------------
filter.coal <- (grepl("Coal", SCC$EI.Sector, perl=TRUE))
SCC.coal <- as.character(SCC$SCC[filter.coal])
US.coal <- subset(NEI, SCC %in% SCC.coal)

US.coal.tot <- ddply(US.coal, .(year), summarize, emissions=sum(Emissions)/1.0e3)

#---------------------------------------
# plotting section
#---------------------------------------
years.data <- UStot.mtons$year

forYscale <- 1.1
y1y2s <- range(US.coal.tot$emissions)*c(1/forYscale,forYscale)

fig.width <- 640
fig.height <- 640
fig.res <- 108
png(filename="plot4_tmp.png", width=fig.width, height=fig.width, bg="white", res=fig.res)

par(cex = 1.0)
par(cex.main = 1.0)
plot(US.coal.tot, 
     xlim=c(1998,2009), 
     ylim=y1y2s,
     type="n", 
     las=1,
     ylab="1000s tons",
     main="US: PM2.5 emission\nfrom coal-combustion related sources")
par(cex = 0.8)
axis(3, at=years.data, col.ticks="red", padj=1, col.lab="red")

par(cex = 1.0)
lines(US.coal.tot, col="orange", lty=3, lwd=3)
points(US.coal.tot, pch=23, col="red", lwd=3, bg="yellow")
par(cex = 1.0)

dev.off()

#-------------------------------------------------------------------------------
