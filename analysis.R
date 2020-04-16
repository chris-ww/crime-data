library(shiny)
library(tidyverse)
library(rsconnect)
library(lubridate)

#https://data.cityofnewyork.us/Public-Safety/NYPD-Complaint-Data-Historic/qgea-i56i
crimedf<-read.csv("NYDP_crime_data.csv")
token<-read.csv("")
names(crimedf)<-c("id","start_date","start_time","end_date","end_time","precinct","report_date","code1","desc","code2","desc2","success","level","borough","loc","loc_type","jur","jur_code","park","hdev","dev_code","x_loc","y_loc","s_age","s_race","s_sex","transit_district","latitude","longitude","lat_lon","patrol_burough","station_name","v_age","v_race","v_sex")

historydf<-crimedf[,c("start_date","start_time","borough","desc1")]
historydf$year=format(as.Date(historydf$start_date, format="%m/%d/%Y"),"%Y")
historydf$month=format(as.Date(historydf$start_date, format="%m/%d/%Y"),"%B")
historydf$weekdays=format(as.Date(historydf$start_date, format="%m/%d/%Y"),"%A")
historydf$hour=format(as.POSIXct(historydf$start_time, format="%H:%M:%S"), format="%H")

summary(crimedf)
