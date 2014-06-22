unzip("getdata_projectfiles_UCI HAR Dataset.zip")

#this adds an extra column, which is easy to remove
activityLabels <- read.csv("./UCI HAR Dataset/activity_labels.txt",header=FALSE,sep="")        
activityLabels <- subset(activityLabels,select=c(V2))
colnames(activityLabels) <- "Activity"

#this also adds an extra column, which is easily removed
featureList <- read.csv("./UCI HAR Dataset/features.txt",header=FALSE,sep="")
featureList <- subset(featureList,select=c(V2))

#Part IV
#fix variable names in features
featureListCorrected <- gsub("\\(\\)","",featureList$V2)
featureListCorrected <- gsub("-","",featureListCorrected)
featureListCorrected <- gsub("t","Time",featureListCorrected)
featureListCorrected <- gsub("sTimed","StandardDeviation",featureListCorrected)
featureListCorrected <- gsub("GraviTimey", "Gravity",featureListCorrected)
featureListCorrected <- gsub("kurTimeosis","Kurtosis",featureListCorrected)
featureListCorrected <- gsub("enTimeropy","Entropy",featureListCorrected)
featureListCorrected <- gsub("f","Frequency",featureListCorrected)
featureListCorrected <- gsub("arCoeFrequencyFrequency","AutoregressionCoefficient",featureListCorrected)
featureListCorrected <- gsub("Acc","Acceleration",featureListCorrected)   
featureListCorrected <- gsub("meanFreq","MeanFrequency",featureListCorrected)
featureListCorrected <- gsub("mean","Mean",featureListCorrected) 
featureListCorrected <- gsub("Mag","Magnitude",featureListCorrected)
featureListCorrected <- gsub("Gyro","Gyroscopic",featureListCorrected)
featureListCorrected <- gsub("iqr","InterquartileRange",featureListCorrected) 
featureListCorrected <- gsub("mad","MedianAbsoluteDeviation",featureListCorrected)
featureListCorrected <- gsub("sma","SignalMagnitudeArea",featureListCorrected)
featureListCorrected <- gsub("maxInds","FrequencyWithLargestMagnitudeIndex",featureListCorrected)
featureListCorrected <- gsub("BodyBody","Body",featureListCorrected)
featureListCorrected <- gsub("max", "Max",featureListCorrected)
featureListCorrected <- gsub("energy","Energy",featureListCorrected)
featureListCorrected <- gsub("bandsEnergy","EnergyBand",featureListCorrected)
featureListCorrected <- gsub("min","Min",featureListCorrected)
featureListCorrected <- gsub("skewness","Skewness",featureListCorrected)
featureListCorrected <- gsub("correlation","Correlation",featureListCorrected)
featureListCorrected <- gsub("angle\\(","AngleBetween",featureListCorrected)
featureListCorrected <- gsub(",","And",featureListCorrected)
featureListCorrected <- gsub("\\)","",featureListCorrected)

#read in the rest of the files
xTrain <- read.csv("./UCI HAR Dataset/train/X_train.txt",header=FALSE,sep="") 
yTrain <- read.csv("./UCI HAR Dataset/train/y_train.txt",header=FALSE,sep="")
subjectTrain <- read.csv("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)
xTest <- read.csv("./UCI HAR Dataset/test/X_test.txt",header=FALSE,sep="")
yTest <- read.csv("./UCI HAR Dataset/test/y_test.txt",header=FALSE,sep="")
subjectTest <- read.csv("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)

#combine xtrain and xtest
xData <- rbind(xTrain,xTest)

#combine ytrain and ytest
yData <- rbind(yTrain,yTest)

#combine subjectTrain and subject Test
subjectData <- rbind(subjectTrain,subjectTest)

#Fix column names for activities and subjects
colnames(yData) <- "Activity"
colnames(subjectData) <- "Participant"

#need to clean names up first
colnames(xData) <- featureListCorrected

#These are the columns we need to create the first dataset (from the features list)
#They include columns with mean and std in them.  They exclude any cols with meanFreq in them (see readme for more)
meanStdColNumbers <- c(1:6,41:46,81:86,121:126,161:166,201,202,214,215,227,228,240,241,253,254,266:271,345:350,424:429,503,504,516,517,530,531,542,543) 

#Part II
#grab the data in those columns
rawMeanStdData <- xData[,meanStdColNumbers]

#bind subject and activity to training data
intermediateData <- cbind(yData,rawMeanStdData)
completeData <- cbind(subjectData,intermediateData)

#Part V
meanData <- NULL
for (subindex in 1:30) {
    tempData <- NULL
    for (actindex in 1:6) {
        meanStd <- NULL
        tempData <- completeData[completeData$Activity == actindex & completeData$Participant == subindex,]
        meanStd <- sapply(tempData,mean)
        meanData <- rbind(meanData,meanStd) 
    }   
}

meanDataDF <- as.data.frame(meanData)
#creating a data frame adds row names of meanData to all the rows, setting them to NULL gets rid of that
row.names(meanDataDF) = NULL

#Part III
#fix activity names
#activitylabels$V2 is a factor - need to change to character
activityLabels$Activity <- as.character(activityLabels$Activity)
activityLabels$Activity[1]<-"Walking"
activityLabels$Activity[2]<-"Walking Upstairs"
activityLabels$Activity[3]<-"Walking Downstairs"
activityLabels$Activity[4]<-"Sitting"
activityLabels$Activity[5]<-"Standing"
activityLabels$Activity[6]<-"Laying"

#fix labels in the part V table
meanDataDF$Activity[meanDataDF$Activity==1] <- as.character(activityLabels$Activity[1])
meanDataDF$Activity[meanDataDF$Activity==2] <- as.character(activityLabels$Activity[2])
meanDataDF$Activity[meanDataDF$Activity==3] <- as.character(activityLabels$Activity[3])
meanDataDF$Activity[meanDataDF$Activity==4] <- as.character(activityLabels$Activity[4])
meanDataDF$Activity[meanDataDF$Activity==5] <- as.character(activityLabels$Activity[5])
meanDataDF$Activity[meanDataDF$Activity==6] <- as.character(activityLabels$Activity[6])

#output table to a file
write.csv(meanDataDF,"MeanStandardDeviationSummary.csv", row.names=FALSE)
