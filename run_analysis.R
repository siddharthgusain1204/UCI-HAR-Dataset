filename<-"CourseraAssignment.zip"
#Check on users system if file is already downloaded
#If not downloaded, download the zip file
if(!file.exists(filename)){
  fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileurl,filename)
}

#Check if folder exists
#If not, unzip the file
if(!file.exists("UCI HAR Dataset"){
  unzip("CourseraAssignment.zip")
}

#Assigning data to tables
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities<-read.table("UCI HAR Dataset/activity_labels.txt",col.names = c("code","activity"))
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt",col.names = "subject")
x_test<-read.table("UCI HAR Dataset/test/X_test.txt",col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#merging to create one dataset
X<-rbind(x_test,x_train)
Y<-rbind(y_test,y_train)
subject<-rbind(subject_test,subject_train)
merged_data<-cbind(subject,X,Y)

#extract only mean and SD
tidydata<-merged_data %>% select(subject,code,contains("mean"),contains("std"))

#naming activities in the dataset
tidydata$code<-activities[tidaydata$code,2]

#label the dataset
names(tidydata)[2] = "activity"
names(tidydata)<-gsub("Acc", "Accelerometer", names(tidydata))
names(tidydata)<-gsub("Gyro", "Gyroscope", names(tidydata))
names(tidydata)<-gsub("BodyBody", "Body", names(tidydata))
names(tidydata)<-gsub("Mag", "Magnitude", names(tidydata))
names(tidydata)<-gsub("^t", "Time", names(tidydata))
names(tidydata)<-gsub("^f", "Frequency", names(tidydata))
names(tidydata)<-gsub("tBody", "TimeBody", names(tidydata))
names(tidydata)<-gsub("-mean()", "Mean", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("-std()", "STD", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("-freq()", "Frequency", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("angle", "Angle", names(tidydata))
names(tidydata)<-gsub("gravity", "Gravity", names(tidydata))

#for average of each variable
finaldata <- tidydata %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(finaldata, "finaldata.txt", row.name=FALSE)
