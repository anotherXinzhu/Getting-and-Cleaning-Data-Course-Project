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
With all these filepaths and file names in mind, we can start our data-processing.  :)


## Step 1. Merges the training and the test sets to create one data set.
