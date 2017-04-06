# Getting and Cleaning Data: Course Project

## Before processing the data
### First we need to download the zip file into the working directory
```r
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile = "data.zip",method="curl")
unzip("data.zip")
```
### To make things easier, we can set data folder named "UCI HAR Dataset" as our working directory.
```r
setwd("UCI HAR Dataset" )  
```
### Let's view the files and file paths which we are going to use later.
```r
list.files()

[1] "activity_labels.txt" "features_info.txt"   "features.txt"        "README.txt"         
[5] "test"                "train"          
```

```r
list.files("./train")

[1] "Inertial Signals"  "subject_train.txt" "X_train.txt"       "y_train.txt"      
```

```r
list.files("./test")

[1] "Inertial Signals" "subject_test.txt" "X_test.txt"       "y_test.txt"      
```
_With all these filepaths and file names in mind, we can start our data-processing.  :)_


## Step 1. Merges the training and the test sets to create one data set.
### 1.1  We first check the data formats to see how these data can be fit together
```r
SubjectTrain<-read.table("./train/subject_train.txt")
XTrain<-read.table("./train/x_train.txt")
YTrain<-read.table("./train/y_train.txt")

dim(SubjectTrain)
[1] 7352    1

dim(XTrain)
[1] 7352  561

dim(YTrain)
[1] 7352    1
```
_The dim() function shows that all three files have 7352 rows.These files can be combined into one dataframe using "cbind" command._
```r
table(SubjectTrain)

SubjectTrain
  1   3   5   6   7   8  11  14  15  16  17  19  21  22  23  25  26  27  28  29  30 
347 341 302 325 308 281 316 323 328 366 368 360 408 321 372 409 392 376 382 344 383 
```
```r
table(YTrain)

YTrain
   1    2    3    4    5    6 
1226 1073  986 1286 1374 1407 
```
_Using the table() function, we can see the content of SubjectTrain and YTrain. From here we know that SubjectTrain contains 21 integers which are the 21 volunteer ID. YTrain contains integer 1 to 6 which are the activity labels. dim() shows that XTrain contains 561 columns which are the 561 feature vectors._
### 1.2 Combine SubjectTrain, YTrain and XTrain to form one data frame called "Train"
```r
Train<-cbind(SubjectTrain,YTrain,XTrain)
```
### 1.3 Do the same steps for the subject, X and Y.txt files in the test folder
```r
SubjectTest<-read.table("./test/subject_test.txt")
XTest<-read.table("./test/X_test.txt")
YTest<-read.table("./test/Y_test.txt")

dim(SubjectTest)
[1] 2947    1

dim(XTest)
[1] 2947  561

dim(YTest)
[1] 2947    1

Test<-cbind(SubjectTest,YTest,XTest)
```
### 1.4 Combine Train and Test into one data frame named AllData using rbind command
```r
AllData<-rbind(Train,Test)

str(AllData)
'data.frame':	10299 obs. of  563 variables:
 $ V1  : int  1 1 1 1 1 1 1 1 1 1 ...
 $ V1  : int  5 5 5 5 5 5 5 5 5 5 ...
 $ V1  : num  0.289 0.278 0.28 0.279 0.277 ...
 $ V2  : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
 $ V3  : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
 ```
 ### 1.5 Note that the first three columns of AllData are all V1, change their names to avoid confusion
 ```r
 names(AllData)[1:2]<-c("subject","activity")
 ```
 ## Step 2. Extracts only the measurements on the mean and standard deviation for each measurement.
 ### 2.1 Change column names of AllData to their actual feature names
 _Currently, the variable names in our AllData dataframe are just V1 to V561, and the actual names are stored in the features.txt file. So we first read the feature.txt file, after which we can change the variable names to the actual feature names._
 ```r
features<-read.table("features.txt")
FeatureNames<-features[,2]
FeatureNames<-as.character(FeatureNames)

names(AllData)[3:563]<-FeatureNames
```
_We need to make sure that there won't be duplicate names due to the "()-" in theoriginal column names, otherwise using select command from dplyr will generate error_
```r
ValidNames <- make.names(names=names(AllData), unique=TRUE, allow_ = TRUE)
names(AllData)<-ValidNames
 ```
### 2.2 Identify the location of variables which has mean/Mean/std/Std in their names
 ```r
 VariablesToKeep<-grep("[Mm]ean|[Ss]td",names(AllData))
```
### 2.3 Keep only the columns with mean and std values
```r
library(dplyr)
ExtractedData<-select(AllData,1,2,VariablesToKeep)
```
```r
tail(names(ExtractedData),10)
 [1] "fBodyBodyGyroJerkMag.mean.."          "fBodyBodyGyroJerkMag.std.."          
 [3] "fBodyBodyGyroJerkMag.meanFreq.."      "angle.tBodyAccMean.gravity."         
 [5] "angle.tBodyAccJerkMean..gravityMean." "angle.tBodyGyroMean.gravityMean."    
 [7] "angle.tBodyGyroJerkMean.gravityMean." "angle.X.gravityMean."                
 [9] "angle.Y.gravityMean."                 "angle.Z.gravityMean."        
 ```
_Double check the names of ExtractedData, there are still a few columns we don't need to keep which are the angle variables._
### 2.4 Remove angle variables
```r
ExtractedData<-select(ExtractedData,-contains("angle"))
```
_Now we have 81 variables overall, with the first two being subject and activity, and the following 79 variables being either mean or std values of features_
## Step 3. Uses descriptive activity names to name the activities in the data set



 
