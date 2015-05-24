# project for Coursera course on Getting and Cleaning Data

There is a single R script in this repository, run_analysis.R. This
script is run with no arguments.  The script 

1) downloads the data (if it doesn't find that the data has
already been downloaded; note that the file will be downloaded
into directories I've created on my system, relative to the working
directory, in "./private/DataScience/GettingAndCleaningData"; note
also that I'm using a Mac and therefore use download.file() with
method = "curl")

2) unzips it; this creates a directory "UCI HAR Dataset" in the
directory noted just above

3) merges the training and test sets into a single data frame, 

4) takes the feature names found in features.txt and makes them
slightly more readable by removing "()" and substituting period for
underscore, and then uses these feature names for the names of the
columns in the data frame

5) extracts the features that have "mean" or "std" (with any casing) in
the feature names

6) adds a column with the subject number for each row of measurements

7) adds a column with the name of the activity being performed during
the time of each row's measurements were made

8) creates an average of each variable for each activity and each
subject

9) and saves the result of 5-8 above into a new file

The meaning of the variable names can be found in the Codebook.md file 
(but note that each variable in the output data set is the mean of the
measurements of that variable (per subject, per activity) in the input
data set).