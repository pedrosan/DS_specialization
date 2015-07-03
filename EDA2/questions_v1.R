#-------------------------------------------------------------------------------
# Q1: Have Total Emissions decreased between 1999 and 2008?
#     - Use 'base' plotting system
#     - Show 'total' emission from all sources for each of the years
#-------------------------------------------------------------------------------
tot.mtons <- ddply(NEI, .(year), summarize, sum(Emissions)/1.0e6)
colnames(tot.mtons)[2] <- "emissions"

years.all <- 1998:2009
years.data <- tot.mtons$year

par(cex = 1.00)
plot(tot.mtons, 
     xlim=c(1998,2009), 
     ylim=c(0.0,8.0), 
     type="n", 
     las=1,
     ylab="million tons",
     main="Total PM2.5 emission from all sources")
axis(3, at=years.data, col.ticks="red", padj=1, col.lab="red")
lines(tot.mtons,
     col="orange", 
     lty=3,
     lwd=3)
points(tot.mtons, pch=23, col="red", lwd=3, bg="yellow")


#-------------------------------------------------------------------------------
# Q2: Have total emissions decreased in Baltimore between 1999 and 2008?
#     - Use 'base' plotting system
#-------------------------------------------------------------------------------
balto.ktotal <- ddply(balto, .(year), summarize, emissions=sum(Emissions)/1000.)

par(cex = 1.00)
plot(balto.ktotal, 
     type="n", 
     xlim=c(1998,2009), 
     ylim=range(balto.ktotal$emissions)*c(0.9,1.1), 
     lwd=3,
     las=1,
     xlab="Year",
     ylab="1000 tons",
     main="Baltimore City: PM2.5 Emission from all sources")
par(col.lab="red")
par(cex = 0.8)
axis(3, at=c(1999,2002,2005,2008), col.ticks="red", padj=1, col.lab="red")
par(cex = 1.0)
par(col.lab="black")
n <- 1
lines(balto.ktotal, col=clvec[n], lwd=2 , lty=2)
points(balto.ktotal, pch=22, col=cvec[n], bg=cbgvec[n], lwd=3)
par(cex = 0.60)

#-------------------------------------------------------------------------------
# Q3: Which of the sources of the 4 'types' (point/nonpoint/onroad/nonroad)
#     have seen DEcreases in emission between 1999 and 2008 in Baltimore?
#     Which have seen INcreases in emission?
#     - Use 'ggplot2' 
#-------------------------------------------------------------------------------
gb <- ggplot(balto.m, aes(year, emissions))

gb + geom_point(aes(color=type,fill=type),size=4, pch=22) 
   + geom_line(aes(color=type),lty=2) 
   + labs(y= "PM2.5 Emission by Type") 
   + labs(title="Baltimore City") 
   + theme_bw() 
   + coord_cartesian(ylim=c(-100,2300),xlim=c(1998,2009))

g + geom_point(aes(color=type),size=4) + geom_line(aes(color=type),lty=2)
g + geom_point(aes(color=type),size=4, pch=22) + geom_line(aes(color=type),lty=2) + labs(y= "PM2.5 Emission by Type") + labs(title="Baltimore City") + theme_bw()
g + geom_point(aes(color=type),size=4, pch=22) + geom_line(aes(color=type),lty=2) + labs(y= "PM2.5 Emission by Type") + labs(title="Baltimore City") + theme_bw() + coord_cartesian(ylim=c(-100,2300))
g + geom_point(aes(color=type,fill=type),size=4, pch=22) + geom_line(aes(color=type),lty=2) + labs(y= "PM2.5 Emission by Type") + labs(title="Baltimore City") + theme_bw() + coord_cartesian(ylim=c(-100,2300),xlim=c(1998,2009))
g + geom_point(aes(color=type,fill=type),size=4, pch=22) + facet_wrap( ~ type, nrow=1,ncol=4) + geom_line(aes(color=type),lty=2) + labs(y= "PM2.5 Emission by Type") + labs(title="Baltimore City") + theme_bw() + coord_cartesian(ylim=c(-100,2300),xlim=c(1998,2009))


#-------------------------------------------------------------------------------
# Q4: Across the US, how have emissions from COAL COMBUSTION RELATED sources
#     changed between 1998 and 2008?
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Q5: How have emissions from MOTOR VEHICLE SOURCES changed between 1998 and 2008
#     in Baltimore?
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Q6: Compare emissions from MOTOR VEHICLE SOURCES in Baltimore with those 
#     in Los Angeles.
#     Which city has seen greater changes over time in MOTOR VEHICLE emissions?
#-------------------------------------------------------------------------------
