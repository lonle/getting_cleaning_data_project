## -------------------- Getting and Cleaning Data - Programming Project --------------------------------------------------------------------

# set working directory
setwd("/home/loan/Desktop/Getting and Cleaning Data/UCI HAR Dataset")

##----------  Step 1 - Part 1: Merges the training and the test sets to create one data set -------------------------------------
# Open train and test data sets
x_train <- read.table("train/X_train.txt", header=FALSE)
x_test <- read.table("test/X_test.txt", header=FALSE)

# Merge training datasets and test datasets to create on data set
train_test_combine <- rbind(x_train, x_test)       # combine the x train and test datasets

##----------  Step 2 - Part 4: Label the data set with descriptive variable names -----------------------------------------------
## Part 4 was perform before Part 2 because it is more effiecient to label the variable with a descriptive name in order to perform a
## a search for the mean and standard deviation.

## Features dataset contains all the variable names for the train and test data set.  I find that the variables are descriptive
## enough and decided to use this file to label the data set

# Open features data set and use the names of the features data set to name the combined train and test dataset (train_test_data)
features <- read.table("features.txt")
colnames(train_test_combine) <- features$V2    # set the column names of the train_test_combine to the values in the features dataset

##----------  Step 3 - Part 2: Extracts only the measurements on the mean and standard deviation for each measurement ---------------
# Extracts the measurements on the mean and standard deviation for each measurement
mean <- train_test_combine[, grepl("mean", names(train_test_combine))]                  # uses grepl to search for matches with "mean" in the column name and stores the values in mean dataset
standard_deviation <- train_test_combine[, grepl("std", names(train_test_combine))]     # uses grepl to search for matches with "std" in the column name and stores the values in standard_deviation dataset
mean_std <- cbind(mean, standard_deviation)                                       # use column bind to combine the means and standard_deviation datasets

##----------  Step 4 - Part 3: Use descriptive activity names to name the activities in the data set ---------------------------
# Activites are:
#   1 WALKING
#   2 WALKING_UPSTAIRS
#   3 WALKING_DOWNSTAIRS
#   4 SITTING
#   5 STANDING
#   6 LAYING

y_train <- read.table("train/y_train.txt")  # read in train activity dataset
y_test <- read.table("test/y_test.txt")     # read in test activity dataset
activity_labels <- read.table("activity_labels.txt")  # read in the activity_labels dataset containing the activity names

activity <- rbind(y_train, y_test)                 # used row bind to combine the train and test datasets
activity$V1[activity$V1 == 1] <- 'WALKING'         # if the activity number is 1 then change it to WALKING
activity$V1[activity$V1 == 2] <- 'WALKING_UPSTAIRS'   # if the activity number is 2 then change it to WALKING_UPSTAIRS and so on for the rest
activity$V1[activity$V1 == 3] <- 'WALKING_DOWNSTAIRS'
activity$V1[activity$V1 == 4] <- 'SITTING'
activity$V1[activity$V1 == 5] <- 'STANDING'
activity$V1[activity$V1 == 6] <- 'LAYING'

colnames(activity) <- "Activity"               # give the column name a descriptive name "Activity"
mean_std <- cbind(activity, mean_std)          # use column bind to combine the actitiy dataset with the descriptive activities and the mean_std dataset containing only the mean and standard deviation data


##----------  Step 5 - Part 5: Create an independent tidy data set with the average of each variable for each activity and each subject ------
library(dplyr)
library(tidyr)

# select data only for accelerometer and then get the data for the frequency and time only
# Once the tidy data for time and frequency is acquired  then gather the category and total.  In order to get the average for each category, group_by was used.
# Summarize was used to get the mean for the average of each variable for each activity

accelerometer <- select(mean_std, Activity, contains("Acc"))          # select only the data that is from the accelerometer
acc_freq <- select(accelerometer, Activity, contains("fBody"))        # select the frequency data from the accelerometer
acc_freq <- gather(acc_freq, category, total, -Activity)              # gather the category and total, leave Actitvity as is
by_acc_freq <- group_by(acc_freq, Activity, category)                 # group the frequency dataset by Activity and category
by_acc_freq <- summarize(by_acc_freq, average_freq=mean(total) )                   # use summarize to get the average of the frequency for each activity

acc_time <- select(accelerometer, Activity, starts_with("t"))        # select only the acceleromether time 
acc_time <- gather(acc_time, category, total, -Activity)  
by_acc_time <- group_by(acc_time, Activity, category)
by_acc_time <- summarize(by_acc_time, average_time=mean(total) ) 

acc_tidy <- cbind(by_acc_freq, average_time = by_acc_time$average_time)  # add the average time column to the frequency table 

gyroscope <- select(mean_std, Activity, contains("Gyro"))
gyro_freq <- select(gyroscope, Activity, contains("fBody"))        # select the frequency data from the gyroscope
gyro_freq <- gather(gyro_freq, category, total, -Activity)              # gather the category and total, leave Actitvity as is
by_gyro_freq <- group_by(gyro_freq, Activity, category)                 # group the frequency dataset by Activity and category
by_gyro_freq <- summarize(by_gyro_freq, average_freq=mean(total) ) 

gyro_time <- select(gyroscope, Activity, starts_with("t"))        # select only the acceleromether time 
gyro_time <- gather(gyro_time, category, total, -Activity)  
by_gyro_time <- group_by(gyro_time, Activity, category)
by_gyro_time <- summarize(by_gyro_time, average_time=mean(total) ) 

gyro_tidy <- merge(by_gyro_time, by_gyro_freq, all=TRUE, by=c("Activity", "category"))  # the number of rows are different in the gyroscope for frequency and time, merge was used instead to combine the two datasets

tidy <- rbind(acc_tidy, gyro_tidy)    # combine all observations for the average for each variable for each activity

write.table(tidy, "tidy.txt", row.names=FALSE)   # write the result to a text file
