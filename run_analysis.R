
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
    activities          <- rename (activities, activity = V2, activityid = V1)
    
    # merge the train and test datasets
    newset <- rbind(test, train)
    
    # add column names from features to the merged datasets
    features[,2] <- tolower(features[,2])
    
    colnames(newset) <- as.vector(features[,2])
    
    # subset colums for mean or std deviation
    newset <- subset(newset, select = grep("*mean*|*std*", names(newset)))
    
    # merged the activities and bind to the dataset
    newactivities <- rbind(testA, trainA)
    newactivities <- rename (newactivities, activityid = V1)
    
    newset <- cbind(newset, newactivities)
    
    # add activity names to the data set 
    newset <- merge(activities, newset)
    
    # remove the index column created during the merge
    # newset <- newset[-1]
    
    # bind subject test and train data together and then bind it to the dataset
    newsubs <- rbind(testS, trainS)
    newsubs <- rename (newsubs, subject = V1)
    newset <- cbind(newsubs, newset)
    
    ## Add tidy names to the subjects and activities column
    # colnames(newset)[1] <- "subject"
    # colnames(newset)[3] <- "activity"    
    # colnames(newset)[2] <- "activity_id"    
    
    
    # newset <- newset[,-2]
    
    names(newset) <- gsub("-", "", names(newset), perl=TRUE)
    names(newset) <- gsub("acc", "accelerometer", names(newset), perl=TRUE)
    names(newset) <- gsub("std", "standarddeviation", names(newset), perl=TRUE)
    names(newset) <- gsub("\\)", "", names(newset), perl=TRUE)
    names(newset) <- gsub("\\(", "", names(newset), perl=TRUE)
    names(newset) <- gsub("\\,", "", names(newset), perl=TRUE)
    
    # group the data by activities and subjects and summarize the resulting columns by the mean 
    newset <- tbl_df(newset)
    newset2 <- dplyr::group_by(newset, activity, subject )
    newset3 <- dplyr::summarise_each(newset2, funs(mean))
    
    #########################################################################################################
    # output
    #########################################################################################################
    
    # write the tidy data set to a file
    write.table (newset3, tidyoutput, na = "NA", col.names = TRUE)
  
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

