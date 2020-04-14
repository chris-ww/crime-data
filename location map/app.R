library(shiny)
library(ggplot2)
library(janitor)
library(dplyr)
library(leaflet)

historydf<-read.csv("history.csv")
shinyServer(function (input, output) {
  output$map <- renderLeaflet({leaflet(crime) %>%
      setView(lng = -73.98928, lat = 40.75042, zoom = 10) %>%
      addProviderTiles("CartoDB.Positron", options = providerTileOptions(noWrap = TRUE))})
  
})
#crime <- read.csv("crime.csv", header=TRUE, stringsAsFactors=FALSE)
shinyUI(
  # Use a fluid Bootstrap layout
  fluidPage(
    # Give the page a title
    titlePanel("NYC Crime Statistics"),
    mainPanel(leafletOutput("map"))
  )
)
shinyServer(function (input, output) {
  output$map <- renderLeaflet({
    leaflet() %>%
      setView(lng = -73.98928, lat = 40.75042, zoom = 10) %>%
      addProviderTiles("CartoDB.Positron", options = providerTileOptions(noWrap = TRUE))
  })
})
shinyApp(ui = shinyUI, server = shinyServer)