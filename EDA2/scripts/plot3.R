#-------------------------------------------------------------------------------
# Q3: Which of the sources of the 4 'types' (point/nonpoint/onroad/nonroad)
#     have seen DEcreases in emission between 1999 and 2008 in Baltimore?
#     Which have seen INcreases in emission?
#     - Use 'ggplot2' 
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
NEI.balto <- subset(NEI, fips=="24510")
balto.m <- ddply(NEI.balto, .(type, year), summarize, Emiss=sum(Emissions), lgEmiss=log10(sum(Emissions)))

#---------------------------------------
# plotting section
#---------------------------------------
gb <- ggplot(balto.m, aes(year, Emiss))
ylabstr <- "Emission (tons)"
forYscale <- 2.
y1y2s <- range(balto.m$Emiss)*c(1/forYscale,forYscale)

fig.width <- 640
fig.height <- 640
fig.res <- 108

png(filename="plot3_tmp.png", width=fig.width, height=fig.width, bg="white", res=fig.res)

gb + geom_point(aes(color=type,fill=type),size=4, pch=22) +
     geom_line(aes(color=type),lty=2) +
     theme_bw() +
     labs(title="Baltimore City\nPM2.5 emission by type") + 
     labs(y=ylabstr) +
     coord_cartesian(xlim=c(1998,2009),ylim=y1y2s) + 
     scale_y_log10(breaks=c(100,300,1000,3000))

dev.off()

#-------------------------------------------------------------------------------
