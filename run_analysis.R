
# run_analysis.R
# aaron traub 2016
# getting and cleaning data final assignment

#########################################################################################################
# Assignment details
#########################################################################################################
# You should create one R script called run_analysis.R that does the following.
# 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.



library(dplyr) # data mgt

#########################################################################################################
# Mergeset - function to clean data from the UCI HAR Dataset
#########################################################################################################

mergeset <- function(setup = FALSE) {
    
    # run setup function
    if (setup == TRUE) setup()
    
    # new.df <- data.frame()
    # new.df <- tbl_df(new.df)

    # location of files in import
    trainset            <- "./UCI HAR Dataset/train/X_train.txt"
    trainlabel          <- "./UCI HAR Dataset/train/y_train.txt"
    trainsub            <- "./UCI HAR Dataset/train/subject_train.txt"
    
    testset             <- "./UCI HAR Dataset/test/X_test.txt"
    testlabel           <- "./UCI HAR Dataset/test/y_test.txt"
    testsub             <- "./UCI HAR Dataset/test/subject_test.txt"
    
    columheaders        <- "./UCI HAR Dataset/features.txt"
    acts                <- "./UCI HAR Dataset/activity_labels.txt"
    
    # output files
    tidyoutput          <- "./tidyoutput.txt"
    
    # load data into data.tables
    test                <- read.table(testset, header = FALSE)
    testA               <- read.table(testlabel, header = FALSE)
    testS               <- read.table(testsub, header = FALSE)
    
    train               <- read.table(trainset, header = FALSE)
    trainA              <- read.table(trainlabel, header = FALSE)
    trainS              <- read.table(trainsub, header = FALSE)
    
    features            <- read.table(columheaders, header = FALSE)
    activities          <- read.table(acts, header = FALSE)
    
    #add the column names to activities
    activities          <- dplyr::rename(activities, activity = V2, activityid = V1)
    
    # merge the train and test datasets
    new.df <- rbind(test, train)
    
    # add column names from features to the merged datasets
    features[,2] <- tolower(features[,2])
    colnames(new.df) <- as.vector(features[,2])
    
    # subset colums for mean or std deviation
    mean.std.df <- subset(new.df, select = grep("*mean*|*std*", names(new.df)))
    
    # merged the activities and bind to the dataset
    new.activities <- rbind(testA, trainA)
    new.activities <- dplyr::rename(new.activities, activityid = V1)
    
    mean.std.df <- cbind(mean.std.df, new.activities)
    
    
    # bind subject test and train data together and then bind it to the dataset
    subjects.df <- rbind(testS, trainS)
    subjects.df <- rename (subjects.df, subject = V1)
    mean.std.df <- cbind(subjects.df, mean.std.df)
    
    # add activity names to the data set 
    mean.std.df <- merge(activities, mean.std.df, by="activityid")
    
    # remove the index column created during the merge
    # new.df <- new.df[-1]
    
    names(mean.std.df) <- gsub("-", "", names(mean.std.df), perl=TRUE)
    names(mean.std.df) <- gsub("acc", "accelerometer", names(mean.std.df), perl=TRUE)
    names(mean.std.df) <- gsub("std", "standarddeviation", names(mean.std.df), perl=TRUE)
    names(mean.std.df) <- gsub("\\)", "", names(mean.std.df), perl=TRUE)
    names(mean.std.df) <- gsub("\\(", "", names(mean.std.df), perl=TRUE)
    # names(mean.std.df) <- gsub("\\(\\)", "", names(mean.std.df), perl=TRUE)
    names(mean.std.df) <- gsub("\\,", "", names(mean.std.df), perl=TRUE)
    
    # group the data by activities and subjects and summarize the resulting columns by the mean 
    mean.std.dt <- tbl_df(mean.std.df)
    grouped.df <- group_by(mean.std.dt, activity, subject)
    summary.df <- summarize_each(grouped.df, funs(mean))
    summary <- summarize(grouped.df, mean = mean(fbodybodygyrojerkmagmeanfreq))
   
    
    #########################################################################################################
    # output
    #########################################################################################################
    
    # write the tidy data set to a file
    write.table (summary.df, tidyoutput, na = "NA", col.names = TRUE, row.names = FALSE)
  
    }


#########################################################################################################
# Setup - download the UCI HAR Dataset
#########################################################################################################

# setup will download files and store them in the local directory.  This can be run manually or 
# through mergeset to mergeset(setup=TRUE)
setup <- function () {
    filedirectory <- "./" #change name if needed
    zip <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    datasetzip <- "./dataset.zip"
    datadir <- "UCI HAR Dataset"
   
    # check to see if data exists
    if (!file.exists(filedirectory) ) {
        dir.create(filedirectory)
    }
    # check to see if the zip has been download and download if it has not
    if (!file.exists(zip) ) {
        download.file(zip, datasetzip, method="curl")
        # unzip files to data directoru
        unzip(datasetzip)
    }
}

