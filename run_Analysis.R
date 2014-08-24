install.packages("data.table")
install.packages("reshape2")

require("data.table")
require("reshape2")

activity_names <- read.table("./UCI HAR Dataset/activity_names.txt")[,2] # Load activity names
feature_names <- read.table("./UCI HAR Dataset/features.txt")[,2] # Load data column names
extract_features <- grepl("mean|std", feature_names) # Extraction of measurements on the mean and standard deviation

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
X_testing <- read.table("./UCI HAR Dataset/test/X_test.txt") # Load and process X_test data
y_testing <- read.table("./UCI HAR Dataset/test/y_test.txt") # Load and process y_test data.

names(X_testing) = feature_names
X_testing = X_testing[,extract_features]

y_testing[,2] = activity_names[y_testing[,1]] # Load activity names
names(y_testing) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

testing_data <- cbind(as.data.table(subject_test), y_testing, X_testing) # Binding the data

X_training <- read.table("./UCI HAR Dataset/train/X_train.txt") # Load and process X_training data
y_training <- read.table("./UCI HAR Dataset/train/y_train.txt") # Load and process y_training data
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

names(X_training) = feature_names

X_training = X_training[,extract_features] # Extraction of the measurements on the mean and standard deviation
y_training[,2] = activity_names[y_training[,1]] # Load activity data
names(y_training) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

training_data <- cbind(as.data.table(subject_train), y_training, X_training) # Binding the data
data = rbind(testing_data, training_data) # Merge test and train data

id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean) # Apply mean function

print("From data files in \"UCI HAR Dataset\"")
print("New tidy data file")
write.table(tidy_data, file = "./tidy_data.txt") # Create tidy data file set