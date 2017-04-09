# CleaningData
Repo for the Coursera course Cleaning Data project

# Obtaining the data
This system will automatically download the data into the directory `UCI HAR Dataset`.

Codebooks for the original data are there.

# Output
Data from this program is output into `new_data.txt`

See the file `codebook.txt` for a brief explanation of the data in the output file

# Running the system
Executing `run_analysis.R` will execute the analysis, including download the original dataset.


# How the code works.
The code downloads the original data, attempting to do the minimal work to do so.

The first step is to process the file that links feature ids to feature names. This will be used to label the columns.

The observational data is then read in (merging the test and training datasets), and the column labels applied. Duplicate columns are eliminated and the mean and std columns selected.

The subjects and activities are then read in and appended to the data to form two new columns (we translate from the activity ids to activity names as we do so).

Subsequently the data is grouped by subject and by activity before being summarized by mean on every other column.

It is this data that is produced.
