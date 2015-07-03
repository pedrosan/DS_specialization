#-------------------------------------------------------------------------------
NEI.balto <- subset(NEI, fips=="24510")
NEI.la <- subset(NEI, fips=="06037")

balto.m <- ddply(NEI.balto, .(type, year), summarize, Emiss=sum(Emissions), lgEmiss=log10(sum(Emissions)))
balto.ByType.lin <- dcast(ddply(NEI.balto, .(type, year), summarize, Emiss=sum(Emissions)) , year ~ type, value.var="Emiss")
balto.ByType.log <- dcast(ddply(NEI.balto, .(type, year), summarize, Emiss=log10(sum(Emissions))) , year ~ type, value.var="Emiss")
colnames(balto.ByType.lin) <- c("year","NonRoad","NonPoint","OnRoad","Point")
colnames(balto.ByType.log) <- c("year","NonRoad","NonPoint","OnRoad","Point")

la.m <- ddply(NEI.la, .(type, year), summarize, Emiss=sum(Emissions), lgEmiss=log10(sum(Emissions)))
la.ByType.lin <- dcast(ddply(NEI.la, .(type, year), summarize, Emiss=sum(Emissions)) , year ~ type, value.var="Emiss")
la.ByType.log <- dcast(ddply(NEI.la, .(type, year), summarize, Emiss=log10(sum(Emissions))) , year ~ type, value.var="Emiss")
colnames(la.ByType.lin) <- c("year","NonRoad","NonPoint","OnRoad","Point")
colnames(la.ByType.log) <- c("year","NonRoad","NonPoint","OnRoad","Point")

#-------------------------------------------------------------------------------
# Q1: Have Total Emissions decreased between 1999 and 2008?
#     - Use 'base' plotting system
#     - Show 'total' emission from all sources for each of the years
#-------------------------------------------------------------------------------
UStot.mtons <- ddply(NEI, .(year), summarize, sum(Emissions)/1.0e6)
colnames(UStot.mtons)[2] <- "emissions"

years.all <- 1998:2009
years.data <- UStot.mtons$year

fig.width <- 640
fig.height <- 640
fig.res <- 108
png(filename=paste("q1lin_r",fig.res,".png",sep=""), width=fig.width, height=fig.width, bg="white", res=fig.res)

par(cex = 1.00)
plot(UStot.mtons, 
     xlim=c(1998,2009), 
     ylim=c(0.0,8.0), 
     type="n", 
     las=1,
     ylab="million tons",
     main="Total PM2.5 emission from all sources")
axis(3, at=years.data, col.ticks="red", padj=1, col.lab="red")
lines(UStot.mtons,
     col="orange", 
     lty=3,
     lwd=3)
points(UStot.mtons, pch=23, col="red", lwd=3, bg="yellow")
par(cex = 1.00)

dev.off()


#-------------------------------------------------------------------------------
# Q2: Have total emissions decreased in Baltimore between 1999 and 2008?
#     - Use 'base' plotting system
#-------------------------------------------------------------------------------
balto.ktotal <- ddply(NEI.balto, .(year), summarize, emissions=sum(Emissions)/1000.)
balto.ltotal <- ddply(NEI.balto, .(year), summarize, emissions=log10(sum(Emissions)))

y1y2 <- range(balto.ktotal$emissions)
y1y2s <- y1y2 + c(-1,1)*0.1*(y1y2[2]-y1y2[1])
# ylim=y1y2s,

fig.width <- 640
fig.height <- 640
fig.res <- 108
png(filename=paste("q2lin_r",fig.res,".png",sep=""),width=fig.width,height=fig.width,bg="white",res=fig.res)

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
par(cex = 0.6)
par(cex = 1.0)

dev.off()


#-------------------------------------------------------------------------------
# Q3: Which of the sources of the 4 'types' (point/nonpoint/onroad/nonroad)
#     have seen DEcreases in emission between 1999 and 2008 in Baltimore?
#     Which have seen INcreases in emission?
#     - Use 'ggplot2' 
#-------------------------------------------------------------------------------
gb <- ggplot(balto.m, aes(year, Emiss))
ylabstr <- "Emission (tons)"
forYscale <- 2.
y1y2s <- range(balto.m$Emiss)*c(1/forYscale,forYscale)

gb <- ggplot(balto.m, aes(year, lgEmiss))
ylabstr <- "log(Emission) (tons)"
y1y2 <- range(balto.m$lgEmiss)
y1y2s <- y1y2 + c(-1,1)*0.1*(y1y2[2]-y1y2[1])

# 1 box
gb + geom_point(aes(color=type,fill=type),size=4, pch=22) +
     geom_line(aes(color=type),lty=2) +
     theme_bw() +
     labs(title="Baltimore City\nPM2.5 emission by type") + 
     labs(y=ylabstr) +
     coord_cartesian(xlim=c(1998,2009),ylim=y1y2s) + 
     scale_y_log10(breaks=c(100,300,1000,3000))

# with facets (4x1)
gb + geom_point(aes(color=type,fill=type),size=4, pch=22) + 
     geom_line(aes(color=type),lty=2) + 
     theme_bw() +
     labs(title="Baltimore City: PM2.5 emission by type") + 
     labs(y=ylabstr) +
     coord_cartesian(xlim=c(1998,2009),ylim=y1y2s) +
     facet_wrap( ~ type, nrow=1,ncol=4) 

fig.width <- 1024
fig.height <- 1024
fig.res <- 108
png(filename=paste("q3lin_r",fig.res,".png",sep=""),width=fig.width,height=fig.width,bg="white",res=fig.res)
# ...
dev.off()

png(filename=paste("q3log_r",fig.res,".png",sep=""),width=fig.width,height=fig.width,bg="white",res=fig.res)
# ...
dev.off()
par(cex = 1.0)
#-------------------------------------------------------------------------------
# Q4: Across the US, how have emissions from COAL COMBUSTION RELATED sources
#     changed between 1998 and 2008?
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Q5: How have emissions from MOTOR VEHICLE SOURCES changed between 1998 and 2008
#     in Baltimore?
#-------------------------------------------------------------------------------
balto.OnRoad.total <- ddply(NEI.balto.OnRoad, .(year), summarize, emissions=sum(Emissions))
y1y2s <- range(balto.OnRoad.total$emissions)*c(0.9,1.1)
# ylim=y1y2s,

b_ticks <- seq(1, 4, by=1)
b_y_labels <- sapply(b_ticks, function(i) as.expression(bquote(10^ .(i))))
axis(1, at=c(10,100,1000,1000), labels=b_labels)

fig.width <- 640
fig.height <- 640
fig.res <- 108
png(filename=paste("q5log_r",fig.res,".png",sep=""),width=fig.width,height=fig.width,bg="white",res=fig.res)

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
n <- 1
lines(balto.OnRoad.total, col=clvec[n], lwd=2 , lty=2)
points(balto.OnRoad.total, pch=22, col=cvec[n], bg=cbgvec[n], lwd=3)
par(cex = 0.6)
par(cex = 1.0)

dev.off()

#-------------------------------------------------------------------------------
# Q6: Compare emissions from MOTOR VEHICLE SOURCES in Baltimore with those 
#     in Los Angeles.
#     Which city has seen greater changes over time in MOTOR VEHICLE emissions?
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

gcities <- ggplot(twoCities, aes(year,lgEmiss))
y1y2 <- range(twoCities$lgEmiss)
ylabstr <- "log(Emission) [tons]"

gcities <- ggplot(twoCities, aes(year,EmissScaled2First))
y1y2 <- range(twoCities$EmissScaled2First)
ylabstr <- "Emission scaled to 1999"

gcities <- ggplot(twoCities, aes(year,EmissScaled2Max))
y1y2 <- range(twoCities$EmissScaled2Max)
ylabstr <- "Emission scaled to Max"

# 1 box
y1y2s <- y1y2 + c(-1,1)*0.1*(y1y2[2]-y1y2[1])
gcities + geom_point(aes(color=Location,fill=Location),size=4, pch=22) +
     geom_line(aes(color=Location),lty=2) +
     theme_bw() +
     labs(title="Baltimore and Los Angeles\nPM2.5 emission from Motor Vehicle sources") + 
     labs(y=ylabstr) +
     coord_cartesian(xlim=c(1998,2009),ylim=y1y2s)
#   facet_wrap( ~ Location, nrow=1,ncol=2) 

fig.width <- 640
fig.height <- 640
fig.res <- 108
png(filename=paste("q6log_r",fig.res,".png",sep=""),width=fig.width,height=fig.width,bg="white",res=fig.res)
# ...
dev.off()

png(filename=paste("q3log_r",fig.res,".png",sep=""),width=fig.width,height=fig.width,bg="white",res=fig.res)
# ...
dev.off()

par(cex = 1.0)
#-------------------------------------------------------------------------------
