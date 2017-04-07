fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile = "data.zip",method="curl")
unzip("data.zip")

setwd("UCI HAR Dataset" )  

list.files()
list.files("./train")
list.files("./test")

SubjectTrain<-read.table("./train/subject_train.txt")
XTrain<-read.table("./train/x_train.txt")
YTrain<-read.table("./train/y_train.txt")

dim(SubjectTrain)
dim(XTrain)
dim(YTrain)

table(SubjectTrain)
table(YTrain)

Train<-cbind(SubjectTrain,YTrain,XTrain)

SubjectTest<-read.table("./test/subject_test.txt")
XTest<-read.table("./test/X_test.txt")
YTest<-read.table("./test/Y_test.txt")

Test<-cbind(SubjectTest,YTest,XTest)

AllData<-rbind(Train,Test)

names(AllData)[1:2]<-c("subject","activity")


features<-read.table("features.txt")
FeatureNames<-features[,2]
FeatureNames<-as.character(FeatureNames)

names(AllData)[3:563]<-FeatureNames

ValidNames <- make.names(names=names(AllData), unique=TRUE, allow_ = TRUE)
names(AllData)<-ValidNames

VariablesToKeep<-grep("[Mm]ean|[Ss]td",names(AllData))
library(dplyr)
ExtractedData<-select(AllData,1,2,VariablesToKeep)

ExtractedData<-select(ExtractedData,-contains("angle"))

ActivityLabels<-read.table("activity_labels.txt")
ActivityLabels[,2]<-tolower(ActivityLabels[,2])

activities<-character(length=length(ExtractedData$activity))
labels<-integer(length=length(ExtractedData$activity))

for (i in 1:length(activities))
{
    labels[i]<-ExtractedData$activity[i]
    activities[i]=ActivityLabels[labels[i],2]
}

ExtractedData<-cbind(activities,ExtractedData)
ExtractedData<-select(ExtractedData,-activity)

ColNames<-names(ExtractedData)
ColNames<-gsub("\\.","_",ColNames)
ColNames<-sub("__","",ColNames)
names(ExtractedData)<-ColNames

Results<-ExtractedData %>% group_by(activities,subject) %>% summarize_each(funs(mean))

write.table(Results,file = "Final_Tidy_Results.txt",row.names = FALSE)
