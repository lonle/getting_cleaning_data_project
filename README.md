
Course Project For Getting and Cleaning data

source of data is:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
This file contains data from an experiment for a person performing six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) while whearing a smartphone Samsung Galaxy S II) on the waist.
The data captured accelerometer and gyroscope data for 3-axial linear acceleration and 3-axial angular velocity.
The dataset includes the following files:
=========================================
- 'README.txt'
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

run_analysis.R contains the codes for:  
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Part 4.  Label the data set with descriptive variable names
This part was completed in after Part 1.  This was done to make is easier to use descriptive variable names to make is easier to find the mean and std.  The variables are rom the features dataset that was given.

Part 5.  Creating tidy data
In order to get the average for each variable for each activity and each subject.  The data was first cleaned and separated into different datasets then merge together to create one tidy dataset.
First the data was divided into the subjects, accelerometer and gyroscope.  And within those categories divivided into the frequency and times.  The datsets were grouped by Actitivity and summarize was used to getthe average.
This was done for both accelerometer and gyroscope and the the two datasets were combined.




