library(tidyverse)
library(reticulate)
library(sys)

#RUN BIRDNET ON FOLDERS MISSED ON FIRST PASS
setwd("C:/Users/austi/Documents/BirdNET/BirdNET-Analyzer/BirdNET-Analyzer/")
HDD<-data.frame(x=dir("E:/"))#CHANGE TO WHAT DISK YOUR USING

RESULTS<-data.frame(x=dir("C:/Users/austi/Documents/BirdNET_Results/HDD1/")) #CHANGE THE HDD NUMBER

SPACES<-subset(HDD,!(HDD$x%in%RESULTS$x))%>%
  filter(!x%in%c("$RECYCLE.BIN","System Volume Information","Seagate","Start_Here_Mac.app","Autorun.inf",
                 "bootTel.dat","Install Discovery for Mac.dmg","Install Discovery for Windows.exe","TrueDelete"))%>%
  as.matrix() #MAY NEED TO FILTER OUT EXTRA FILES
SPACES
MISSING_FOLDERS<-gsub(" ","_", SPACES)

#rename folders to have _ instead of spaces
for(j in 1:length(MISSING_FOLDERS)){
  file.rename(paste0("E:/",SPACES[j]),paste0("E:/",MISSING_FOLDERS[j])) #change to correct file path
}

for(r in 1:length(MISSING_FOLDERS)){
  i<-paste0("E:/",MISSING_FOLDERS[r])
  o<-paste0("C:/Users/austi/Documents/BirdNET_Results/HDD8/",MISSING_FOLDERS[r])
  ifelse(file.exists(o),print("File Exists"),dir.create(o))
  slist<-"C:/Users/austi/Documents/BirdNET_Results/species_list.txt"
  systeminput<-paste0("py analyze.py --threads 4 --min_conf 0.5 "," --slist ",slist,
                 " --i ",i," --o ",o)
  system(systeminput)
}

