# download data file if it doesn't exist already; save download date; unzip file

outfile <- "./private/DataScience/GettingAndCleaningData/Dataset.zip"
if (!file.exists(outfile)) {
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              outfile,method="curl")
  dateDownloaded <- date()
}
unzip(outfile,exdir="./private/DataScience/GettingAndCleaningData")

# Appropriately label the data set with descriptive variable names
# read in feature names to associate with the training & test data
featnames <- read.table("./private/DataScience/GettingAndCleaningData/UCI HAR Dataset/features.txt")

# modify the feature names a bit to make them more readable:
# remove () and substitute period for dash.  It's not clear to me
# that I can really do anything else that will make these more
# descriptive than they are already.  I prefer to leave uppercase
# letters where they appear here; and I find periods useful in
# delimiting parts of a variable name.
featnames.noparen <- sub("\\()","",featnames[,2])
featnames.noparendash <- gsub("-",".",featnames.noparen)

trainset <- 
  read.table("./private/DataScience/GettingAndCleaningData/UCI HAR Dataset/train/X_train.txt",
             col.names=featnames.noparendash)
testset <-
  read.table("./private/DataScience/GettingAndCleaningData/UCI HAR Dataset/test/X_test.txt",
             col.names=featnames.noparendash)

# Merge the training and the test sets to create one data set.

alldata <- rbind(trainset,testset)

# Extract only the measurements on the mean and standard deviation for each measurement.

# find feature names that include "mean" or "std"
meansd <- grep("mean|std",featnames.noparendash,ignore.case=T,value=F)
# get columns with those feature names
alldatamnsd <- alldata[,meansd]

# Use descriptive activity names to name the activities in the data set

# read in the (numerically coded) training & testing labels, and the
# mapping from numbers to descriptive labels

trainlabels <-
  read.table("./private/DataScience/GettingAndCleaningData/UCI HAR Dataset/train/y_train.txt")
testlabels <-
  read.table("./private/DataScience/GettingAndCleaningData/UCI HAR Dataset/test/y_test.txt")
alllabels <- rbind(trainlabels,testlabels)

activitymapping <-
  read.table("./private/DataScience/GettingAndCleaningData/UCI HAR Dataset/activity_labels.txt")

# alldesclabels contains the descriptive (name) labels for the activity
# in each of the rows of the data set - one label per row
activity <- activitymapping[alllabels[,1],2]

labeldata <- cbind(alldatamnsd,activity)

# associate the subject numbers with each row in the data

trainsubjs <- 
  read.table("./private/DataScience/GettingAndCleaningData/UCI HAR Dataset/train/subject_train.txt")
testsubjs <- 
  read.table("./private/DataScience/GettingAndCleaningData/UCI HAR Dataset/test/subject_test.txt")
allsubjs <- rbind(trainsubjs,testsubjs)
colnames(allsubjs) <- "subject"

labeldata <- cbind(allsubjs,labeldata)

# create a second, independent tidy data set with the average of each 
# variable for each activity and each subject.

finaldata <- aggregate(labeldata[,2:87],
                       list(Subject=labeldata$subject,Activity=labeldata$activity),mean)
