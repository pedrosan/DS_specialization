
colors.am <- c("blue2","red2"); 
colors.fill.am <- c("skyblue2","red"); 
cvec.am <- ifelse(mtcars$am==0, colors.am[1], colors.am[2])
cvec.fill.am <- ifelse(mtcars$am==0, colors.fill.am[1], colors.fill.am[2])

colors.cyl <- c("blue2","green2","red2"); 
colors.fill.cyl <- c("skyblue2","green","red"); 
cvec.cyl <- ifelse(mtcars$cyl==4, colors.cyl[1], ifelse(mtcars$cyl==6, colors.cyl[2], colors.cyl[3]))
cvec.fill.cyl <- ifelse(mtcars$cyl==4, colors.fill.cyl[1], ifelse(mtcars$cyl==6, colors.fill.cyl[2], colors.fill.cyl[3]))

printStats <- function (m, with.cx=TRUE) {
    if (class(m) != "lm") stop("Not an object of class 'lm' ")
    f <- summary(m)$fstatistic
    p <- pf(f[1], f[2], f[3], lower.tail=FALSE)
    attributes(p) <- NULL
    
    fml <- as.character(formula(m))
    cx <- summary(m)$coeff
    stars <- rep(" ", nrow(cx))
    stars[cx[,4] <= 0.1] <- "."
    stars[cx[,4] <= 0.05] <- "*"
    stars[cx[,4] <= 0.01] <- "**"
    stars[cx[,4] <= 0.001] <- "***"
    cat("MODEL        : ", sprintf("%s", paste(fml[c(2,1,3)], sep=" ", collapse=" ")), "\n", sep="")
    cat("SUMMARY STATS: ")
    cat("R^2 = ",sprintf("%6.4f",summary(m)$r.squared), "  (adj. = ", sprintf("%6.4f",summary(m)$adj.r.squared), ")", sep="")
    cat("\n")
    cat("               ")
    cat("F-stats: ", sprintf("%.3f",f[1]), " on ", f[2], " and ", f[3], " DF,  p-value: ", p, "\n", sep="")
    # cat("R^2 = ",sprintf("%6.4f",summary(m)$r.squared), "   (adj. = ", sprintf("%6.4f",summary(m)$adj.r.squared), ")\n", sep="")
    # cat("\n")
    # cat("F-statistics : ", f[1], " on ", f[2], " and ", f[3], " DF,  p-value: ", p, "\n", sep="")
    if( with.cx ) {
        #cat("PARAMETERS   :\n")
        cat("\n")
        print(cbind(format(cx[,c(1,2,4)], scientific=TRUE, justify="right", digits=5), Signif=stars), quote=FALSE, print.gap=3)
    }
}

printStats.cpt <- function (m, with.cx=TRUE) {
    if (class(m) != "lm") stop("Not an object of class 'lm' ")
    f <- summary(m)$fstatistic
    p <- pf(f[1], f[2], f[3], lower.tail=FALSE)
    attributes(p) <- NULL
    
    fml <- as.character(formula(m))
    cx <- summary(m)$coeff
    stars <- rep(" ", nrow(cx))
    stars[cx[,4] <= 0.1] <- "."
    stars[cx[,4] <= 0.05] <- "*"
    stars[cx[,4] <= 0.01] <- "**"
    stars[cx[,4] <= 0.001] <- "***"
    cat("MODEL : ", sprintf("%s", paste(fml[c(2,1,3)], sep=" ", collapse=" ")), "\n", sep="")
    cat("      : ")
    cat("adj. R^2 = ", sprintf("%6.4f",summary(m)$adj.r.squared), " /  F-stats: ", sprintf("%.3f",f[1]), " on ", f[2],",", f[3], " Df,  p-value: ", p, "\n", sep="")
    if( with.cx ) {
        print(cbind(format(cx[,c(1,2,4)], scientific=TRUE, justify="right", digits=5), Signif=stars), quote=FALSE, print.gap=3)
        cat("\n")
    }
}

panel.cor <- function(x, y, digits = 2, prefix = "", cex.cor, color.bg=FALSE, ...) {
    usr <- par("usr"); on.exit(par(usr))
    par(usr = c(0, 1, 0, 1))
    r <- abs(cor(x, y))
    txt <- format(c(r, 0.123456789), digits = digits)[1]
    txt <- paste0(prefix, txt)
    if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
    # cvec.bg <- c(rgb(1.0, 0.5, 0.5) , rgb(0.5, 0.5, 1.0), rgb(0.5, 1.0, 0.5))
    cvec.bg <- c(rgb(1.0, 0.8, 0.9) , rgb(0.9, 0.9, 1.0), rgb(0.8, 1.0, 0.8))
    cvec.text <- c("red", "blue", rgb(0.0, 0.67, 0.0))
    i.color <- 1+(r>0.7)+(r>0.8)
    if( color.bg ) {
       ll <- par("usr") 
       rect(ll[1], ll[3], ll[2], ll[4], col=cvec.bg[i.color])
       # text(0.5, 0.5, txt, cex = cex.cor * r, col="white")
       text(0.5, 0.5, txt, cex = cex.cor * r, col=cvec.text[i.color])
    } else {
       # text(0.5, 0.5, txt, cex = cex.cor * r, col= 2+(r>0.7)+(r>0.8))
       text(0.5, 0.5, txt, cex = cex.cor * r, col=cvec.text[i.color])
    }
}

# panel.lmline = function (x, y, col = par("col"), bg = NA, pch = par("pch"), cex = 1, col.smooth = "red", ...) {
#     points(x, y, pch = pch, col = col, bg = bg, cex = cex)
#     ok <- is.finite(x) & is.finite(y)
#     if (any(ok)) 
#        abline(lm(y[ok] ~ x[ok]), 
#            col = col.smooth, ...)
# }

mypanel <- function(x, y, ...){
   # count <<- count+1 
   # bg <- if(count %in% c(1,4,9,12)) "#FDFF65" else "transparent"    
   cvec.bg <- c(rgb(1.0, 0.8, 0.9) , rgb(0.9, 0.9, 1.0), rgb(0.8, 1.0, 0.8))
   cvec.border <- c("red", "blue", rgb(0.0, 0.67, 0.0))
   r <- abs(cor(x, y))
   #bg <- 1+(r>0.7)+(r>0.8)
   i.color <- 1+(r>0.7)+(r>0.8)
   ll <- par("usr") 
   #rect(ll[1], ll[3], ll[2], ll[4], col=cvec.bg[i.color], border=cvec.border[i.color], lwd=2)
   rect(ll[1], ll[3], ll[2], ll[4], border=cvec.border[i.color], lwd=3)
   points(x, y, ... ) 
   ok <- is.finite(x) & is.finite(y)
   if( any(ok) ) { abline(lm(y[ok] ~ x[ok]), col="red", lty=2, ...) }
}

addPredConf <- function(fit, data="mtcars", x="wt", col=c("blue","red")) {
    pred.conf <- predict(fit, interval="confidence", newdata=data)
    ix <- which(colnames(data) == x)
    i.order <- order(data[[ix]])
    df <- data.frame(x=data[[ix]], am=rep(0,nrow(data)), pred.conf)[i.order, ]
    
    lines(cbind(df$x, df$fit)[df$am==0,], col=col[1], lty=1)
    lines(cbind(df$x, df$lwr)[df$am==0,], col=col[1], lty=2)
    lines(cbind(df$x, df$upr)[df$am==0,], col=col[1], lty=2)
    #lines(cbind(df$x, df$fit)[df$am==0,], col=col[1], lty=1)
    #lines(cbind(df$x, df$lwr)[df$am==0,], col=col[1], lty=2)
    #lines(cbind(df$x, df$upr)[df$am==0,], col=col[1], lty=2)
    #lines(cbind(df$x, df$fit)[df$am==1,], col=col[2], lty=1)
    #lines(cbind(df$x, df$lwr)[df$am==1,], col=col[2], lty=2)
    #lines(cbind(df$x, df$upr)[df$am==1,], col=col[2], lty=2)
}

addPredConf.am <- function(fit, data="mtcars", x="wt", col=c("blue","red")) {
    pred.conf <- predict(fit, interval="confidence", newdata=data)
    ix <- which(colnames(data) == x)
    i.order <- order(data[[ix]])
    df <- data.frame(x=data[[ix]], am=data$am, pred.conf)[i.order, ]
    
    lines(cbind(df$x, df$fit)[df$am==0,], col=col[1], lty=1)
    lines(cbind(df$x, df$lwr)[df$am==0,], col=col[1], lty=2)
    lines(cbind(df$x, df$upr)[df$am==0,], col=col[1], lty=2)
    lines(cbind(df$x, df$fit)[df$am==1,], col=col[2], lty=1)
    lines(cbind(df$x, df$lwr)[df$am==1,], col=col[2], lty=2)
    lines(cbind(df$x, df$upr)[df$am==1,], col=col[2], lty=2)
}

addPredConf.cyl <- function(fit, data="mtcars", x="wt", col=c("blue","green","red")) {
    pred.conf <- predict(fit, interval="confidence", newdata=data)
    ix <- which(colnames(data) == x)
    i.order <- order(data[[ix]])
    df <- data.frame(x=data[[ix]], grp=data$cyl, pred.conf)[i.order, ]
    
    lines(cbind(df$x, df$fit)[df$grp==4,], col=col[1], lty=1)
    lines(cbind(df$x, df$lwr)[df$grp==4,], col=col[1], lty=2)
    lines(cbind(df$x, df$upr)[df$grp==4,], col=col[1], lty=2)
    lines(cbind(df$x, df$fit)[df$grp==6,], col=col[2], lty=1)
    lines(cbind(df$x, df$lwr)[df$grp==6,], col=col[2], lty=2)
    lines(cbind(df$x, df$upr)[df$grp==6,], col=col[2], lty=2)
    lines(cbind(df$x, df$fit)[df$grp==8,], col=col[3], lty=1)
    lines(cbind(df$x, df$lwr)[df$grp==8,], col=col[3], lty=2)
    lines(cbind(df$x, df$upr)[df$grp==8,], col=col[3], lty=2)
}
