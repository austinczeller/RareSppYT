library(tidyverse)

#Explore BirdNET results

setwd("C:/Users/austi/Documents/BirdNET_Results/")

#Clean data
all_files<-list.files(pattern='\\.txt$',recursive=T)
Master_data<-data.frame()

for(q in 1:length(all_files)){
temp<-data.frame(read_tsv(all_files[q]))
Master_data<-rbind(temp,Master_data)
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




 