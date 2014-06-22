# Codebook  

Below is how the code works.   After it is a definition of the variables.

## Code
This script assumes you have the run_analysis.R file in the same directory as the unzipped zip file which is located [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).   
There is a full description of how it was acquired [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).  

The R script will unzip the file, read in all the files, fix the variable names, combine the files, extract the mean and standard deviation data, calculate averages, fix the activity names, then finally output a CSV file with the table we are required to produce for the assignment.

This script was developed in Windows using R studio version 0.98.501 and R version 3.1.0, so I decided not to have the script download the file for you as have to use the method=”curl” option for non-Windows pc’s.  Not having to account for the curl method simplified the script.  

R unzips the file into the default folder called UCI HAR Dataset.  This creates two subfolders, test and train, and four text files. The actual recorded data is in the subfolders.  

I read in the all files as a csv because it was simpler.  When reading in the activities and features it does create an extra column on the file which is easily removed with the subset command.  

At this point I chose to fix the variable names to help make this tidy data. I fixed all of them even though I probably only needed to fix the mean and standard deviation variables. I used simple gsub commands to do this.  

First I removed parentheses because if you tried to refer to the variable names in R in the original state with those parentheses it would think you are calling a function and throw up errors.   

I removed the dashes and then I started to expand abbreviation, capitalizing the first letter, even choosing to reword some like ‘maxInds” to something more descriptive.  (I changed it to FrequencyWith LargestMagnitudeIndex).  

In the renaming, replacing single letters like ‘t’ and ‘f’ (for Time and Frequency) messed up some of the other variable names but I fixed them immediately after those substitutions .  You can see this if you look at the code.  
What I did above makes the column names tidy because I removed punctuation and special characters (commas, dashes and parentheses) as well as making the names more readable (not abbreviated).

I then read in the actual training data and subject data.  

I combined the x data into one body with rbind and I did similarly with the y data and subject data.  
At this point I fixed the column names for the y data and subject data to “Activity and “Participant” respectfully. I also added the corrected variable names for the x data.  

Next I grabbed all the column names that had mean or standard deviation in them.  There are 66 such columns out of the 561.  I chose to exclude the originally named meanFreq columns as the original codebook said they were “weighted average of the frequency of components to obtain a mean frequency.” I interpreted this as they were not pure means so they could be excluded.  

When I was looking over the original files trying to get started I was looking at the feature file and it had all the column names numbered.  I used this to my advantage and grabbed the numbers of the columns I needed and put it in a variable called meanStdColNames and used that to grab all the data for only those columns.  

Grabbing that data meant we had a set of data with the subject, activity and then the 66 mean and standard deviation data.  I waited to update the activity data because doing so here would complicate the algorithm I was going to run below.  
I then cbinded the y data and x data so the y data was in the leftmost column.  I then cbinded the subject data with the result from the previous step making it the left most column.  

To create the data set specified by instruction 5, a “data set with the average of each variable for each activity for each subject” I used a double loop to extract this data.  I looped over the 30 subjects then looped over the 6 activities to put all rows that met those requirements into a variable called tempData.  I then used sapply to calculate the averages on that data. I then rbinded those rows into a master variable called meanData.  

At the end of this process we end up with a 180 row by 68 column matrix.  In it, it contains the average for each of the 6 activities for each of the 30 participants.  

For data manipulation purposes I converted the meanData matrix to a data frame so I could fix the activity names.  
The original activity names are descriptive enough but I had two issues with them.  One, they were in all caps and I felt like someone was yelling at me and two, a couple of the names had underscores in them.  The underscores are a no-no in tidy data.  So I removed the underscores and only capitalized the first letter in each word.  

I then went back and replaced all the numeric values for the activities with the words.  

I then wrote that data frame to a csv file.  

Why is this tidy data?  First, the variable names are human readable (no abbreviations and unnecessary punctuation).   Second each variable we are measuring is in its own column (all the mean and standard deviation columns).  Each different observation is on its own row (there are 30 subjects with 6 activities each).  


## Variables  

Information about the variables is taken nearly verbatim from the features_info.txt file included in the original data.  I took the original variables, cleaned them up and added the Participant and Activity.

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals TimeAccelerationXYZ and TimeGyroscopicXYZ. These time domain signals were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (TimeBodyAccelerationXYZ and TimeGravityAccelerationXYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (TimeBodyAccelerationJerkXYZ and TimeBodyGyroscopicJerkXYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (TimeBodyAccelerationMagnitude, TimeGravityAccelerationMagnitude, TimeBodyAccelerationJerkMagnitude, TimeBodyGyroscopicMagnitude, TimeBodyGyroscopicJerkMagnitude). 

Finally a Fast Fourier Transform (FFT) was applied to some ofI  these signals producing FrequencyBodyAccelerationXYZ, FrequencyBodyAccelerationJerkXYZ, FrequencyBodyGyroscopicXYZ, FrequencyBodyAccelerationJerkMagnitude, FrequencyBodyGyrosopicMagnitude, FrequencyBodyGyroscopicJerkMagnitude. 

These signals were used to estimate variables of the feature vector for each pattern:  
'XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

TimeBodyAccelerationXYZ  
TimeGravityAcelerationXYZ  
TimeBodyAccelerationJerkXYZ  
TimeBodyGyroscopicXYZ  
TimeBodyGyroscopicJerkXYZ  
TimeBodyAccelerationMagnitude  
TimeGravityAccelerationMagnitude  
TimeBodyAccelerationJerkMagnitude  
TimeBodyGyroscopicMagnitude  
TimeBodyGyroscopicJerkMagnitude  
FrequncyBodyAccelerationXYZ  
FrequencyBodyAccelerationJerkXYZ  
FrequencyBodyGyroscopicXYZ  
FrequencyBodyAccelearationMagnitude  
FrequencyBodyAccelerationJerkMagnitude  
FrequencyBodyGyroscopicMagnitude  
FrequencyBodyGyroscopicJerkMagnitude  

The set of variables that were estimated from these signals are (with some explanation): 

Mean  
StandardDeviation  
MedianAbsoluteDeviation   
Max: Largest value in array  
Min: Smallest value in array  
SignalMagnitudeArea  
Energy: Energy measure. Sum of the squares divided by the number of values.   
InterquartileRange   
Entropy: Signal entropy  
AutorregresionCoefficients: with Burg order equal to 4  
Correlation: correlation coefficient between two signals  
FrequencyWithLargestMagnitudeIndex: index of the frequency component with largest magnitude  
MeanFreqency: Weighted average of the frequency components to obtain a mean frequency  
Skewness: skewness of the frequency domain signal   
Kurtosis: kurtosis of the frequency domain signal   
EnergyBands: Energy of a frequency interval within the 64 bins of the FFT of each window.  
Angle: Angle between to vectors.  

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

GravityMean  
TimeBodyAccelerationMean  
TimeBodyAccelerationJerkMean  
TimeBodyGyroscopicMean  
TBodyGyroscopicJerkMean  

#### My additions

Participant – number indicating the subject.  Ranges from 1 to 30.  

Activity – 6 activities each subject did with the device. The activities are walking, walking upstairs, walking downstairs, sitting, standing, and laying.  

#### Below is a table of the cleaned up variable names used in the final along with their original names in the data.  


New Name | Old Name
-------------- | --------------
TimeBodyAccelerationMeanX | tBodyAcc-mean()-X
TimeBodyAccelerationMeanY  | tBodyAcc-mean()-Y
TimeBodyAccelerationMeanZ | tBodyAcc-mean()-Z
TimeBodyAccelerationStandardDeviationX  | tBodyAcc-std()-X 
TimeBodyAccelerationStandardDeviationY | tBodyAcc-std()-Y
TimeBodyAccelerationStandardDeviationZ  | tBodyAcc-std()-Z
TimeGravityAccelerationMeanX	 | tGravityAcc-mean()-X
TimeGravityAccelerationMeanY  | tGravityAcc-mean()-Y
TimeGravityAccelerationMeanZ	 | tGravityAcc-mean()-Z
TimeGravityAccelerationStandardDeviationX  | tGravityAcc-std()-X 
TimeGravityAccelerationStandardDeviationY | tGravityAcc-std()-Y
TimeGravityAccelerationStandardDeviationZ | tGravityAcc-std()-Z
TimeBodyAccelerationJerkMeanX | tBodyAccJerk-mean()-X
TimeBodyAccelerationJerkMeanY | tBodyAccJerk-mean()-Y 
TimeBodyAccelerationJerkMeanZ | tBodyAccJerk-mean()-Z
TimeBodyAccelerationJerkStandardDeviationX | tBodyAccJerk-std()-X
TimeBodyAccelerationJerkStandardDeviationY | tBodyAccJerk-std()-Y
TimeBodyAccelerationJerkStandardDeviationZ | tBodyAccJerk-std()-Z    
TimeBodyGyroscopicMeanX | tBodyGyro-mean()-X
TimeBodyGyroscopicMeanY | tBodyGyro-mean()-Y                                
TimeBodyGyroscopicMeanZ | tBodyGyro-mean()-Z
TimeBodyGyroscopicStandardDeviationX | tBodyGyro-std()-X                   
TimeBodyGyroscopicStandardDeviationY | tBodyGyro-std()-Y
TimeBodyGyroscopicStandardDeviationZ | tBodyGyro-std()-Z 
TimeBodyGyroscopicJerkMeanX	 | tBodyGyroJerk-mean()-X
TimeBodyGyroscopicJerkMeanY	 | tBodyGyroJerk-mean()-Y
TimeBodyGyroscopicJerkMeanZ	 |tBodyGyroJerk-mean()-Z
TimeBodyGyroscopicJerkStandardDeviationX | tBodyGyroJerk-std()-X
TimeBodyGyroscopicJerkStandardDeviationY | tBodyGyroJerk-std()-Y
TimeBodyGyroscopicJerkStandardDeviationZ | tBodyGyroJerk-std()-Z
TimeBodyAccelerationMagnitudeMean	| tBodyAccMag-mean()
TimeBodyAccelerationMagnitudeStandardDeviation | tBodyAccMag-std()
TimeGravityAccelerationMagnitudeMean | tGravityAccMag-mean()
TimeGravityAccelerationMagnitudeStandardDeviation | tGravityAccMag-std()
TimeBodyAccelerationJerkMagnitudeMean | tBodyAccJerkMag-mean()
TimeBodyAccelerationJerkMagnitudeStandardDeviation	 | tBodyAccJerkMag-std()
TimeBodyGyroscopicMagnitudeMean | tBodyGyroMag-mean()
TimeBodyGyroscopicMagnitudeStandardDeviation | tBodyGyroMag-std()
TimeBodyGyroscopicJerkMagnitudeMean | tBodyGyroJerkMag-mean()
TimeBodyGyroscopicJerkMagnitudeStandardDeviation | tBodyGyroJerkMag-std()
FrequencyBodyAccelerationMeanX | fBodyAcc-mean()-X
FrequencyBodyAccelerationMeanY | fBodyAcc-mean()-Y                         
FrequencyBodyAccelerationMeanZ  | fBodyAcc-mean()-Z
FrequencyBodyAccelerationStandardDeviationX | fBodyAcc-std()-X            
FrequencyBodyAccelerationStandardDeviationY	 | fBodyAcc-std()-Y
FrequencyBodyAccelerationStandardDeviationZ	 | fBodyAcc-std()-Z            
FrequencyBodyAccelerationJerkMeanX	|fBodyAccJerk-mean()-X
FrequencyBodyAccelerationJerkMeanY | fBodyAccJerk-mean()-Y                     
FrequencyBodyAccelerationJerkMeanZ	| fBodyAccJerk-mean()-Z
FrequencyBodyAccelerationJerkStandardDeviationX |fBodyAccJerk-std()-X        
FrequencyBodyAccelerationJerkStandardDeviationY |fBodyAccJerk-std()-Y
FrequencyBodyAccelerationJerkStandardDeviationZ | fBodyAccJerk-std()-Z        
FrequencyBodyGyroscopicMeanX | fBodyGyro-mean()-X
FrequencyBodyGyroscopicMeanY  | fBodyGyro-mean()-Y                          
FrequencyBodyGyroscopicMeanZ | fBodyGyro-mean()-Z
FrequencyBodyGyroscopicStandardDeviationX | fBodyGyro-std()-X              
FrequencyBodyGyroscopicStandardDeviationY | fBodyGyro-std()-Y
FrequencyBodyGyroscopicStandardDeviationZ | fBodyGyro-std()-Z             
FrequencyBodyAccelerationMagnitudeMean | fBodyAccMag-mean()
FrequencyBodyAccelerationMagnitudeStandardDeviation | fBodyAccMag-std()    
FrequencyBodyAccelerationJerkMagnitudeMean | fBodyBodyAccJerkMag-mean()
FrequencyBodyAccelerationJerkMagnitudeStandardDeviation | fBodyBodyAccJerkMag-std()
FrequencyBodyGyroscopicMagnitudeStandardDeviation	 | fBodyBodyGyroMag-std()
FrequencyBodyGyroscopicMagnitudeMedianAbsoluteDeviation | fBodyBodyGyroMag-mad()
FrequencyBodyGyroscopicJerkMagnitudeMean	|fBodyBodyGyroJerkMag-mean()
FrequencyBodyGyroscopicJerkMagnitudeStandardDeviation | fBodyBodyGyroJerkMag-std()  
