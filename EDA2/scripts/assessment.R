NEI$fips <- factor(NEI$fips)
NEI$Pollutant <- factor(NEI$Pollutant)
NEI$type <- factor(NEI$type)
NEI$year <- factor(NEI$year)
NEI$SCC <- factor(NEI$SCC)

bMD <- NEI[NEI$fips == "24510"]

bMD.peryr <- tapply(bMD$Emissions,bMD$year,sum)

qplot(type, weight=Emissions, data=bMD,
      fill=year, order=year, color=year,
      position="dodge", geom="bar",
      main = "Which Sources in Baltimore Decreased Emissions?", 
      xlab="Source Type", ylab="Emissions")

SCC.Coal <- SCC[unique(sort(unlist( lapply(SCC, function(x) grep("Coal",levels(x))) ))),]

#--------------------------------------------------------------------------------------------------
emissions.by.year <- ddply(save.NEI, .(year), function(df) sum(df$Emissions))

#--------------------------------------------------------------------------------------------------
# Look for coal matches in description columns
coal_inx <- lapply(
    names(SCC)[c(3:4, 6:9)], 
    function(x) grep("coal", tolower(SCC[[x]]))
)

# Find coal sources id numbers
coal_scc <- as.character(
    unique(
        SCC[unique(unlist(coal_inx)), "SCC"]
    )
)

coal_data <- NEI[i=SCC %in% coal_scc, 
                 j=list(Emissions_by_year = sum(Emissions)), 
                 by = "year"]

detach("package:RMySQL", unload=TRUE)

library(sqldf)
myData <- sqldf("SELECT year, type, sum(Emissions) As Emissions FROM NEI WHERE fips = '24510' GROUP BY type, year")


