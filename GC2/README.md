# Getting and Cleaning Data Project

## run_analysis.R

The task of preparing a tidy data set of containing for each activity and each subject the average value of variables corresponding to 'mean' and 'sd' is performed with one script 'run_analysis.R' that 

The analysis does the following:

1. Loads the 'features' names and cleans and reformats them.
2. Load, subset the 'training' and 'test' sets separately.   The subsetting of the relevant variables is performed on reading.
3. Merge the 'training' and 'test' sets.
4. Assign descriptive names to the 'activity' variable in the merged data frame.
5. Create (with two methods) tidy data set containing the average of each variable for each activity and each subject. 

## Inputs

The scripts expects to find the following data files 

* in its working directory:
	* features.txt
	* activity_labels.txt

* in a subdirectory 'test' 
	* test_activity_labels.txt
	* test_data.txt.gz
	* test_subjects.txt

* in a subdirectory 'train' 
	* train_activity_labels.txt
	* train_data.txt.gz
	* train_subjects.txt

Please note that in this basic version the script assumes that the large data files are gzipped and it does not perform any check, but it would be pretty straightforward to include it.

## Tidy Dataset 

The script applies two methods and produces two files, which are identical, named 'df_tidy_v1.csv' and 'df_tidy_v2.csv'.

They both meet the principles of 'tidy data' as outlined in the course and illustrated by Wickham (2007, unpublished?):
each row contains only one value, for a combination subject, activity, feature.
For instance, the head of the file looks like:


	"","subject","activity","variable","value"
	"1","subj1","walk","Acc.X.mean",0.277330758736842
	"2","subj1","walk_upstairs","Acc.X.mean",0.255461689622641
	"3","subj1","walk_downstairs","Acc.X.mean",0.289188320408163
	"4","subj1","sit","Acc.X.mean",0.261237565425532
	"5","subj1","stand","Acc.X.mean",0.278917629056604
	"6","subj1","rest","Acc.X.mean",0.22159824394
