# README - JH Data Cleaning Project #


## File 1 : run-analysis.R ##
-----------------------------
-----------------------------

A set of libraries are preloaded. Some libraries may not be used in final code

### Notes on Data ##
-----------------

The data presented in this project is derived from an investigation by Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz.
It is experimental data taking measurements from cellular phone based accelerometers & gyroscopes (Samsung Galaxy II) worn by participants in a variety of 
assigned activities. Signals from the sensors are divided into body acceleration and gravity measures.


## Notes on Extraction ##
-----------------------

This file contains the complete set of scripts used to download, extract, manipulate and analyze data.

The .R file contains download instructions, local sub-directory paths are set in the script. There is a automated
directory name change to deal with an incompatibility resulting from the original .zip file. The .zip file is 
saved as master_zp.zip in the working directory of the user.

Provided files for training and testing cohorts are made readable prior to amalgamation into a master file.
Descriptive activities are added to the master file for readability. These can than be transfered to the 
reduced file with mean and std.dev information afterward.

The script writes to the working directory 3 times. Once as a check for training and test data, once for a check on 
the amalgamated master file, and once as an output of the tidy data file at the end (in both .txt & .csv formats).

## Notes on Variables ##
----------------------

Indicator variables from the master data are: Subject, Activity_code, Activity . The subject and activity codes
follow the raw data. Activity is a descriptive term applied to each activity code. They describe the action
taken by experiment participants: 
```{r}
Activity_code  	Description		    Activity
1			          Walk			        WALK
2			          Walk upstairs		  WALK_UP
3			          Walk downstairs		WALK_DOWN
4			          Sit			          SIT
5			          Stand			        STAND
6			          Lay down		      LAY
```
Extracted variables from the master data include the 1st two indicator variables and the mean and std.dev variables for 
each corresponding sub measurement after filtering from the original signal has been applied. 
Results are reported for axes suffixes (X,Y,Z) of both time (t) and frequency (f) prefixes. 

The results presented in the tidy data file represented the average of the observations. i.e. :
for any given variable the result is the average of either the mean, std.dev, or mean Frequency observations across students for each of the 
six relevant activities. So the result for tBodyAcc-mean()-X for student 1 with activity LAY is: 
the mean all observation means of a timed body acceleration measure along the X axis when student #1 is laying down.

The list of variables with RAW & descriptive names follows:
```{r set-options}
    options(width=25)
Variable  		        Description

Subject				        Subject
Activity_code		      [Not Included]
Activity			        Activity

tBodyAcc-XYZ		  	  time measures of Body Acceleration 
tGravityAcc-XYZ			  time measures of Gravity Acceleration
tBodyAccJerk-XYZ		  time measures of Body Jerk
tBodyGyro-XYZ			    time measures of Gyrometer
tBodyGyroJerk-XYZ		  time measures of Gyrometer Jerk
tBodyAccMag			      time measures of Body Accelartion magnitude
tGravityAccMag			  time measures of Gravity Acceleration magnitude
tBodyAccJerkMag			  time measures of Body Jerk magnitude
tBodyGyroMag	  		  time measures of Gyrometer magnitude
tBodyGyroJerkMag		  time measures of Gyrometer Jerk magnitude
fBodyAcc-XYZ		  	  frequency measures of Body Acceleration 
fBodyAccJerk-XYZ		  frequency measures of Body Jerk
fBodyGyro-XYZ			    frequency measures of Gyrometer
fBodyAccMag			      frequency measures of Body Acceleration magnitude
fBodyAccJerkMag			  frequency measures of Body Jerk magnitude
fBodyGyroMag			    frequency measures of Gyrometer magnitude
fBodyGyroJerkMag		  frequency measures of Gyrometer Jerk magnitude

```

There are 66 Extracted variables and 2 indicator variables in the tidy data set.Units are normalized for all measurements between [-1,1] . 

Data are arranged as follows:

```{r}
Subject	Activity	Var1	  Var2    ...
1	      LAY	    	0.1234	0.1234	...
```

## Notes on Script procedure ##
-----------------------------

The script run_analysis.R is available on https://github.com/shuteye/

The script is divided into 7 parts.
Part I: 	Library usage.

Part II: 	File download. This includes amendments to the storage directory. File is unzipped within R script. Url provided in .R file.

Part III: 	Text files are read into memory from relevant sub-folders. Test & training data are merged into a master file. Features.txt is used to name columns.

Part IV: 	Activity descriptions are added using a gsub command routine and the combined master file is amended. Cloning is used to convert activity codes into character descriptives.

Part V:		Variables concerning the mean() and std() are identified by script       pattern. A reduced dataset is created for those variables. Character matching is used to filter variables through their names.

Part VI: 	The reduced file is transformed into molten format. Means of each variable are calculated across student # + activity

A tidy dataset is output in .csv & .txt formats for review

Please note the .R script is heavily annotated for specific reference to commands and routines used. Please refer to the script for 
code specific queries


## License: ##
==============
Acknowledgement of use of original dataset [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.

