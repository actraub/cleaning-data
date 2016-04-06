

#aaron traub 2016
# getting and cleaning data final assignment
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


# You should create one R script called run_analysis.R that does the following.
# 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.