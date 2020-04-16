library(shiny)
library(tidyverse)
library(rsconnect)
library(lubridate)

#https://data.cityofnewyork.us/Public-Safety/NYPD-Complaint-Data-Historic/qgea-i56i
crimedf<-read.csv("NYDP_crime_data.csv")
token<-read.csv("../../code/shinylogin.csv",stringsAsFactors = FALSE)
names(crimedf)<-c("id","start_date","start_time","end_date","end_time","precinct","report_date","code1","desc","code2","desc2","success","level","borough","loc","loc_type","jur","jur_code","park","hdev","dev_code","x_loc","y_loc","s_age","s_race","s_sex","transit_district","latitude","longitude","lat_lon","patrol_burough","station_name","v_age","v_race","v_sex")

historydf<-crimedf[,c("start_date","start_time","borough","desc1")]
historydf$year=format(as.Date(historydf$start_date, format="%m/%d/%Y"),"%Y")
historydf$month=format(as.Date(historydf$start_date, format="%m/%d/%Y"),"%B")
historydf$weekdays=format(as.Date(historydf$start_date, format="%m/%d/%Y"),"%A")
historydf$hour=format(as.POSIXct(historydf$start_time, format="%H:%M:%S"), format="%H")

locationdf<-crimedf[,c("desc1","latitude","longitude")]
names(historydf)=c("start_date","time","borough","desc","year","month","weekday","hour","desc1")

historydf=historydf[historydf$year>2005,]


saveData<-function(historydf,by){
  df<-bind_rows(
    historydf %>%
      select(!!as.name(by),desc) %>%
      group_by(!!as.name(by),desc)%>%
      summarize(count=n()),
    historydf %>%
      select(!!as.name(by),desc) %>%
      group_by(!!as.name(by),desc)%>%
      summarize(count=n()) %>%
      summarize(count=sum(count),desc="all"))
  write.csv(df,paste("Crime History/",by,".csv",sep=""),row.names=FALSE)
}

saveData(historydf,"year")
saveData(historydf,"hour")
saveData(historydf,"weekday")
saveData(historydf,"month")

locationdf<-crimedf %>%
  select(desc1,latitude,longitude,start_date) %>%
  filter(format(as.Date(start_date, format="%m/%d/%Y"),"%Y")=="2016") %>%
  select(desc1,latitude,longitude)
write.csv(locationdf,"Location Map/location.csv")

runApp("Crime History")
runApp("Location Map")
rsconnect::setAccountInfo(name=token$name[1],
                          token=token$token[1],
                          secret=token$secret[1])
rsconnect::deployApp("Crime History")
rsconnect::deployApp("location map")
