

# read the UCI data into the working directory - "UCI HAR Dataset" 

# this analyses code can run smoothly and accurately 
# as long as the parent database at UCI does not increase the number of variables measured and subjects tested
# install the "dplyr" package from tools >> install packages, prior to executing this code 


myAnalysis<-function()
{
  library(dplyr)     ## summon dplyr
  
  ##   read individual files provided by UCI
  x_test<-read.table(file = "UCI HAR Dataset/test/X_test.txt")
  x_train<-read.table(file ="UCI HAR Dataset/train/X_train.txt")
  x_subject_test<-read.table(file = "UCI HAR Dataset/test/subject_test.txt")
  y_test<-read.table(file = "UCI HAR Dataset/test/y_test.txt")
  y_train<-read.table(file = "UCI HAR Dataset/train/y_train.txt")
  y_subject_train<-read.table(file = "UCI HAR Dataset/train/subject_train.txt")
  
  ##  combine the data from the test and training files 
  x<-rbind(x_test,x_train)
  info<-read.table(file = "UCI HAR Dataset/features.txt",stringsAsFactors = FALSE)
  
  ##  provide sensible variable names to columns
  colnames<-info[,2]  
  colnames(x)<-colnames
  
  # take in subject/participant number
  y<-rbind(y_test,y_train)
  colnames(y)<-c("activity")
  z<-rbind(x_subject_test,y_subject_train)
  colnames(z)<-c("subject")
  #
  x<-tbl_df(x)
  #
  
  ##  reordering the columns and only selecting mean() and standard deviation measurements
  x1<-select(x,1:6,41:46,81:86,121:126,161:166)
  x2<-select(x1,1:3,7:9,13:15,19:21,25:27)
  x3<-select(x1,-(1:3),-(7:9),-(13:15),-(19:21),-(25:27))
  data<-cbind(z,y,x2,x3)
  data<-tbl_df(data)
  data<-arrange(.data = data,subject,activity)
  activity<-select(data,activity)
  data<-select(data,-activity)
  ## replacing activity indexes with their real names as provided by UCI
  activity<-as.data.frame(activity)
  activity<-as.matrix(activity)
  activity<-as.vector(activity)
  indices <- which(activity == 1) 
  activity<-replace(activity, indices, "walking")
  indices <- which(activity == 2) 
  activity<-replace(activity, indices, "walking_upstairs")
  indices <- which(activity == 3) 
  activity<-replace(activity, indices, "walking_downstairs")
  indices <- which(activity == 4) 
  activity<-replace(activity, indices, "sitting")
  indices <- which(activity == 5) 
  activity<-replace(activity, indices, "standing")
  indices <- which(activity == 6) 
  activity<-replace(activity, indices, "laying")
  ##
  data<-tbl_df(data)
  subject<-select(data,subject)
  data<-select(data,-subject)
  data<-cbind(subject,activity,data)
  data<-tbl_df(data)
  ##
  activity_names<-levels(data[,2])
  count_act<-length(activity_names)
  column_names<-colnames(data)
  count_col<-length(column_names)-2
  
  ## using dplyr tools to group -> filter -> summarise_each column with mean() fun.
  
  data_new<-data.frame()
  data_new<-tbl_df(data_new)
  data_activity<-group_by(data,activity)
  for(i in 1:30)
  {
    data_act_sub<-filter(data_activity,subject==i)
    temp<-summarise_each(data_act_sub,funs(mean))
    data_new<-rbind(data_new,temp)
  }
  write.table(data_new,"ani.txt",row.name=FALSE)   # <<<<<<<<<<< your tidy text file, rename the prefix of the .txt file as desired
}