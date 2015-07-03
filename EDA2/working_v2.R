#-------------------------------------------------------------------------------
# fips     : five-digit number (represented as a string) indicating the county
# SCC      : name of the source as indicated by a digit string (see SCC table)
# Pollutant: string indicating the pollutant
# Emissions: Amount of PM2.5 emitted, in tons
# type     : type of source (point, non-point, on-road, or non-road)
# year     : The year of emissions recorded
#-------------------------------------------------------------------------------
library(plyr)
library(reshape2)
library(ggplot2)

SCC <- readRDS("Source_Classification_Code.rds")
as.factor(NEI$SCC)
levels(SCC$Data.Category)
levels(SCC$EI.Sector)

NEI <- readRDS("./data/summarySCC_PM25.rds")
NEI$Pollutant <- NULL

# checking for NAs 
is.na(NEI$Emissions)
sum(is.na(NEI$Emissions))
sum(is.na(NEI$year))
sum(is.na(NEI))

#-------------------------------------------------------------------------------
# Number of entries for the two cities
sum(NEI$fips == "06037")  # Los Angeles
sum(NEI$fips == "24510")  # Baltimore
  
# Number of entries per year
sum(NEI$year == "1999")
sum(NEI$year == "2002")
sum(NEI$year == "2005")
sum(NEI$year == "2008")

ddply(NEI, .(year), summarize, max(Emissions))
ddply(NEI, .(year), summarize, min(Emissions))
ddply(NEI, .(year), summarize, median(Emissions))
dum <- ddply(NEI, .(year), summarize, summary(Emissions,digits=12))

nrows.by.year <- ddply(NEI, .(year), nrow)
colnames(nrows.by.year)[2] <- "nrows"
nr1999 <- nrows.by.year$nrows[1]
nr2002 <- nrows.by.year$nrows[2]
nr2005 <- nrows.by.year$nrows[3]
nr2008 <- nrows.by.year$nrows[4]

plot(1:nr1999, NEI$Emissions[which(NEI$year == "1999")])
ssE.1999 <- subset(NEI, year == "1999", select=Emissions)
ssE.2002 <- subset(NEI, year == "2002", select=Emissions)
ssE.2005 <- subset(NEI, year == "2005", select=Emissions)
ssE.2008 <- subset(NEI, year == "2008", select=Emissions)

ssE <- dlply(NEI, .(year), summarize, emiss= Emissions)
names(ssE) <- paste("y",names(ssE),sep="")
colnames(ssE[[1]]) <- "emiss"
colnames(ssE[[2]]) <- "emiss"
colnames(ssE[[3]]) <- "emiss"
colnames(ssE[[4]]) <- "emiss"

nrow(subset(ssE[[1]],emiss==0))
nrow(subset(ssE[[2]],emiss==0))
nrow(subset(ssE[[3]],emiss==0))
nrow(subset(ssE[[4]],emiss==0))

# ssE is a list of 4 data.frames (?!, gotta figure out how to do it better)
s99 <- subset(ssE[[1]],emiss>0)$emiss
s02 <- subset(ssE[[2]],emiss>0)$emiss
s05 <- subset(ssE[[3]],emiss>0)$emiss
s08 <- subset(ssE[[4]],emiss>0)$emiss

ddply(tt1,.(EI.Sector))
ddply(tt1,.(EI.Sector),length)

filter1 <- (grepl("On-Road", SCC$EI.Sector, perl=TRUE))
tt1b <- SCC[filter1,]

filter2 <- (grepl("On-Road", SCC$EI.Sector, perl=TRUE) & grepl("Total", SCC$SCC.Level.Four, perl=TRUE))
tt2 <- SCC[filter2,]
write.csv(tt2[,c(1,4,3,7:10)],file="tt2.csv")

#SCC[grepl("2230070\\d\\d\\d",SCC$SCC,perl=TRUE),]
filter3 <- (grepl("^2230070", NEI$SCC, perl=TRUE))
tt3 <- NEI[filter3,]

#-------------------------------------------------------------------------------
highE98pctY99 <- subset(NEI, year=="1999" & Emissions > 60.0)
highE98pctY02 <- subset(NEI, year=="2002" & Emissions > 14.7)
highE98pctY05 <- subset(NEI, year=="2005" & Emissions > 15.78)
highE98pctY08 <- subset(NEI, year=="2008" & Emissions >  8.75)

highE98pctY99[which.max(highE98pctY99$Emissions),]
highE98pctY02[which.max(highE98pctY02$Emissions),]
highE98pctY05[which.max(highE98pctY05$Emissions),]
highE98pctY08[which.max(highE98pctY08$Emissions),]

worse100Y99 <- highE98pctY99[order(highE98pctY99$Emissions, decreasing=TRUE),][1:100,]
worse100Y02 <- highE98pctY02[order(highE98pctY02$Emissions, decreasing=TRUE),][1:100,]
worse100Y05 <- highE98pctY05[order(highE98pctY05$Emissions, decreasing=TRUE),][1:100,]
worse100Y08 <- highE98pctY08[order(highE98pctY08$Emissions, decreasing=TRUE),][1:100,]

#-------------------------------------------------------------------------------
balto <- subset(NEI, fips=="24510")
la <- subset(NEI, fips=="06037")

balto.m <- ddply(balto, .(type, year), summarize, emiss=sum(Emissions))
balto.ByType <- dcast(balto.m, year ~ type, value.var="emiss")
colnames(balto.ByType) <- c("year","NonRoad","NonPoint","OnRoad","Point")

la.m <- ddply(la, .(type, year), summarize, emiss=sum(Emissions))
la.ByType <- dcast(la.m, year ~ type, value.var="emiss")
colnames(la.ByType) <- c("year","NonRoad","NonPoint","OnRoad","Point")

#-------------------------------------------------------------------------------
balto.total <- ddply(balto, .(year), summarize, emiss=sum(Emissions))

par(cex = 1.00)
#plot(balto.total, type="n", xlim=c(1998,2009), ylim=c(0,3400), lwd=3, ylab="Baltimore ... ")
plot(balto.total, 
     type="n", 
     xlim=c(1998,2009), 
     ylim=range(balto.total)*c(0.9,1.1), 
     lwd=3, 
     xlab="Year",
     ylab="Total PM2.5 Emission",
     main="Baltimore City")
par(col.lab="red")
axis(3, at=c(1999,2002,2005,2008), col.ticks="red", padj=1, col.lab="red")
par(col.lab="black")
n <- 1
lines(balto.total, col=clvec[n], lwd=2 , lty=2)
points(balto.total, pch=22, col=cvec[n], bg=cbgvec[n], lwd=3)
par(cex = 0.60)

#-------------------------------------------------------------------------------
cvec <- c("red2","blue2","darkgreen","black")
cbgvec <- c("red","blue","green","white")
clvec <- c("orange","cyan","forestgreen","grey50")
cbgvec <- clvec

plotEm <- function(n) {
    n1 <- n+1
    lines(balto.ByType[,c(1,n1)], col=clvec[n], lwd=2 , lty=2)
    points(balto.ByType[,c(1,n1)], pch=22, col=cvec[n], bg=cbgvec[n], lwd=3)
}
par(cex = 1.00)
plot(balto.ByType[,c(1,2)], type="n", xlim=c(1998,2009), ylim=c(0,2300), lwd=3, ylab="Baltimore ... ")
axis(3, at=c(1999,2002,2005,2008),col=NULL, col.ticks="red", padj=1)
plotEm(1)
plotEm(2)
plotEm(3)
plotEm(4)
par(cex = 0.60)
legend(x="topright",
       col=cvec,
       pt.bg=cbgvec,
       legend=c(colnames(balto.ByType)[-1]),
       pch=22)
par(cex = 1.00)


plot(balto.ByType[,c(1,2)], xlim=c(1998,2009), ylim=c(0,600), col="orange", type="l", lwd=3, ylab="Baltimore ... ")
points(balto.ByType[,c(1,2)], pch=22, col="red3", bg="red", lwd=3)

# w/ ggplot2
qplot(year,emiss,data=balto.m,color=type)

g <- ggplot(balto.m, aes(year, emiss))

g + geom_point(aes(color=type),size=4) + geom_line(aes(color=type),lty=2)
g + geom_point(aes(color=type),size=4, pch=22) + geom_line(aes(color=type),lty=2) + labs(y= "PM2.5 Emission by Type") + labs(title="Baltimore City") + theme_bw()
g + geom_point(aes(color=type),size=4, pch=22) + geom_line(aes(color=type),lty=2) + labs(y= "PM2.5 Emission by Type") + labs(title="Baltimore City") + theme_bw() + coord_cartesian(ylim=c(-100,2300))
g + geom_point(aes(color=type,fill=type),size=4, pch=22) + geom_line(aes(color=type),lty=2) + labs(y= "PM2.5 Emission by Type") + labs(title="Baltimore City") + theme_bw() + coord_cartesian(ylim=c(-100,2300),xlim=c(1998,2009))

g + geom_point(aes(color=type,fill=type),size=4, pch=22) + facet_wrap( ~ type, nrow=1,ncol=4) + geom_line(aes(color=type),lty=2) + labs(y= "PM2.5 Emission by Type") + labs(title="Baltimore City") + theme_bw() + coord_cartesian(ylim=c(-100,2300),xlim=c(1998,2009))
g + geom_point(aes(color=type,fill=type),size=4, pch=22) + facet_wrap( ~ type, nrow=4,ncol=1) + geom_line(aes(color=type),lty=2) + labs(y= "PM2.5 Emission by Type") + labs(title="Baltimore City") + theme_bw() + coord_cartesian(ylim=c(-100,2300),xlim=c(1998,2009))

#-------------------------------------------------------------------------------
filter.test <- (grepl("Prescribed", SCC$EI.Sector, perl=TRUE))
SCC.test <- as.character(SCC$SCC[filter.test])

filter.coal <- (grepl("Coal", SCC$EI.Sector, perl=TRUE))
SCC.coal <- as.character(SCC$SCC[filter.coal])
US.coal <- subset(NEI, SCC %in% SCC.coal)

#-------------------------------------------------------------------------------
filter.OnRoad <- (grepl("On-Road", SCC$EI.Sector, perl=TRUE))
SCC.OnRoad <- as.character(SCC$SCC[filter.OnRoad])

NEI.balto.OnRoad<- subset(NEI.balto, SCC %in% SCC.OnRoad)
NEI.la.OnRoad<- subset(NEI.la, SCC %in% SCC.OnRoad)

balto.OnRoad.m <- ddply(NEI.balto.OnRoad, .(year), summarize, Emiss=sum(Emissions), lgEmiss=log10(sum(Emissions)))
balto.m.expanded <-  transform(balto.OnRoad.m, EmissScaled2Max=Emiss/max(Emiss), EmissScaled2First=Emiss/Emiss[1], Location="Baltimore")
la.OnRoad.m <- ddply(NEI.la.OnRoad, .(year), summarize, Emiss=sum(Emissions), lgEmiss=log10(sum(Emissions)))
la.m.expanded <- transform(la.OnRoad.m, EmissScaled2Max=Emiss/max(Emiss), EmissScaled2First=Emiss/Emiss[1], Location="LosAngeles")
twoCities <- rbind(balto.m.expanded,la.m.expanded)

gcities <- ggplot(twoCities, aes(year,EmissScaled2First))

gcities <- ggplot(twoCities, aes(year,EmissScaled2Max))

gcities + geom_point(aes(color=Location, fill=Location),size=4,pch=22)


#-------------------------------------------------------------------------------