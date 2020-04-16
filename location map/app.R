library(shiny)
library(ggplot2)
library(janitor)
library(dplyr)
library(leaflet)

locdf<-read.csv("location.csv")
locdf<-na.omit(locdf)

ui<-shinyUI(
  fluidPage(
    titlePanel("NYC Crime Locations"),
    sidebarLayout(
      sidebarPanel(
        selectInput(inputId = "crime",
                    label = "crime:",
                    choices=c(levels(unique(locdf$desc1)),"all"),
                    selected="ROBBERY")
      ),
      
      mainPanel(leafletOutput("map"))
    )
  )
)
server<-function (input, output) {
  output$map <- renderLeaflet({
    if(input$crime=="all"){
      mapdf<-locdf
    }
    else{
      mapdf<-locdf %>%
        select(desc1,latitude,longitude)%>%
        filter(desc1==input$crime)
    }
    leaflet(data=mapdf) %>%
      setView(lng = -74, lat = 40.7, zoom = 10) %>%
      addProviderTiles("CartoDB.Positron", options = providerTileOptions(noWrap = TRUE)) %>%
      addMarkers(lat=mapdf$latitude,lng=mapdf$longitude, clusterOptions = markerClusterOptions())
  })
}
shinyApp(ui = ui, server = server)
