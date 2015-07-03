#-------------------------------------------------------------------------------
# GF 2014.05.25
#-------------------------------------------------------------------------------
# 0. Preliminaries
#    * loading required library
#-------------------------------------------------------------------------------

library("reshape2")

#-------------------------------------------------------------------------------
# 1. Load, clean and reformat 'features' names.
#-------------------------------------------------------------------------------
# NOTE: for sake of saving time for now the files it reads has one small edit w.r.t. the original file:
#   angle(tBodyAccJerkMean),gravityMean) --> angle(tBodyAccJerkMean,gravityMean)
feat.names <- read.table(file="features.txt", header=FALSE, stringsAsFactors=FALSE)[,2]

feat.names <- gsub("gravity","Gravity", feat.names, perl=TRUE)
feat.names <- gsub("Gravity\\b","GravityMean", feat.names, perl=TRUE)
feat.names <- gsub("GravityAcc","Gravity", feat.names, perl=TRUE)
feat.names <- gsub("BodyBody","Body", feat.names, perl=TRUE)
feat.names <- gsub("angle\\((\\w+),(\\w+)\\)","angle-\\1-\\2", feat.names, perl=TRUE)
feat.names <- gsub("\\(\\)","", feat.names, perl=TRUE)
feat.names <- gsub("-([XYZ]),([1-4])","\\2-\\1", feat.names, perl=TRUE)
feat.names <- gsub("tion-([XYZ]),([XYZ])","tion-\\1\\2", feat.names, perl=TRUE)
feat.names <- gsub("^t","", feat.names, perl=TRUE)
     
# Creating a vector of strings to replace the coding of the 'bandsEnergy' names: e.g. '-11,24' to '-A3'
ebandstr <- paste(c(rep("A",8),rep("B",4),rep("C",2)),c(1:8,1:4,1:2),sep="")

# First appends the new string...
feat.names[grep(",",feat.names)] <- paste(feat.names[grep(",",feat.names)],ebandstr,sep="_")

# ... then removes the existing N-M string
feat.names <- gsub("-\\d+,\\d+_([ABC])","-\\1", feat.names, perl=TRUE)

# Swaps position between X|Y|Z descriptor and feature name:  e.g. changing 'foo-bar-X' to 'foo-X-bar'
feat.names <- gsub("-(\\w+)-([XYZ])$","-\\2-\\1", feat.names, perl=TRUE)

# For homogeneity with the X|Y|Z feature names, add a '-' preceding 'Mag'.
feat.names <- gsub("Mag-","-Mag-", feat.names, perl=TRUE)

# Prepares vectors of:
#  - indices of columns of features with names ending in 'mean' or 'std'.
#  - names of selected features.
feat.sel.cols <- grep("mean$|std$", feat.names)
feat.sel.names <- feat.names[grep("mean$|std$", feat.names)]

# More cleaning of features names:
#  - the word 'Body' is redundant, hence it can be removed without ambiguity.
#  - substituting dashes with dots for better R-oriented naming.
feat.sel.names <- gsub("^Body","", feat.sel.names, perl=TRUE)
feat.sel.names <- gsub("^fBody","f", feat.sel.names, perl=TRUE)
feat.sel.names <- gsub("-",".", feat.sel.names, perl=TRUE)

#-------------------------------------------------------------------------------
# 2. Loading and subsetting of the 'test' and 'training' datasets
#     * Reads 'test' data and auxiliary files.
#     * IMPORTANT : features/columns are filtered on input.
#-------------------------------------------------------------------------------

#----------------
# TEST DATASET 
Nrows <- 2947
test.tmp <- read.table(file="./test/test_data.txt.gz", header=FALSE, nrow=Nrows)[,feat.sel.cols]
test.lab <- read.table(file="./test/test_activity_labels.txt", header=FALSE, nrow=Nrows)
test.sub <- read.table(file="./test/test_subjects.txt", header=FALSE, nrow=Nrows)
    
# Creates a data frame with 'test' data, assigning a name to the two 'id' columns.
df.test <- cbind(test.sub,test.lab,test.tmp)
colnames(df.test) <- c("subject","activity",feat.sel.names)

# Cleaning temporary data frames
rm(list=ls(pattern="^test"))

#----------------
# TRAIN DATASET 
Nrows <- 7352
train.tmp <- read.table(file="./train/train_data.txt.gz", header=FALSE, nrow=Nrows)[,feat.sel.cols]
train.lab <- read.table(file="./train/train_activity_labels.txt", header=FALSE, nrow=Nrows)
train.sub <- read.table(file="./train/train_subjects.txt", header=FALSE, nrow=Nrows)

# Creates a data frame with 'train' data, assigning a name to the two 'id' columns.
df.train <- cbind(train.sub,train.lab,train.tmp)
colnames(df.train) <- c("subject","activity",feat.sel.names)

# Cleaning temporary data frames
rm(list=ls(pattern="^train"))

#-------------------------------------------------------------------------------
# 3. Merging of the 'test' and 'training' datasets
#-------------------------------------------------------------------------------
# Appends the 'test' data frame to the 'test' data frame 
#   and orders the new data frame by 'subject' and 'activity'.
df.all <- rbind(df.train,df.test)
df.all <- df.all[order(df.all$subject,df.all$activity),]
rm(list=c("df.test","df.train"))

df.all$subject <- factor(df.all$subject,labels="subj")

#-------------------------------------------------------------------------------
# 4. Assign descriptive names to the 'activity' variable.
#-------------------------------------------------------------------------------
activity.names <- c("walk","walk_upstairs","walk_downstairs","sit","stand","rest")

# Makes 'subject' and 'activity' variables to be factors, giving names to their levels.
df.all$activity <- factor(df.all$activity,labels=activity.names)

#-------------------------------------------------------------------------------
# 5. Create tidy data set, with two methods.
#-------------------------------------------------------------------------------

#-------------------
# METHOD 1
#  1) 'aggregate()' to create the summary table
#  2) 'melt()' to give the proper 'tidy data' structure to the data frame
#-------------------

# Aggregates the data frame by 'subject' and 'activity' applying the 'mean' function.
df.aggr.mean  <- aggregate( df.all[,c(-1,-2)], by=list(df.all$subject,df.all$activity), mean)

# Restoring 
#  - 'subject' and 'activity' column names 
#  - ordering by 'subject' and 'activity'
colnames(df.aggr.mean)[1:2] <- colnames(df.all)[1:2]
df.aggr.mean <- df.aggr.mean[order(df.aggr.mean$subject,df.aggr.mean$activity),]

# Renames rows because they kept their original names (numbers).
rownames(df.aggr.mean) <- 1:nrow(df.aggr.mean)

# Melting the 'means' data frame to give it a proper 'tidy data' structure.
df.tidy <- melt(df.aggr.mean, id=c("subject","activity"), na.rm=TRUE)

write.csv(df.tidy, file="df_tidy_v1.csv")

#-------------------
# METHOD 2:
#  1) 'melt()' df.all directly.
#  2) 'dcast()' to summarize (means)
#  3) 'melt()' again to obtain the proper 'tidy data' structure
#-------------------

df.all.molten <- melt(df.all, id=c("subject","activity"), na.rm=TRUE)
df.all.cast <- dcast(df.all.molten, subject + activity ~ variable, mean)
df.all.cast.molten <- melt(df.all.cast, id=c("subject","activity"), na.rm=TRUE)

write.csv(df.all.cast.molten,file="df_tidy_v2.csv")

###############################################################################
