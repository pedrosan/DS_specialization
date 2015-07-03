#-------------------------------------------------------------------------------
# fips     : five-digit number (represented as a string) indicating the county
# SCC      : name of the source as indicated by a digit string (see SCC table)
# Pollutant: string indicating the pollutant
# Emissions: Amount of PM2.5 emitted, in tons
# type     : type of source (point, non-point, on-road, or non-road)
# year     : The year of emissions recorded
#-------------------------------------------------------------------------------

SCC <- readRDS("Source_Classification_Code.rds")
NEI <- readRDS("./data/summarySCC_PM25.rds")

sum(NEI$fips == "06037")
sum(NEI$fips == "24510")

sum(NEI$year == "1999")
sum(NEI$year == "2002")
sum(NEI$year == "2005")
sum(NEI$year == "2008")
as.factor(NEI$SCC)
levels(SCC$Data.Category)
levels(SCC$EI.Sector)
x <- levels(SCC$EI.Sector)
cat(x,file="pop",fill=TRUE)
unclass(levels(SCC$EI.Sector))
cat(unclass(x),file="pop",fill=TRUE)
write.csv(x,file="pop")
as.factor(SCC$Option.Group)
levels(as.factor(SCC$Option.Group))
unclass(levels(as.factor(SCC$Option.Group)))
levels(as.factor(SCC$Option.Group))
cbind(1:25,levels(as.factor(SCC$Option.Group)))
cbind(1:18,levels(as.factor(SCC$Option.Set)))
levels(as.factor(SCC$Option.Set))
levels(as.factor(SCC$SCC.Level.One))
cbind(1:17,levels(as.factor(SCC$SCC.Level.One)))
cbind(1:146,levels(as.factor(SCC$SCC.Level.Two)))
SCC[SCC$SCC == "10100101",]
which(SCC$SCC == "10100101")
SCC$SCC[1]
SCC$SCC[1,]
?which
?ddply
library(plyr)
?ddply
hist(NEI$Emissions[NEI$year=="1999",])
hist(NEI$Emissions[which(NEI$year=="1999"),])
hist(NEI$Emissions[which(NEI$year=="1999")])
max(NEI$Emissions[which(NEI$year=="1999")])
max(NEI$Emissions[which(NEI$year=="1999" & NEI$Emissions < 10000)])
max(NEI$Emissions[which(NEI$year=="1999" & NEI$Emissions > 10000)])
hist(NEI$Emissions[which(NEI$year=="1999" & NEI$Emissions < 7000)])
length(NEI$Emissions[which(NEI$year=="1999" & NEI$Emissions > 10000)])
length(NEI$Emissions[which(NEI$year=="1999" & NEI$Emissions > 1000)])
length(NEI$Emissions[which(NEI$year=="1999" & NEI$Emissions > 600)])
hist(NEI$Emissions[which(NEI$year=="1999" & NEI$Emissions < 500)])
length(NEI$Emissions[which(NEI$year=="1999" & NEI$Emissions > 50)])
length(NEI$Emissions[which(NEI$year=="1999" & NEI$Emissions > 20)])
hist(NEI$Emissions[which(NEI$year=="1999" & NEI$Emissions < 20)])
is.na(NEI$Emissions)
sum(is.na(NEI$Emissions))
sum(is.na(NEI$year))
sum(is.na(NEI))
boxplot(NEI$Emissions[NEI$year=="1999"])
summary(NEI$Emissions[NEI$year=="1999"])
which.max(NEI$Emissions[NEI$year=="1999"])
NEI[408647,]
NEI[which.max(NEI$Emissions[NEI$year=="1999"]),]
NEI[which.max(NEI$Emissions[NEI$year=="2002"]),]
v1 <- runif(20)
v1
v1 <- runif(20)*10
v1
v1 <- runif(20)*10
v2 <- sample(c=(1999,2002),20)
v2 <- sample(c=(1999,2002),size=20)
?sample
v2 <- sample(c=(1999,2002), 20, replace=TRUE)
v2 <- sample(c(1999,2002), 20, replace=TRUE)
v2
dfv <- data.frame(v2,v1)
dfv
colnames(dfv) <- c("year","emission")
dfv <- data.frame(v2,v1)
colnames(dfv) <- c("year","emission")
dfv
which.max(dfv$emission[dfv$year==1999])
dfv$emission[dfv$year==1999]
?ddply
ddply(dfv, .(year))
ddply(dfv, .(year)),summarize,c(min.max)
ddply(dfv, .(year)),summarize,c(min.max))
ddply(dfv, .(year)),summarize,min)
ddply(dfv, .(year),summarize,min)
ddply(dfv, .(year), c("min","max"))
ddply(dfv[,2], .(year), c("min","max"))
ddply(dfv, .(year), min(emission))
ddply(dfv, .(year), summarize, min(emission))
ddply(dfv, .(year), summarize, max(emission))
ddply(dfv, .(year), summarize, which.max(emission))
ddply(NEI, .(year), summarize, max(Emissions))
ddply(NEI, .(year), summarize, mix(Emissions))
ddply(NEI, .(year), summarize, min(Emissions))
ddply(NEI, .(year), summarize, median(Emissions))
NEI[NEI$SCC==31400901,]
SCC[SCC$SCC==31400901,]
nrow(SCC[SCC$SCC==31400901,])
SCC[SCC$SCC==31400901,]
SCC[SCC$SCC==31400901,]
SCC[SCC$SCC==31400901,]
t(SCC[SCC$SCC==31400901,])
SCC[SCC$EI.Sector=="On-Road",]
SCC[grep("On-Road",SCC$EI.Sector),]
tt<-SCC[grep("On-Road",SCC$EI.Sector),]
str(tt)
tt[,c(1,4)]
table(tt[,c(1,4)])
str(tt)
ddply(tt,.(EI.Sector))
ddply(tt,.(EI.Sector),length)
str(tt)
nrow(tt)
str(tt)
levels(SCC$SCC)
unique(SCC$SCC)
str(tt)
SCC$SCC
unclass(SCC$SCC)
as.numeric(SCC$SCC)
unclass(tt$SCC)
as.numeric(tt$SCC)
unique(tt$SCC)
as.numeric(tt$SCC)
as.character(tt$SCC)
unique(as.character(tt$SCC))
str(tt)
table(tt[,c(1,4)])
tt[,c(1,4)]
nrow(ww)
nrow(tt)
str(tt)
tt[,c(1,4,3)]
tt[,c(1,4,3)]
write.csv(tt[,c(1,4,3,7:10)],file="ppp.csv")
write.csv(SCC[,c(1,4,3,7:10)],file="SCC.csv")
SCC[grep("On-Road",SCC$EI.Sector)&grep("Total",SCC$SCC.Level.Four),]
SCC[(grep("On-Road",SCC$EI.Sector)&grep("Total",SCC$SCC.Level.Four)),]
SCC[grep("Total",SCC$SCC.Level.Four),]
SCC[grep("Total",SCC$SCC.Level.Four),][,10]
(grep("On-Road",SCC$EI.Sector)&grep("Total",SCC$SCC.Level.Four))
filter <- (grep("On-Road",SCC$EI.Sector)&grep("Total",SCC$SCC.Level.Four))
length(SCC$SCC.Level.Four)
length(SCC$EI.Sector)
SCC$SCC.Level.Four
grep("Lithography",SCC$SCC.Level.Four)
filter <- (grepl("On-Road",SCC$EI.Sector)&grepl("Total",SCC$SCC.Level.Four))
length(filter)
SCC[(grepl("On-Road",SCC$EI.Sector)&grepl("Total",SCC$SCC.Level.Four)),]
tt2<-SCC[(grepl("On-Road",SCC$EI.Sector)&grepl("Total",SCC$SCC.Level.Four)),]
write.csv(tt2[,c(1,4,3,7:10)],file="tt2.csv")
SCC[grepl("2230070\\d\\d\\d",SCC$SCC,perl=TRUE)]
SCC[grepl("2230070\\d\\d\\d",SCC$SCC,perl=TRUE),]
tt3<-SCC[grepl("2230070\\d\\d\\d",SCC$SCC,perl=TRUE),]
str(tt3)
tt3<-NEI[grepl("2230070\\d\\d\\d",NEI$SCC,perl=TRUE),]
nrow(tt3)
tt3
tt3<-NEI[grepl("^2230070",NEI$SCC,perl=TRUE),]
nrow(tt3)
which(NEI$SCC == "2230070")
which(as.character(NEI$SCC) == "2230070")
which(as.character(NEI$SCC) = "2230070")
NEI$SCC[1:40]
write.csv(NEI$SCC,file"nei_scc.csv")
write.csv(NEI$SCC,file="nei_scc.csv")
SCC$SCC[(grepl("On-Road",SCC$EI.Sector)]
SCC$SCC[grepl("On-Road",SCC$EI.Sector)]
qqq<-SCC$SCC[grepl("On-Road",SCC$EI.Sector)]
nrow(qqq)
str(qqq)
filter <- grepl("On-Road",SCC$EI.Sector)
nrow(filter)

str(filter)
length(filter)
