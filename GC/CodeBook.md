# Code Book

## ID Fields

There are two main 'ID' variables:

* subject - (1:30) : the participant ("subject") ID 
* activity - (1:6) : the label of the activity performed when the corresponding measurements were taken.

They are stored in separate files, and matching with the actual data is assumed to be doable based on simple juxtaposition.

## Features 

The dataset contains 561 features, 33 of which are of "type" mean matched with an equal number "std" features.
There are 13 'meanFreq' features, but in their case the meaning of 'mean' is
different and in my judgment not falling under the spirit of the data analysis for this project.

The 2 x 33 features selected for the project correspond to 13 root-names.

* `tGravityAcc-[X|Y|Z]`
* `tGravityAccMag`
* `tBodyAcc-[X|Y|Z]`
* `tBodyAccJerk-[X|Y|Z]`
* `tBodyGyro-[X|Y|Z]`
* `tBodyGyroJerk-[X|Y|Z]`
* `tBodyAccMag`
* `tBodyAccJerkMag`
* `tBodyGyroMag`
* `tBodyGyroJerkMag`
* `fBodyAcc-[X|Y|Z]`
* `fBodyAccJerk-[X|Y|Z]`
* `fBodyGyro-[X|Y|Z]`
* `fBodyAccMag`
* `fBodyAccJerkMag`
* `fBodyGyroMag`
* `fBodyGyroJerkMag`

The 8 root-names marked here with [X|Y|Z] correspond each to 3 separate features, hence 24 features overall, which added to the other 9 yield the
mentioned 33 features for which the data report a 'mean' and 'std'.

## Features names

Before loading the data and selecting features, the script performs a series of 'cleaning' operations on the original feature names,
with the goal of rationalizing them.  

* substitution: `"gravity","Gravity"`
* substitution: `"Gravity\\b","GravityMean"`
* substitution: `"GravityAcc","Gravity"`
* substitution: `"BodyBody","Body"`
* substitution: `"angle\\((\\w+),(\\w+)\\)","angle-\\1-\\2"`
* substitution: `"\\(\\)",""`
* substitution: `"-([XYZ]),([1-4])","\\2-\\1"`
* substitution: `"tion-([XYZ]),([XYZ])","tion-\\1\\2"`
* substitution: `"^t",""`
* renaming 'bandsEnergy' features from ending as e.g. '-11,24' to '-A3' (A/B/C and one digit)
* Swaps position between X|Y|Z descriptor and feature name:  e.g. changing 'foo-bar-X' to 'foo-X-bar'
	* substitution: `"-(\\w+)-([XYZ])$","-\\2-\\1"`
* For homogeneity with the X|Y|Z feature names, add a '-' preceding 'Mag'.
	* substitution: "Mag-","-Mag-"`
* 'Body' is redundant, hence it can be removed without ambiguity.
	* substitution: `"^Body",""`
	* substitution: `"^fBody","f"`


## Activity Labels

Numeric labels changed to descriptive strings

* 1 : walk
* 2 : walk_upstairs
* 3 : walk_downstairs
* 4 : sit
* 5 : stand
* 6 : rest

