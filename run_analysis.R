download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","testfile3.zip",mode = "wb")
unzip("testfile2.zip")

#Merges the Training and Test Data Set
train_det <- read.table("UCI HAR Dataset/train/X_train.txt")
test_det <- read.table("UCI HAR Dataset/test/X_test.txt")
consl_det <- rbind(train_det,test_det)



#Extracts only the measurements on the mean and standard deviation for each
#measurement. 
features_name_def <- read.table("UCI HAR Dataset/features.txt")[,2]
colnames(consl_det) <- features_name_def
meanstdmeasures <- grepl('mean|std',features_name_def)
consl_mean_std_det <- subset(consl_det,select=meanstdmeasures)


# labels the data set with descriptive variable names. 
colnames(consl_mean_std_det) <- gsub("std", "StdDev", colnames(consl_mean_std_det))
colnames(consl_mean_std_det) <- gsub("^t", "Time", colnames(consl_mean_std_det))
colnames(consl_mean_std_det) <- gsub("^f", "Frequency", colnames(consl_mean_std_det))
colnames(consl_mean_std_det) <- gsub("-", "_", colnames(consl_mean_std_det))



#Map activity names to activities in the data set
act_train <- read.table("UCI HAR Dataset/train/y_train.txt")
act_test <- read.table("UCI HAR Dataset/test/y_test.txt")
act_consl <- rbind(act_train,act_test)[,1]
labels  <- read.table("UCI HAR Dataset/activity_labels.txt")[,2]
act_consl <- labels[act_consl]
data_act <- cbind(ActivityName = act_consl,consl_det)



#independent tidy data set with the average of each variable for each activity and each subject.
subjects_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
subjects_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subjects_consl <- rbind(subjects_train,subjects_test)[,1]
data_act_subj  <- cbind(SubjectNo = subjects_consl,data_act)

colnames(data_act_subj) <- make.names(names=names(data_act_subj), unique=TRUE, allow_ = TRUE)


library('dplyr')
average_data_act_subj <- data_act_subj %>%
  group_by(SubjectNo,ActivityName) %>%
  summarize_each(funs(mean))

write.table(average_data_act_subj,row.name = FALSE,file = "tidy_data_set.txt")    


