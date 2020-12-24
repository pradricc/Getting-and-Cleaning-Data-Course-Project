#create tidy dataset

# 1 step - load training files from windows filesystem

#load into a table subject_train file containing subject id, subject is the volunteer 
#who partecipate to the experiment
sub_train_tab = read.table(".\\UCI HAR Dataset\\train\\subject_train.txt")

#load into a table y_train file containing training label, that is id 
#that identifies activity (walking, sitting and so on)
y_train_tab = read.table(".\\UCI HAR Dataset\\train\\y_train.txt")

#load into a table X_train file containing all the measurement 
#related to the experiment
X_train_tab = read.table(".\\UCI HAR Dataset\\train\\X_train.txt")

# 2 step - appending training files
#load into a table the paste of the 3 training files
train_tab = cbind(sub_train_tab, y_train_tab, X_train_tab)

# 3 step - load test files from windows filesystem
#do the same for test data
sub_test_tab = read.table(".\\UCI HAR Dataset\\test\\subject_test.txt")
y_test_tab = read.table(".\\UCI HAR Dataset\\test\\y_test.txt")
X_test_tab = read.table(".\\UCI HAR Dataset\\test\\X_test.txt")

# 4 step - appending test files
test_tab = cbind(sub_test_tab, y_test_tab, X_test_tab)

# 5 step - merging training and test data in a single table
tab = rbind(train_tab, test_tab)


# 6 step - read measure dataset column names
measure_names_tab = read.table(".\\UCI HAR Dataset\\features.txt")

# step 7 - set names for the first 2 columns
column_names = c("Volunteer ID", "Activity Description")

#step 8 - set names for feature columns
features_names = as.vector(t(measure_names_tab[,2]))
colnames(tab) = append(column_names, features_names)

#step 9 - select only mean and standard deviations
tab_filtered = tab[c(1:8, 43:48, 83:88, 123:128, 163:168, 203, 204, 
                     216, 217, 229, 230, 242, 243, 255, 256, 268:273,
                     347:352, 426:431, 505, 506, 518, 519, 531, 532,
                     544, 545)]

#step 10 - tidy data set with average of each variable for each activity and each subject
tmp_agg = aggregate(tab_filtered, by = list(tab_filtered$"Volunteer ID", tab_filtered$"Activity Description"), FUN = mean)

dataset_tidy = tmp_agg[,3:70]

dataset_tidy$"Activity Description" = factor(dataset_tidy$`Activity Description`,
                  levels = c(1,2,3,4,5,6), labels = c("WALKING", "WALKING_UPSTAIRS", 
                             "WALKING_DOWNSTAIRS","SITTING", 
                             "STANDING", "LAYING"))

# step 11 - create a file containing tidy dataset
file.create("ProjectDatasetTidy.txt")
write.table(dataset_tidy, file="ProjectDatasetTidy.txt", row.name=FALSE)
