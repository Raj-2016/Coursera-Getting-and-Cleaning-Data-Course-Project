### Load the dplyr package

install.packages('plyr')

library(plyr)

### Task 1 - Merges the training and the test sets to create one data set.

# Step 1: Read the Training Set data

xTrain <- read.table("train/X_train.txt")
yTrain <- read.table("train/y_train.txt")
SubjectTrain <- read.table("train/subject_train.txt")

# Step 2: Read the Test Data Set 

xTest <- read.table("test/X_test.txt")
yTest <- read.table("test/y_test.txt")
SubjectTest <- read.table("test/subject_test.txt")

# Step 3: Merge  X and Y Data Set

xData <- rbind(xTrain, xTest)
YData <- rbind(yTrain, yTest)

# Merge the Subject data set

SubjectData <- rbind(SubjectTrain, SubjectTest)

# Task 2 - Extract only the measurements on the mean and standard deviation for each measurement

Features <- read.table("features.txt")

# Retrive only columns with mean() or std() in their names

mean_and_std_features <- grep("-(mean|std)\\(\\)", Features[, 2])

# Subset the desired columns
xData_Subset <- xData[, mean_and_std_features]

# Name the Columns
names(xData) <- Features[mean_and_std_features, 2]

### Task 3 - Use descriptive activity names to name the activities in the data set

activities <- read.table("activity_labels.txt")

# update values with correct activity names

YData[, 1] <- activities[YData[, 1], 2]

# correct column name
names(YData) <- "activity"

# Task 4 - Appropriately label the data set with descriptive variable names

# correct column name
names(SubjectData) <- "subject"

# bind all the data in a single data set
all_data <- cbind(xData, YData, SubjectData)

# Task 5 - # Create a second, independent tidy data set with the average of each variable
# for each activity and each subject


# 66 <- 68 columns but last two (activity & subject)
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "averages_data.txt", row.name=FALSE)
