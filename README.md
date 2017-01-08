# GetAndClean
Getting and Cleaning Data Course Project  

run_analysis.R:  
read UCI HAR Dataset/features.txt - col names for test data  
read test/X_test.txt - test data  
assign colnames from features  
read test/subject_test.txt - subject id for each row  
add subject id to the data  
read test/y_test.txt - activity code for each row  
add activity code to the data  
read train/X_train.txt - training set  
read train/subject_train.txt  
add subject id to the training set  
read train/y_train.txt  
add activity code to the training set  
rbind the training and test sets  
use grep to examine the column names and find those with "-std()" or "-mean()"  
also keep the subject id and activity cd.  
subset the data set, keeping all rows and only selected columns  
read activity_labels.txt - has activity code and activity name  
merge with the labels with the data set  
update columns with more appropriate labels  
reshape data into measure per row  
group_by activity, subject  
summarize mean()  
write to file: output.txt  
  
output.txt:  
space delimited file with the result of the above steps  
  
CodeBook.md:  
describes the contents of output.txt  
