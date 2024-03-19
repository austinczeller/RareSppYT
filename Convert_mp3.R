library(tuneR)

setwd("Arctic_GS/Training")#change to what folder you want to convert
files<-dir()

for(w in 1:length(files)){
mp3 <- readMP3(files[w])
wav_name<-paste0(files[w],".wav")
writeWave(mp3,wav_name,extensible=FALSE)
}

