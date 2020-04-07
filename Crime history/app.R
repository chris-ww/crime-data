library(shiny)
library(ggplot2)
library(janitor)
library(dplyr)

historydf<-read.csv("history.csv")
names(historydf)<-c("x","year","borough","desc","count")
df<-rbind_list(
  historydf %>%
    select(year,borough,desc,count),
  historydf%>%
    group_by(year,desc)%>%
    summarize(count=sum(count),borough="all"))
df<-rbind_list(df,
               df%>%
                 group_by(year,borough)%>%
                 summarize(count=sum(count),desc="all"))

ui <- fluidPage(
  
  # App title ----
  titlePanel("Crimes by year"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Slider for the number of bins ----
      selectInput(inputId = "crime",
                  label = "Crime:",
                  choices=unique(df$desc),
                  selected="all"),
      selectInput(inputId = "borough",
                  label = "Borough:",
                  choices=unique(df$borough),
                  selected="all")
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Histogram ----
      plotOutput(outputId = "distPlot")
      
    )
  )
)
# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  # Histogram of the Old Faithful Geyser Data ----
  # with requested number of bins
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot
  output$distPlot <- renderPlot({
    
    newdf=df[df$desc==input$crime&df$borough==input$borough,]
    
    ggplot(newdf, aes(x=year,y=count)) +
      geom_line()+
      ylim(0,NA)
    
    
  })
  
}
shinyApp(ui = ui, server = server)
