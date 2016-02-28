## merging the training and the test sets to create one data set

xtrain <- read.table("./train/X_train.txt")
ytrain <- read.table("./train/y_train.txt")
subjecttrain <- read.table("./train/subject_train.txt")

xtest <- read.table("./test/X_test.txt")
ytest <- read.table("./test/y_test.txt")
subjecttest <- read.table("./test/subject_test.txt")

features <- read.table("features.txt")

mergedsubject<-rbind(subjecttrain, subjecttest)
mergedx<-rbind(xtrain, xtest)
mergedy<-rbind(ytrain, ytest)

names(mergedsubject)<-c("subject")
names(mergedy)<-c("activity")
names(mergedx)<-features$V2

alldata<-cbind(mergedx,mergedsubject,mergedy)

## extracting only the measurements on the mean and standard deviation for each measurement

targetfeatures <- grep("-(mean|std)\\(\\)", features[, 2])
selecteddata<-alldata[,targetfeatures]

## Using descriptive activity names to name the activities in the data set

activitylabels <- read.table("./activity_labels.txt")
alldata$activity <- factor(alldata$activity, levels=activitylabels[,1], labels=activitylabels[,2])

## labeling the data set with descriptive variable names.

names(alldata)<-gsub("^t", "time", names(alldata))
names(alldata)<-gsub("^f", "frequency", names(alldata))
names(alldata)<-gsub("Acc", "Accelerometer", names(alldata))
names(alldata)<-gsub("Gyro", "Gyroscope", names(alldata))
names(alldata)<-gsub("Mag", "Magnitude", names(alldata))
names(alldata)<-gsub("BodyBody", "Body", names(alldata))

## createing a second, independent tidy data set with the average of each variable for each activity and each subject.

library(plyr)
alldata2<-aggregate(.~subject+activity,alldata,mean)
alldata2<-alldata2[order(alldata2$subject, alldata2$activity),]
write.table(alldata2, file="tidydata.txt", row.name=FALSE)