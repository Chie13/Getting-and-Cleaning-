#Check if the file exist in the working directory, and if not download and unzip the file

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
download.file(fileUrl,destfile="./data/Dataset.zip")

#reading training tables

x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
s_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

#reading test tables

x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
s_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

#reading feature tables

features <- read.table('./data/UCI HAR Dataset/features.txt')

#reading Activity labels tables

act_labels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

#Assigning column names

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(s_train) <- "subjectId"
colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(s_test) <- "subjectId"
colnames(act_labels) <- c('activityId','activityType')

#Merging all data, test and train data sets

merge_test <- cbind(y_test, s_test, x_test)
merge_train <- cbind(y_train, s_train, x_train)
AllIn <- rbind(merge_train, merge_test)

#Reading Column names

colNames <- colnames(AllIn)

#Creating Columns for ID, Mean and Standard Deviation

mean_and_std <- (grepl("activityId" , colNames) | 
                  grepl("subjectId" , colNames) | 
                  grepl("mean.." , colNames) | 
                  grepl("std.." , colNames) 
                  )

#Making subset from AllIn

setForMeanAndStd <- AllIn[ , mean_and_std == TRUE]

#Uses descriptive activity names to name the activities in the data set

setWithActivityNames <- merge(setForMeanAndStd, act_labels,
                               by='activityId',
                               all.x=TRUE)
TidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
TidySet <- TidySet[order(TidySet$subjectId, TidySet$activityId),]
write.table(secTidySet, "TidySet.txt", row.name=FALSE)

