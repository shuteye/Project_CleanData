## Project : Cleaning ##

#PT I : setup
# set working directory #
setwd("~/Education/Coursera/Data.Analysis.JH/3.Clean Data/Project")

# Libraries

library(data.table)
library(plyr)
library(Hmisc)
library(jsonlite)
library(knitr)
library(stringr)
library(reshape2)

#PT II: acquision
#download file#
u<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
download.file(u, destfile="master_zp.zip",mode="wb")

#unpacking routine for zip file

uu<-unzip(zipfile="master_zp.zip")
file.rename(from="./UCI HAR Dataset/",to="./UCI.HAR.Dataset/")

#PT III: reading in files

feature<-read.table(file="./UCI.HAR.Dataset/features.txt",sep=" ",
                    colClasses=c("numeric","character"))

#read in training file

train_subject<-read.table(file="./UCI.HAR.Dataset/train/subject_train.txt")
train_x<-read.table(file="./UCI.HAR.Dataset/train/X_train.txt")
train_y<-read.table(file="./UCI.HAR.Dataset/train/Y_train.txt")

#read in test file

test_subject<-read.table(file="./UCI.HAR.Dataset/test/subject_test.txt")
test_x<-read.table(file="./UCI.HAR.Dataset/test/X_test.txt")
test_y<-read.table(file="./UCI.HAR.Dataset/test/Y_test.txt")

#arranging - 2 sets of obs containing 563 variables including activity code & subject

colnames(train_x)<-feature$V2
colnames(test_x)<-feature$V2

train_x<-cbind(train_x,train_y)
names(train_x)[names(train_x)=="V1"]<-"Activity_code"
train_x<-cbind(train_x,train_subject)
names(train_x)[names(train_x)=="V1"]<-"Subject"
train_x<-train_x[,c(563,562,1:561)] # this sets subject & activity as 1st columns

test_x<-cbind(test_x,test_y)
names(test_x)[names(test_x)=="V1"]<-"Activity_code"
test_x<-cbind(test_x,test_subject)
names(test_x)[names(test_x)=="V1"]<-"Subject"
test_x<-test_x[,c(563,562,1:561)] # this sets subject & activity as 1st columns

# write to file for visual checks
write.csv(train_x, file="train_x.csv")
write.csv(test_x, file="test_x.csv")

#master merge - training data followed by test data

# merge with rbind train followed by test
master<-NULL
master<-rbind(train_x,test_x)

# PT IV : activities as descriptors #

# sort master data by subject and activity code #
master<-arrange(master,Subject,Activity_code)

# create and add vector of descriptives for activities
clone<-master$Activity_code
activity<-c("WALK","WALK_UP","WALK_DOWN","SIT","STAND","LAY")
for (i in 1:6) {
  clone<-gsub(pattern=as.character(i),replacement=activity[i],x=clone)
  }

master<-cbind(master,clone)
master<-master[,c(1:2,564,3:563)] #rearrange so identifiers are 1st columns
master<-arrange(master,Subject,Activity_code)
names(master)[names(master)=="clone"]<-"Activity"

write.csv(master, file="master.csv",row.names=F)

# PT V : Extraction of mean & std.dev data #

# Assumption: mean frequency and angles of means are excluded #

#identify mean matches by string "mean" #
mm<-(str_match(names(master),pattern="mean\\("))
mmm<-which(!is.na(mm))

#MM<-(str_match(names(master),pattern="Mean")) #removed for angles
#MMM<-which(MM %in% "Mean")

#identify std.dev matches by string "std"#
ss<-str_match(names(master),pattern="std")
sss<-which(ss %in% "std")

dd<-append(mmm,sss) # master index vector containing entries with "mean" or "std"
#dd<-append(dd,MMM) # adds in angle(means) #removed 
dd<-append(dd,c(1,2,3)) # this keeps identicator variables
dd<-sort(dd) #sorted in ascending order

reduced<-master[,dd] #reduced data set with indicators, mean, std and angle(mean) values

# PT VI : Building tidy data with averages of measures #

# the reduced dataset is recast as a 'molten' format for quick sub-categorical 
# computation of means

rmelt<-melt(reduced,id=c("Subject","Activity"), measure.vars=c(4:length(reduced))) # puts into molten form ids followed by variables
rmeans<-dcast(rmelt,Subject+Activity~variable,mean)

#ggg<-apply(rmeans[,3:68],MARGIN=2,FUN=signif,digits=6)

write.csv(rmeans, file="tidydata.csv",row.names=F)
write.table(rmeans, file="tidydata.txt", sep="\t", row.names=FALSE,quote=F)

#write.table(ggg, file="gggdata.txt", sep="\t", row.names=FALSE,quote=F)