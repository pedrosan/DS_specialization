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
