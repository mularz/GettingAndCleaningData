DESCRIPTION: run_analysis.R
This function performs analysis of the smart phone dataset available at 'www.smartlab.ws' as requested in Getting and Cleaning Data course, project assignment.  The assignment defined five separate steps to transform the data into a tidy data set that contains the average of each variable for each activity and each subject.  Note that the steps described here are those specified in the project assignment.  However, they are not in the order described in the assignment because it seemed easier to apply step #2 after the data was labeled.

Step#1:  Merge the training and the test sets to create one data set.
This step reads in three different data sets for both training and test and combines them into three merged data sets (combinedMeasures, combinedSubjects, and combinedActivities) 

Step#3: Uses descriptive activity names to name the activities in the data set 
This step uses the combinedActivities data set and the activity_labels.txt to replace the number coded activity in the data sets with a name for the activity (e.g., 1 is replaced with STANDING). [NOTE: I suspect that there is a more efficient way to execute this step using the apply functions but did not have time to explore. ]

Steps #4 : Appropriately label the data set with descriptive variable names
and
Step#2: Extract only the measurements on the mean and standard deviation for each measurement

The features.txt file is read in and transposed to form a row of variable names (FeatureNames.t).

The mean and standard deviation measurements are extracted from th combined measurement data as follows:
1) The set of values in FeatureNames.t vector is searched for all names that contain "-mean", using the glob2rx function and then a master set of indices is created using grep
2) The same process as in 1) is used to create a set of indices for the "-std"
3) The two index sets are sorted and combined into a master index which is then used to extract the relevant names from FeatureNames.t and retained in subsetted_Names
4) The mean and std deviation subset is created using a cbind to create a new dataset of subjects, activities, and measurements and retained in meanStdSubset
5) The column names are set using the colnames function

Step#5: Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

This step uses the powerful melt and cast functions to rearrange the data and aggregate.

First 'meltedData' is created based on the two ids - Subject and Activity
Then dcast is used to compute the mean of each combination of Subject & Activity
Finally, the file results (tidyData) is written out to a file using the write.csv function.  The write.table function did not work correctly because it inserted row numbers into the data and caused a lable offset problem. 

[NOTE: This data looks ugly in *.txt form but reformats correctly (as shown in an excerpt below) when read into Excel and converted based on comma-separated values]

	Subject	Activity	tBodyAcc-mean()-X	tBodyAcc-mean()-Y	tBodyAcc-mean()-Z	tBodyAcc-std()-X
1	1	LAYING	0.221598244	-0.040513953	-0.113203554	-0.928056469
2	1	SITTING	0.261237565	-0.001308288	-0.104544182	-0.977229008
3	1	STANDING	0.278917629	-0.01613759	-0.110601818	-0.995759902
4	1	WALKING	0.277330759	-0.017383819	-0.111148104	-0.283740259
5	1	WALKING_DOWNSTAIRS	0.28918832	-0.009918505	-0.107566191	0.030035338
6	1	WALKING_UPSTAIRS	0.25546169	-0.023953149	-0.097302002	-0.354708025
7	2	LAYING	0.281373404	-0.01815874	-0.10724561	-0.974059465
8	2	SITTING	0.277087352	-0.015687994	-0.109218272	-0.98682228
9	2	STANDING	0.277911472	-0.018420827	-0.105908536	-0.987271889
10	2	WALKING	0.276426586	-0.01859492	-0.105500358	-0.423642838
11	2	WALKING_DOWNSTAIRS	0.277615348	-0.022661416	-0.116812942	0.046366681
12	2	WALKING_UPSTAIRS	0.24716479	-0.021412113	-0.1525139	-0.304376406






