## Set needed packages and read variables data.
library(plyr)

test_data <- read.table("UCI HAR Dataset/test/X_test.txt")
train_data <- read.table("UCI HAR Dataset/train/X_train.txt")

## Add "activity" and "subject" columns. 
test_data[,"activity"] <- read.table("UCI HAR Dataset/test/y_test.txt")
test_data[,"subject"] <- read.table("UCI HAR Dataset/test/subject_test.txt")
train_data[,"activity"] <- read.table("UCI HAR Dataset/train/y_train.txt")
train_data[,"subject"] <- read.table("UCI HAR Dataset/train/subject_train.txt")

## Merge test & train data.
allData <- rbind(test_data,train_data)

## Read "features" file with the variables, and "activity_labels" file with the activities.
features <- read.table("UCI HAR Dataset/features.txt")
activity <- read.table("UCI HAR Dataset/activity_labels.txt")

## Subset mean and standard deviation for each measurement and
## appropriately label the data set with descriptive variable names.
listNames <- append(as.character(features[,2]), c("activity","subject"), after=561)
listNames <- gsub("-mean","Mean", listNames)
listNames <- gsub("-std","Std", listNames)
listNames <- gsub("\\()","", listNames)
colWanted <- grep(".*Mean.*|.*Std.*|.*activity.*|.*subject.*", listNames)
dataWanted <- allData[,colWanted]
colnames(dataWanted) <- listNames[colWanted]

## Use descriptive activity names to name the activities in the data set.
dataWanted$activity <- mapvalues(dataWanted$activity, as.vector(activity$V1), as.vector(activity$V2))

## Subset with the average of each variable for each activity and each subject.
tidyData <- aggregate(dataWanted[1:86], dataWanted[c("activity","subject")], mean)

## Reorder columns and write to a file.
tidyData <- tidyData[,c(2,1,3:88)]
write.table(tidyData, file = "tidyData.txt", quote = FALSE, row.names = FALSE)
