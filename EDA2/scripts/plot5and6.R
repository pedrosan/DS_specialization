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
balto.OnRoad.m <- ddply(NEI.balto.OnRoad, .(year), summarize, Emiss=sum(Emissions), lgEmiss=log10(sum(Emissions)))
balto.m.expanded <-  transform(balto.OnRoad.m, EmissScaled2Max=Emiss/max(Emiss), EmissScaled2First=Emiss/Emiss[1], Location="Baltimore")

NEI.la <- subset(NEI, fips=="06037")
NEI.la.OnRoad<- subset(NEI.la, SCC %in% SCC.OnRoad)
la.OnRoad.m <- ddply(NEI.la.OnRoad, .(year), summarize, Emiss=sum(Emissions), lgEmiss=log10(sum(Emissions)))
la.m.expanded <- transform(la.OnRoad.m, EmissScaled2Max=Emiss/max(Emiss), EmissScaled2First=Emiss/Emiss[1], Location="LosAngeles")

twoCities <- rbind(balto.m.expanded,la.m.expanded)

#-------------------------------------------------------------------------------
# Q5: How have emissions from MOTOR VEHICLE SOURCES changed between 1998 and 2008
#     in Baltimore?
#-------------------------------------------------------------------------------
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
# Q6: Compare emissions from MOTOR VEHICLE SOURCES in Baltimore with those 
#     in Los Angeles.
#     Which city has seen greater changes over time in MOTOR VEHICLE emissions?
#-------------------------------------------------------------------------------

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
