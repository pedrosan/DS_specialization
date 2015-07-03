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

SCC <- readRDS("Source_Classification_Code.rds")
NEI <- readRDS("./data/summarySCC_PM25.rds")

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

as.factor(NEI$SCC)
levels(SCC$Data.Category)
levels(SCC$EI.Sector)

# hunting the outlier(s)
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

boxplot(NEI$Emissions[NEI$year=="1999"])
summary(NEI$Emissions[NEI$year=="1999"])
which.max(NEI$Emissions[NEI$year=="1999"])

ddply(NEI, .(year), summarize, max(Emissions))
ddply(NEI, .(year), summarize, mix(Emissions))
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

# plot(1:nr1999, subsetNEI$Emissions[which(NEI$year == "1999")])

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

filter1 <- (grepl("On-Road", SCC$EI.Sector))
tt1b <- SCC[filter1,]

filter2 <- (grepl("On-Road", SCC$EI.Sector) & grepl("Total", SCC$SCC.Level.Four))
tt2 <- SCC[filter2,]
write.csv(tt2[,c(1,4,3,7:10)],file="tt2.csv")

SCC[grepl("2230070\\d\\d\\d",SCC$SCC,perl=TRUE),]
tt3 <- NEI[grepl("^2230070",NEI$SCC,perl=TRUE),]

