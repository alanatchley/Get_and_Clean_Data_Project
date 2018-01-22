## From R Studio, select packages data.table and dplyr

library("data.table", lib.loc="C:/Program Files/R/R-3.4.2/library")
library("dplyr", lib.loc="C:/Program Files/R/R-3.4.2/library")

## data.table to read in the "raw" data of the test and train folders as well as the metadata of the features and activity labels files.

##dplyr to pull variables into a tidy data form.

##Start with the metadata (Imported datasets from R Studio, abbreviated path)

featureLabels <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt", header = FALSE)

##then the test and train files' data (full path of working directory)

subject_test <- read.table("C:/Users/aatchle/Desktop/Coursera Data Science Learning/GET&CLEAN PROJECT/test/subject_test.txt", quote="\"", comment.char="")
X_test <- read.table("C:/Users/aatchle/Desktop/Coursera Data Science Learning/GET&CLEAN PROJECT/test/X_test.txt", quote="\"", comment.char="")
y_test <- read.table("C:/Users/aatchle/Desktop/Coursera Data Science Learning/GET&CLEAN PROJECT/test/y_test.txt", quote="\"", comment.char="")
subject_train <- read.table("C:/Users/aatchle/Desktop/Coursera Data Science Learning/GET&CLEAN PROJECT/train/subject_train.txt", quote="\"", comment.char="")
X_train <- read.table("C:/Users/aatchle/Desktop/Coursera Data Science Learning/GET&CLEAN PROJECT/train/X_train.txt", quote="\"", comment.char="")
y_train <- read.table("C:/Users/aatchle/Desktop/Coursera Data Science Learning/GET&CLEAN PROJECT/train/y_train.txt", quote="\"", comment.char="")

##combine the train and test data by subject, then where features = X and activity = y

subject <- rbind(subject_train, subject_test)
features <- rbind(X_train, X_test)
activity <- rbind(y_train, y_test)

##naming the columns of the combined data

colnames(subject) <- "Subject"
colnames(features) <- t(featureLabels[2])
colnames(activity) <- "Activity"

##putting the files together
alldata <- cbind(features,activity,subject)

##search for match of either mean or standard deviation
searchformatch <- grep(".*Mean.*|.*Std.*", names(alldata), ignore.case=TRUE)

##give descriptive names to the activities as these are numeric
Betternames <-  sapply(activity[1, 2], function(x) {gsub("[()]", "",x)})

##look at the names of the variables and replace with whole word
names(alldata)<-gsub("Acc", "Accelerometer", names(alldata))
names(alldata)<-gsub("Gyro", "Gyroscope", names(alldata))
names(alldata)<-gsub("BodyBody", "Body", names(alldata))
names(alldata)<-gsub("Mag", "Magnitude", names(alldata))

##create a tidy data set with a mean in the subject and activity
tidydata <- aggregate(. ~Subject + Activity, alldata, mean)
tidydata <- tidydata[order(tidydata$Subject,tidydata$Activity),]
write.table(tidydata, file = "Tidy.txt", row.names = FALSE)