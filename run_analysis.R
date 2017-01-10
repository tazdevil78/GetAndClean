library(dplyr)
library(reshape2)

## 1. Merges the training and the test sets to create one data set.

#read UCI HAR Dataset/features.txt - col names for test data
feat <- read.delim("UCI HAR Dataset/features.txt", header=F, sep=" ", colClasses=c("integer","character"))
feat <- feat[,2]

#read test/X_test.txt - test data
baseData <- scan("UCI HAR Dataset/test/X_test.txt")
baseData <- matrix(baseData, ncol=561, byrow=T )
baseData <- data.frame(baseData)

#assing colnames from features
colnames(baseData)<-feat

#read test/subject_test.txt - subject id for each row
subj <- read.delim("UCI HAR Dataset/test/subject_test.txt", header=F, colClasses=c("integer") )
baseData$subjectid <- subj[,1]
rm(subj)

#read test/y_test.txt - activity code for each row
actvy <- read.delim("UCI HAR Dataset/test/y_test.txt", header=F, colClasses=c("integer") )
baseData$activitycd <- actvy[,1]
rm(actvy)


#read train/X_train.txt
trainData <- scan("UCI HAR Dataset/train/X_train.txt")
trainData <- matrix(trainData, ncol=561, byrow=T )
trainData<-data.frame(trainData)
colnames(trainData)<-feat
rm(feat)

#read train/subject_train.txt
subj <- read.delim("UCI HAR Dataset/train/subject_train.txt", header=F, colClasses=c("integer") )
trainData$subjectid <- subj[,1]
rm(subj)

#read train/y_train.txt
actvy <- read.delim("UCI HAR Dataset/train/y_train.txt", header=F, colClasses=c("integer") )
trainData$activitycd <- actvy[,1]
rm(actvy)

#rbind all above
rownames(trainData)<-seq(from=nrow(baseData)+1, length.out = nrow(trainData))
baseData <- rbind(baseData, trainData)
rm(trainData)


## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

# use grep to examine the column names and keep those with "-std()" or "-mean()".
# also keep the subject id and activity cd.
colsMask <- grepl("[Mm]ean|std", names(baseData))
colsMask[562:563] <- T

sub1 <- baseData[,colsMask]
rm(colsMask)

## 3. Uses descriptive activity names to name the activities in the data set

#read activity_labels.txt - decode for activity id
act_xref <- read.delim("UCI HAR Dataset/activity_labels.txt", header=F, sep=" " )
names(act_xref) <- c( "activitycd", "activitynm" )

#merge labels with activity id
sub1 <- merge(sub1, act_xref, by.x="activitycd", by.y="activitycd")
rm(act_xref)


## 4. Appropriately labels the data set with descriptive variable names.
names(sub1)<-gsub("\\-|\\(|\\)|,", "", names(sub1) )


# ## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# # reshape data into measure per row
melted <- melt(sub1, id.vars=c("subjectid", "activitycd", "activitynm") )

# group_by activity, subject
# summarize mean()
sub2 <- melted %>%
  group_by(subjectid, activitycd, activitynm, variable) %>%
  summarize(average=mean(value))

sub3 <- dcast( sub2, subjectid + activitycd + activitynm ~ variable)

write.table(sub3, "output.txt", row.name=F)