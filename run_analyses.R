## 03 Data Cleaning
## Assignment Getting and Cleaning Data Course Project

setwd("E:/Coursera/03_DataCleaning/Week4")
library("dplyr")

##read Files
fileFeatText <- "./data/UCI HAR Dataset/features.txt"
featuresText <- tbl_df(read.table(fileFeatText,stringsAsFactors=FALSE ))

featuresText <- mutate(featuresText,label= paste0(sprintf("%03d",V1),V2))
featuresText

fileActivityLabel <- "./data/UCI HAR Dataset/activity_labels.txt"
activityLabels <- tbl_df(read.table(fileActivityLabel,stringsAsFactors=FALSE ))
activityLabels

xfileTrain <- "./data/UCI HAR Dataset/train/X_train.txt"
xTrain <- tbl_df(read.table(xfileTrain))
yfileTrain <- "./data/UCI HAR Dataset/train/y_train.txt"
yTrain <- tbl_df(read.table(yfileTrain))
subjectfileTrain <- "./data/UCI HAR Dataset/train/subject_train.txt"
subjectTrain <- tbl_df(read.table(subjectfileTrain))

xfileTest <- "./data/UCI HAR Dataset/test/X_test.txt"
xTest <- tbl_df(read.table(xfileTest))
yfileTest <- "./data/UCI HAR Dataset/test/y_test.txt"
yTest <- tbl_df(read.table(yfileTest))
subjectfileTest <- "./data/UCI HAR Dataset/test/subject_test.txt"
subjectTest <- tbl_df(read.table(subjectfileTest))

##Label the columns
dim(xTest)
colNames <- featuresText$label
colNames <- gsub("-","_",colNames)
colNames <- gsub("\\()","",colNames)
colNames <- gsub(",|\\(|\\)","_",colNames)
colNames
names(xTrain)<- colNames
names(xTest) <- colNames
names(subjectTrain) <- "subject"
names(subjectTest) <- "subject"
names(yTrain) <- "y"
names(yTest)  <- "y"

##Merge the training and the test sets to create one data set
xTrain1 <- mutate(xTrain,orig="Train")
xTrain1 <- cbind(subjectTrain, yTrain, xTrain1)
xTest1 <- mutate(xTest,orig="Test")
xTest1 <- cbind(subjectTest, yTest, xTest1)
df <- rbind(xTrain1,xTest1)

##Extract only the measurements on the mean and standard deviation for each measurement
df1 <- select(df,  matches("subject|Y|mean|std"))
df1
df2 <- left_join(df1,activityLabels,by=c("y"="V1"))
df2

##calculate the average of each variable for each activity and each subject
erg <- summarise_each(group_by(df2,subject,V2),funs(mean), matches("mean|std"))
erg
dim(erg)
