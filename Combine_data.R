library(tidyverse)

#Create data files per HDD

HDD<-dir("C:/Users/austi/Documents/BirdNET_Results/",pattern = "HDD") #list hard drives 

#Loop to load create data files per HDD

for(t in 3:length(HDD)){
  setwd(paste0("C:/Users/austi/Documents/BirdNET_Results/",HDD[t]))
  all_files<-list.files(pattern='\\.txt$',recursive=T)
  Master_data_temp<-data.frame()
  print(paste0("XXXX SCANNING ",HDD[t],"XXXX"))
  print(Sys.time())
  print(paste0("READING: ",length(all_files)," files"))
  
  for(q in 1:length(all_files)){
    temp<-read.table(all_files[q],header=T,sep= '\t')
    Master_data_temp<-rbind(temp,Master_data_temp)
    if(q==round(.25*length(all_files))){print(paste0("~~~~~25% Complete @ ",Sys.time()," ",HDD[t],"~~~~~"))}
    if(q==round(.5*length(all_files))){print(paste0("~~~~~50% Complete @ ",Sys.time()," " ,HDD[t],"~~~~~"))}
    if(q==round(.75*length(all_files))){print(paste0("~~~~~75% Complete @ ",Sys.time()," ",HDD[t],"~~~~~"))}
    if(q==round(length(all_files))){print(paste0("~~~~~100% Complete @ ",Sys.time()," ",HDD[t],"~~~~~"))}
  }
  
  write.csv(Master_data_temp,paste0(HDD[t],"_data.csv"),row.names=FALSE)
  print(paste0(HDD[t]," CSV SAVED"))
  print(Sys.time())
  }

recording_data<-Master_data%>%group_by(Begin.File)%>%
  summarize(Common.Name=unique(Common.Name))

spp_counts<-recording_data%>%group_by(Common.Name)%>%
  summarize(count=n())

#Visualize the data
unique(Master_data$Common.Name)
ggplot()+geom_point(aes(x=spp_counts$count,y=spp_counts$Common.Name))+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  xlab("Number of recordings with spp observed")+
  ylab("Species Common Name")




