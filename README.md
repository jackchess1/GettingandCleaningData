# Getting and Cleaning Data Course Final Project

by Jack Chesson

## How run_analysis Works

1. The required packages are loaded into the R environment
2. The data is downloaded as a zip file from the url
3. Data for labelling and measurements is uploaded to the R environment to clean labels and specify measurements used
4. Data for training and test groups are uploaded to the R environment and are cleaned and updated using the specified labels
5. Data from train and test data are merged onto one dataset
6. Activity labels are added to the dataset
7. The data is written into a text file in the working directory
