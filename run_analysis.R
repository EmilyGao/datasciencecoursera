library(data.table)
library(dplyr)
library(plyr)

# set working directory
setwd("C:/Users/gaoem/Documents/R Files/DataScientistAssignments/Getting_Cleaning_Data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")

# read test data
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
merge

# lable subject and activity data 
colnames(activity) <- "activity"
colnames(subject) <- "subject"

# select mean and standard deviation columns
features <- filter(features, grepl("mean\\(", V2) | grepl("std\\(", V2))

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

# assign colnames to data
colnames(data) <- features$V2
colnames(subject) <- c("subject")
colnames(activity) <- c("V1", "activity")
activity <- select (activity, activity)

# append subject to data
data <- cbind(data, subject, activity)
tidy_data <- data %>% group_by (subject, activity) %>% summarise_each (funs(mean))


