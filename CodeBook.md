Read these files in from UCI HAR Dataset directory:

From the test directory:
X_test.tx (measurement data)
y_test.txt (activity data)
subject_test.txt (subject data)

From the train directory
X_train.txt (measurement data)
y_train.txt (activity data)
subject_train.txt (subject data)

Transformation

Library

        library(data.table)
        library(dplyr)
        library(plyr)
        # set working directory
        setwd("~/UCI HAR Dataset")
        
Step 1.	Merges the training and the test sets to create one data set.

        test <- read.table("./test/X_test.txt")
        test_y <- read.csv("./test/y_test.txt", header=F, sep=" ")
        test_subject <- read.csv("./test/subject_test.txt", header=F, sep=" ")
        
        # read train data
        train <- read.table("./train/X_train.txt")
        train_y <- read.csv("./train/y_train.txt", header=F, sep=" ")
        train_subject <- read.csv("./train/subject_train.txt", header=F, sep=" ")
        
        # append test and train datasets
        data <- rbind(test, train)
        y <- rbind(test_y, train_y)
        subject <- rbind(test_subject, train_subject)
        
        # read lable files
        activity_labels <- read.table("./activity_labels.txt")
        features <- read.table("./features.txt", stringsAsFactor = FALSE)
        
        # lable subject and activity data 
        colnames(activity) <- "activity"
        colnames(subject) <- "subject"

Step 2.	Extracts only the measurements on the mean and standard deviation for each measurement. 

        # select mean and standard deviation columns
        features <- filter(features, grepl("mean\\(", V2) | grepl("std\\(", V2))
        


Step 3.	Uses descriptive activity names to name the activities in the data set

        # make feature descriptions more user friendly
        features$V2 <- tolower (features$V2)
        features$V2 <- gsub("\\(|\\)|-|,| ", "", features$V2)
        features$V2 <- gsub("gyro", "gyroscope", features$V2)
        features$V2 <- gsub("acc", "acceleration ", features$V2
        features$V2 <- gsub("std", "standarddeviation", features$V2) 
        features$V2 <- gsub("tbody", "timebody", features$V2)
        features$V2 <- gsub("tgravity", "timegravity", features$V2) 
        features$V2 <- gsub("acc", "acceleration", features$V2) 
        features$V2 <- gsub("fbody", "frequencybody", features$V2) 
        features$V2 <- gsub("mag", "magnitude", features$V2) 
        
        # get the mean and std columns 
        data <- select(data, features$V1)

Step 4.	Appropriately labels the data set with descriptive variable names. 

        # assign colnames to data
        colnames(data) <- features$V2
        colnames(subject) <- c("subject")
        colnames(activity) <- c("V1", "activity")
        activity <- select (activity, activity)
        
        # append subject to data
        data <- cbind(data, subject, activity)

Step 5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

        # summarise data by subject and activity, and calculate mean for each goup
        tidy_data <- data %>% group_by (subject, activity) %>% summarise_each (funs(mean))
        
        # save the result to a txt file
        write.table(tidy_data, file = "./tidy_data.txt", row.name=FALSE)
