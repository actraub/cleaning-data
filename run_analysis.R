
# run_analysis.R
# aaron traub 2016
# getting and cleaning data final assignment
library(tidyr)
library(dplyr)
mergeset <- function(setup = FALSE) {
    # run setup function
    
    if (setup == TRUE) setup()
    
    # location of files
    trainset <- "./UCI HAR Dataset/train/X_train.txt"
    trainlabel <- "./UCI HAR Dataset/train/y_train.txt"
    
    testset <- "./UCI HAR Dataset/test/X_test.txt"
    testlabel <- "./UCI HAR Dataset/test/y_test.txt"
    
    columheaders <- "./UCI HAR Dataset/features.txt"
    acts <- "./UCI HAR Dataset/activity_labels.txt"
    # labelvector <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")
    
    
    
    # load data
    test <- read.table(testset, header = FALSE)
    testA <- read.table(testlabel, header = FALSE)
    
    train <- read.table(trainset, header = FALSE)
    trainA <- read.table(trainlabel, header = FALSE)
    
    features <- read.table(columheaders, header = FALSE)
    activities <- read.table(acts, header = FALSE)
    # merge the datasets
    newset <- rbind(test, train)
    # add column names
    colnames(newset) <- features[,2]
    newacts <- rbind(testA, trainA)
    newset <- cbind(newset, newacts)
    # rename(newset, activity1 = V1)
    mutate(activities, activities = activities$V1 )
    print(activities)
    # head(newset)
    # str(newset)
    # dim(newset)
    }

# You should create one R script called run_analysis.R that does the following.
# 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.



setup <- function () {
    filedirectory <- "./"
    zip <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    datasetzip <- "./dataset.zip"
    datadir <- "UCI HAR Dataset"
    #check to see if data exists
    if (!file.exists(filedirectory) ) {
        dir.create(filedirectory)
    }
    
    if (!file.exists(zip) ) {
        download.file(zip, datasetzip, method="curl")
    }
    
    #unzip files to data directoru
    unzip(datasetzip)
}

