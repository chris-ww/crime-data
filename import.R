library(shiny)
library(tidyverse)


crimedf<-read.csv("NYDP_crime_data.csv")

names(crimedf)<-c("id","start_date","start_time","end_date","end_time","precinct","report_date","code1","desc1","code2","desc2","success","level","borough","loc","loc_type","jur","jur_code","park","hdev","dev_code","x_loc","y_loc","s_age","s_race","s_sex","transit_district","latitude","longitude","lat_lon","patrol_burough","station_name","v_age","v_race","v_sex")

historydf<-crimedf[,c("start_date","start_time","borough","desc1")]
historydf$year=format(as.Date(historydf$start_date, format="%m/%d/%Y"),"%Y")
write.csv(historydf,"Crime History/history.csv")



historydf<-historydf %>%
  group_by(year,borough,desc1)%>%
  summarize(n()) %>%
  filter(year>2006)

runApp("Crime History")

unique(historydf$year)
