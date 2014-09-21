# read the UCI data into the working directory - "UCI HAR Dataset" 

# this analyses code can run smoothly and accurately 
# as long as the parent database at UCI does not increase the number of variables measured and subjects tested
# install the "dplyr" package from tools >> install packages, prior to executing this code 

## summon dplyr

##   read individual files provided by UCI under test and training data

##   match them with their corresponding candidate indexes

##  provide sensible variable names to columns

# take in subject/participant number 

##  reordering the columns and only selecting mean() and standard deviation measurements

## replace activity indexes with their real names as provided by UCI

## using dplyr tools to group -> filter -> summarise_each column with mean() fun.