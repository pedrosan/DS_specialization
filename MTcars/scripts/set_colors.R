
colors.am <- c("blue2","red4"); 
colors.fill.am <- c("skyblue2","orangered"); 
pch.am <- c(21, 21)
cvec.am <- ifelse(mtcars$am==0, colors.am[1], colors.am[2])
cvec.fill.am <- ifelse(mtcars$am==0, colors.fill.am[1], colors.fill.am[2])

# colors.cyl <- c("blue2","green4","red2"); 
# colors.fill.cyl <- c("skyblue2","green","red"); 
# colors.cyl <- c("violetred4","chocolate2","green4"); 
# colors.fill.cyl <- c("violetred1","orange","green"); 
colors.cyl <- c("violetred4","chocolate2","darkgreen"); 
colors.fill.cyl <- c("violetred1","gold","green2"); 
pch.cyl <- c(24, 24, 24)
cvec.cyl <- ifelse(mtcars$cyl==4, colors.cyl[1], ifelse(mtcars$cyl==6, colors.cyl[2], colors.cyl[3]))
cvec.fill.cyl <- ifelse(mtcars$cyl==4, colors.fill.cyl[1], ifelse(mtcars$cyl==6, colors.fill.cyl[2], colors.fill.cyl[3]))

# cfit1 <- "firebrick2"
# cfit2 <- rgb(1.0, 0.84, 0.0, 0.5)
