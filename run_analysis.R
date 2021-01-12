#Getting and Cleaning Data Course Project - Johns Hopkins Coursera
#Jack Chesson
#run_analysis operates by merging the training and test data into one dataset,
#Extracts the mean and standard deviation as measurements,
#Uses appropriate and descriptive labels for activity labels,
#Appropriately names variables,
#And writes a second data set with all required labels, variables, and measurements.


library(data.table)

library(reshape2)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(url, file.path(getwd(), "dataFiles.zip"))

unzip(zipfile = "dataFiles.zip")


#Load labels for the activities and features, and include the mean and standard deviation as measurements 


activityLabels <- fread(file.path(getwd(),"UCI HAR Dataset/activity_labels.txt"), col.names = c("classLabels", "activityName"))

features <- fread(file.path(getwd(),"UCI HAR Dataset/features.txt"), col.names = c("index", "feature"))

featuresWanted <- grep("(mean|std)\\(\\)", features[, feature])

measurements <- features[featuresWanted, feature]

measurements <- gsub('[()]', '', measurements)


#Import train data and clean the dataset using intuitive column names


train <- fread(file.path(getwd(),"UCI HAR Dataset/train/X_train.txt"))[, featuresWanted, with = FALSE]

data.table::setnames(train,colnames(train),measurements)

trainActivities <- fread(file.path(getwd(),"UCI HAR Dataset/train/Y_train.txt"), col.names = c("Activity"))

trainSubjects <- fread(file.path(getwd(),"UCI HAR Dataset/train/subject_train.txt"), col.names = c("Subject"))

train <- cbind(trainSubjects, trainActivities, train)


#Import test data and clean the dataset, using the same column names as the train dataset


test <- fread(file.path(getwd(),"UCI HAR Dataset/test/X_test.txt"))[, featuresWanted, with = FALSE]

data.table::setnames(test,colnames(test),measurements)

testActivities <- fread(file.path(getwd(),"UCI HAR Dataset/test/Y_test.txt"), col.names = c("Activity"))

testSubjects <- fread(file.path(getwd(),"UCI HAR Dataset/test/subject_test.txt"), col.names = c("Subject"))

test <- cbind(testSubjects, testActivities, test)


#merge data into one dataset


mergedData <- rbind(train, test)


#Convert Labels to Activity Names and include mean


mergedData[["Activity"]] <- factor(mergedData[, Activity]
                                 , levels = activityLabels[["classLabels"]]
                                 , labels = activityLabels[["activityName"]])

mergedData[["Subject"]] <- as.factor(mergedData[, Subject])

mergedData <- reshape2::melt(data = mergedData, id = c("Subject", "Activity"))

mergedData <- reshape2::dcast(data = mergedData, Subject + Activity ~ variable, fun.aggregate = mean)


#Write dataset into a text file in the working directory


data.table::fwrite(x = mergedData, file = "tidyData.txt", quote = FALSE)