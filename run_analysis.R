###############################Getting and Cleaning Data Course Project#####################################################

# The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is 
# to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions 
# related to the project. You will be required to submit: 
# 1) a tidy data set as described below, 
# 2) a link to a Github repository with your script for performing the analysis, and 
# 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the 
# data called CodeBook.md. 

# You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how 
# they are connected.

# One of the most exciting areas in all of data science right now is wearable computing - see for example this article . 
# Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. 
# The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S 
# smartphone. A full description is available at the site where the data was obtained:

#        http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

# Here are the data for the project:

#        https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  

# You should create one R script called run_analysis.R that does the following. 

###########################################################################################################################

# Install and load packages

install.packages("dyplr")

library(dplyr)

#Set work directory were the files are located

setwd("~/Eli/Peer-graded-Assignment-Getting-and-Cleaning-Data-Course-Project")

################################################################
# Merges the training and the test sets to create one data set.#
################################################################

# Reading test tables

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = features$functions)

y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "code")

# Reading train tables

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = features$functions)

y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "code")

# Reading features

features <- read.table("./UCI HAR Dataset/features.txt", col.names = c("n","functions"))

# Merge the data in one data set

x <- rbind(x_train, x_test)

y <- rbind(y_train, y_test)

subject <- rbind(subject_train, subject_test)

all_in_one <- cbind(subject, y, x)

##########################################################################################
# Extracts only the measurements on the mean and standard deviation for each measurement.# 
##########################################################################################

all_mean_and_std <- all_in_one %>% 
  select(subject, code, contains("mean"), contains("std"))

##########################################################################
# Uses descriptive activity names to name the activities in the data set #
##########################################################################

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

activity_names <- merge(activity_labels, all_mean_and_std, 
                        by='code',
                        all.x=TRUE)

######################################################################
# Appropriately labels the data set with descriptive variable names. #
######################################################################

new_names <- names(activity_names)
new_names <- gsub("^t", "Time", new_names)
new_names <- gsub("^f", "Frequency", new_names)
new_names <- gsub("BodyBody", "Body", new_names)
new_names <- gsub("tBody", "TimeBody", new_names)
new_names <- gsub("Acc", "Accelerometer", new_names)
new_names <- gsub("Gyro", "Gyroscope", new_names)
new_names <- gsub("Mag", "Magnitude", new_names)
new_names <- gsub("-mean()", "Mean", new_names, ignore.case = TRUE)
new_names <- gsub("-std()", "Standard_Deviation", new_names, ignore.case = TRUE)
new_names <- gsub("-", "_", new_names)
names(activity_names) <- new_names

#####################################################################################
# From the data set in step 4, creates a second, independent tidy data set with the #
# average of each variable for each activity and each subject.                      #
#####################################################################################

tidy_data <- activity_names %>% 
  group_by(subject, activity) %>% 
  summarise_all(list(mean))

