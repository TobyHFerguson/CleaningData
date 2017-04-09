require(dplyr)

nrows = -1 # useful for testing over a small number of rows

data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zip_file <- "getdata%2Fprojectfiles%2FUCI HAR Dataset.zip"
data_dir <- "UCI HAR Dataset"

if (!dir.exists(data_dir)) {
  if (!file.exists(zip_file)) {
    print(paste0("Downloading source data from", data_url))
    download.file(url=data_url, destfile=zip_file, method="curl")
  } else {
    print(paste0("Expanding source zip file to create ", data_dir, " data directory"))
    unzip(zip_file)
  }
}




# A function to read in a named file from the two directories and to merge them
rd <-
  function(file) {
    bind_rows(tbl_df(read.table(
      paste0(data_dir,'/test/', file, '_test.txt'),
      nrows = nrows
    )),
    tbl_df(read.table(
      paste0(data_dir,'/train/', file, '_train.txt'),
      nrows = nrows
    )))
  }

# Process the features so that we can label the columns
features <-
  read.table(paste0(data_dir, '/features.txt'), stringsAsFactors = FALSE)

# Read in the data
data <- rd('X')
names(data) <- features$V2
# Eliminate duplicated column names
data <- data[,!duplicated(colnames(data))]
# Select on the mean() and std() columns
data <- select(data, matches('.*(mean|std)[(][)].*'))

# Get the subjects
subjectid <- rd('subject')
names(subjectid) <- "subjectid"

activityid <- rd('y')
names(activityid) <- "activityid"

activity_table <-
  tbl_df(read.table(paste0(data_dir,'/activity_labels.txt'), stringsAsFactors = FALSE))
names(activity_table) <- c("activityid", "activities")

activity_vector <-
  select(inner_join(activityid, activity_table), activities)

data <- bind_cols(subjectid, activity_vector, data)

data %>%
  group_by(subjectid, activities) %>%
  # And calculate the means within each group
  summarize_each("mean") %>%
  # Then write it out to a file
  write.table(file = "new_data.txt", row.names = FALSE)
