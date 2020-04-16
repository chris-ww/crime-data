library(shiny)
library(ggplot2)
library(janitor)
library(dplyr)
library(tidyverse)



hour=read.csv("hour.csv")
year=read.csv("year.csv")
month=read.csv("month.csv")
weekday=read.csv("weekday.csv")

levels(weekday$weekday)=c("monday","tuesday","wednesday","thursday","friday","saturday","sunday")
levels(month$month)=c("January","February","March","April","May","June","July","August","September","October","November","December")
levels(hour$hour)=seq(0,24,by=1)
year=year[year$year<=2016,]
levels(year$year)=seq(2006,2016,by=1)



ui <- fluidPage(
  titlePanel("Crimes in New York City"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "time",
                  label = "Sort By TimeFrame:",
                  choices=c("year","month","weekday","hour"),
                  selected="hour"),
      selectInput(inputId = "crime",
                  label = "crime:",
                  choices=unique(year$desc),
                  selected="all")
    ),
    
    mainPanel(
      plotOutput(outputId = "distPlot")
      
    )
  )
)
server <- function(input, output) {
  output$distPlot <- renderPlot({
    time=input$time
    df=get(paste(time))
    df=na.omit(df[df$desc==input$crime,])
    ggplot(df, aes(x=as.factor(get(paste(time))),y=count)) +
      geom_bar(stat="identity")+
      ylim(0,NA)+
      xlab(paste(time))
  })
  
}

shinyApp(ui = ui, server = server)
