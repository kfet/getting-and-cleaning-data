# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.

# Download the data
dataUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(dataUrl, destfile="Dataset.zip", method="curl")
unzip("Dataset.zip")
setwd("UCI HAR Dataset")

features = read.table("features.txt")
colnames(features) = c("feature_id", "feature_name")
features_idx = grep("mean|std",features$feature_name)

activities = read.table("activity_labels.txt")
colnames(activities) = c("activity_id", "activity_name")

# Read-in the training data
subject_train = read.table("train/subject_train.txt")
colnames(subject_train) = c("subject_id")

x_train = read.table("train/X_train.txt")
colnames(x_train) = features$feature_name
x_train = x_train[,features_idx]

y_train = read.table("train/y_train.txt")
colnames(y_train) = c("activity_id")

data_train = cbind(subject_train, x_train, y_train)

# Read-in the test data
subject_test = read.table("test/subject_test.txt")
colnames(subject_test) = c("subject_id")

x_test = read.table("test/X_test.txt")
colnames(x_test) = features$feature_name
x_test = x_test[,features_idx]

y_test = read.table("test/y_test.txt")
colnames(y_test) = c("activity_id")

data_test = cbind(subject_test, x_test, y_test)

# Merge the two data sets
data_all = rbind(data_train, data_test)

# Add column with decriptive activity names
data_all = merge(data_all, activities, by="activity_id")

# Correct the column names
names = colnames(data_all)
names = gsub('\\(\\)', '', names)
names = gsub('-mean', 'Mean', names)
names = gsub('-std', 'Std', names)
names = gsub('BodyBody', 'Body', names)
names = gsub('tBody', 'time-Body', names)
names = gsub('tGravity', 'time-Gravity', names)
names = gsub('fBody', 'freq-Body', names)
colnames(data_all) = names


# Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
data_all_ave <- aggregate(data_all[, !(names(data_all) %in% c("activity_id", "subject_id"))], by=list(data_all$activity_id, data_all$subject_id), FUN="mean")


# Write the two datasets to files
setwd('..')

write.table(data_all, file = 'data_all.txt', sep='\t')
write.table(data_all_ave, file = 'data_all_ave.txt', sep='\t')
