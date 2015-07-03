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

## https://github.com/GensLabs/Exploratory-Data-Analysis/blob/master/plot3.R
## ggplot(data=MD, aes(x=year, y=log(Emissions))) + facet_grid(. ~ type) + guides(fill=F) +
##     geom_boxplot(aes(fill=type)) + stat_boxplot(geom ='errorbar') +
##     ylab(expression(paste('Log', ' of PM'[2.5], ' Emissions'))) + xlab('Year') + 
##     ggtitle('Emissions per Type in Baltimore City, Maryland') +
##     geom_jitter(alpha=0.10)

#-------------------------------------------------------------------------------
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
#-------------------------------------------------------------------------------
# Q6: Compare emissions from MOTOR VEHICLE SOURCES in Baltimore with those 
#     in Los Angeles.
#     Which city has seen greater changes over time in MOTOR VEHICLE emissions?
#-------------------------------------------------------------------------------
library(plyr)
library(reshape2)
library(ggplot2)

#---------------------------------------
# data loading
#---------------------------------------
# REMEMBER TO UNCOMMENT
SCC <- readRDS("Source_Classification_Code.rds")
NEI <- readRDS("./data/summarySCC_PM25.rds")

#---------------------------------------
# data preparation
#---------------------------------------
filter.OnRoad <- (grepl("On-Road", SCC$EI.Sector, perl=TRUE))
SCC.OnRoad <- as.character(SCC$SCC[filter.OnRoad])

NEI.balto.OnRoad<- subset(NEI.balto, SCC %in% SCC.OnRoad)
balto.OnRoad.m <- ddply(NEI.balto.OnRoad, .(year), summarize, Emiss=sum(Emissions), lgEmiss=log10(sum(Emissions)))
balto.m.expanded <-  transform(balto.OnRoad.m, EmissScaled2Max=Emiss/max(Emiss), EmissScaled2First=Emiss/Emiss[1], Location="Baltimore")

NEI.la.OnRoad<- subset(NEI.la, SCC %in% SCC.OnRoad)
la.OnRoad.m <- ddply(NEI.la.OnRoad, .(year), summarize, Emiss=sum(Emissions), lgEmiss=log10(sum(Emissions)))
la.m.expanded <- transform(la.OnRoad.m, EmissScaled2Max=Emiss/max(Emiss), EmissScaled2First=Emiss/Emiss[1], Location="LosAngeles")

twoCities <- rbind(balto.m.expanded,la.m.expanded)

#---------------------------------------
# plotting section : 3 different plots
#---------------------------------------

fig.width <- 640
fig.height <- 640
fig.res <- 108

#-----------------------------
# plot6a : scaled to 1999
png(filename="plot6a_tmp.png", width=fig.width, height=fig.width, bg="white", res=fig.res)

gcities <- ggplot(twoCities, aes(year,EmissScaled2First))
y1y2 <- range(twoCities$EmissScaled2First)
ylabstr <- "Emission scaled to 1999"

y1y2s <- y1y2 + c(-1,1)*0.1*(y1y2[2]-y1y2[1])

gcities + geom_point(aes(color=Location,fill=Location),size=4, pch=22) +
     geom_line(aes(color=Location),lty=2) +
     theme_bw() +
     labs(title="Baltimore and Los Angeles\nPM2.5 emission from Motor Vehicle sources") + 
     labs(y=ylabstr) +
     coord_cartesian(xlim=c(1998,2009),ylim=y1y2s) +
     facet_wrap( ~ Location, nrow=1,ncol=2) 

dev.off()

#-----------------------------
# plot6b : scaled to max
png(filename="plot6b_tmp.png", width=fig.width, height=fig.width, bg="white", res=fig.res)

gcities <- ggplot(twoCities, aes(year,EmissScaled2Max))
y1y2 <- range(twoCities$EmissScaled2Max)
ylabstr <- "Emission scaled to Max"

y1y2s <- y1y2 + c(-1,1)*0.1*(y1y2[2]-y1y2[1])

gcities + geom_point(aes(color=Location,fill=Location),size=4, pch=22) +
     geom_line(aes(color=Location),lty=2) +
     theme_bw() +
     labs(title="Baltimore and Los Angeles\nPM2.5 emission from Motor Vehicle sources") + 
     labs(y=ylabstr) +
     coord_cartesian(xlim=c(1998,2009),ylim=y1y2s) 


dev.off()

#-----------------------------
# plot6c : non-scaled, lo(Y)
png(filename="plot6c_tmp.png", width=fig.width, height=fig.width, bg="white", res=fig.res)

gcities <- ggplot(twoCities, aes(year,Emiss))
y1y2 <- range(twoCities$Emiss)
ylabstr <- "Emission [tons]"

forYscale <- 2
y1y2s <- y1y2*c(1/forYscale,forYscale)

gcities + geom_point(aes(color=Location,fill=Location),size=4, pch=22) +
     geom_line(aes(color=Location),lty=2) +
     theme_bw() +
     labs(title="Baltimore and Los Angeles\nPM2.5 emission from Motor Vehicle sources") + 
     labs(y=ylabstr) +
     coord_cartesian(xlim=c(1998,2009),ylim=y1y2s) +
     scale_y_log10(breaks=c(100,300,1000,3000,1e4))

dev.off()

#-------------------------------------------------------------------------------
