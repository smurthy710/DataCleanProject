
## set working directory
setwd("C:/Users/smurthy/Downloads/DataCleanProject/UCI HAR Dataset/test")

## test data set read

testdata<-read.table("X_test.txt",sep="")
testsubject<-read.table("subject_test.txt")
colnames(testsubject)<-"Subject"

testfeature<-read.table("y_test.txt")
colnames(testfeature)<-"Activity"

setwd("C:/Users/smurthy/Downloads/DataCleanProject/UCI HAR Dataset")

testcolnames<-read.table("features.txt")
colnames(testdata)<-testcolnames$V2


Activitytype<-read.table("activity_labels.txt")

## Activity names instead of numbers
testfeature1<-within(testfeature,Activity<-factor(testfeature$Activity, labels = Activitytype$V2))



## subset with only relevent cols
testwdata<-testdata[,testcolnames[grepl("mean",testcolnames$V2) | grepl("std",testcolnames$V2),]$V1]

## change col names for easy working
colnames(testwdata)<-sprintf("a%d", 1:ncol(testwdata))

testalldata<-cbind(testsubject,testfeature1,testwdata)





##train set similar to test


setwd("C:/Users/smurthy/Downloads/DataCleanProject/UCI HAR Dataset/train")

traindata<-read.table("X_train.txt",sep="")
trainsubject<-read.table("subject_train.txt")
colnames(trainsubject)<-"Subject"

trainfeature<-read.table("y_train.txt")
colnames(trainfeature)<-"Activity"
colnames(traindata)<-testcolnames$V2

trainfeature1<-within(trainfeature,Activity<-factor(trainfeature$Activity, labels = Activitytype$V2))

trainwdata<-traindata[,testcolnames[grepl("mean",testcolnames$V2) | grepl("std",testcolnames$V2),]$V1]

## store col names for final change 
tempcolname<-colnames(trainwdata)

colnames(trainwdata)<-sprintf("a%d", 1:ncol(testwdata))

trainalldata<-cbind(trainsubject,trainfeature1,trainwdata)

alldata<-rbind(testalldata,trainalldata)


##summary

library("dplyr", lib.loc="~/R/win-library/3.1")

grby<-group_by(alldata,Subject,Activity)
finalres<-summarise_each(grby,funs(mean))
# change back the col name
colnames(finalres)<-c("Subject","Activity",tempcolname)

setwd("C:/Users/smurthy/Downloads/DataCleanProject")

write.table(finalres,"DCprojTidy.txt",row.name=FALSE)