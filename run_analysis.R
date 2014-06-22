run_analysis <- function () {
    
    require(reshape2)
    ##assumes data is stored in subdirectory of source directory
    ## test for directory existence, and create if not present
   if(!file.exists("./data")) {dir.create("./data")}
    
  
#####################################################################
#   1. Merge the training and the test sets to create one data set.
## 
##combine the train and test measurement data
    Train_measures = read.table("./data/Train/x_Train.txt", sep="")    
    Test_measures  = read.table("./data/Test/x_Test.txt",   sep="")
##merge two data sets (Train first, Test second)
    combinedMeasures = rbind(Train_measures, Test_measures) 

##Combine the train and test subject data
    Train_subjects = read.table("./data/Train/subject_train.txt", sep="")
    Test_subjects =  read.table("./data/Test/subject_test.txt"  , sep="")
    combinedSubjects = rbind(Train_subjects, Test_subjects)

##Combine the train and test activities data
    Train_activities = read.table("./data/Train/y_train.txt", sep="")
    Test_activities  = read.table("./data/Test/y_test.txt" , sep="")
    combinedActivities = rbind(Train_activities, Test_activities)

#####################################################################
#   3.Uses descriptive activity names to name the activities in the data set 

## The y_...txt file contains the activity for each measurement
## Replace the coded activity number with its name based on the 
## mapping in activity_labels.txt
 
## would ideally like to use apply function here, but haven't 
## had a chance to study how to use the function ...
    activityLabels = read.table("./data/activity_labels.txt", sep="")
    namedActivities<-character()
    for (i in 1:nrow(combinedActivities)) {   
        for (j in 1:nrow(activityLabels)) {
            if(combinedActivities$V1[i] == activityLabels$V1[j]){
                namedActivities <- rbind(namedActivities, 
                                            as.character(
                                            activityLabels$V2[j]))
            }
        }
    }

#####################################################################
#   4.Appropriately label the data set with descriptive variable names. 

##get the names of each measure and transpose
    Features = read.table("./data/features.txt",sep="")
    FeatureNames.t <- as.vector(t(Features$V2))

#####################################################################
#   2.Extract only the measurements on the mean and standard deviation for each measurement.  

##find names that correspond to mean
    meanIndex <- grep(glob2rx("*-mean*"), FeatureNames.t)
##find names that correspond to std deviation
    stdIndex <-  grep(glob2rx("*-std*"), FeatureNames.t)
##create a master index set
    meanStdIndex <- sort(as.numeric(c(meanIndex,stdIndex))) 

##use master index to extract relevant names from FeatureNames.t
    subsetted_Names <- as.character()
    for (i in 1:length(meanStdIndex)) {
        subsetted_Names <- c(subsetted_Names, FeatureNames.t[i])
    }
#extract the relevant measures from the combinedMeasures data set
    subsetted_Measures <- subset(combinedMeasures, select=meanStdIndex)

##Create a mean and std deviation subset with labels
    meanStdSubset <- cbind(combinedSubjects,
                           namedActivities,
                           subsetted_Measures)
    colnames(meanStdSubset) <- c("Subject","Activity", subsetted_Names)

#####################################################################
#   5.Creates a second, independent tidy data set with the average of 
#       each variable for each activity and each subject.

meltedData <- melt(meanStdSubset,id.vars=c("Subject","Activity"))
tidyData   <- dcast(meltedData, Subject + Activity ~ variable, fun.aggregate = mean)

##write the tidyData to a file
write.csv(tidyData, "./data/tidydata.txt")
#####################################################################     

}