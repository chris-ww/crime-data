library(shiny)

historydf<-read.csv("history.csv")


df<-historydf %>%
  group_by(year,desc1) %>%
  summarize(sum(n..))%>%
  select(year,desc1,'sum(n..)')

names(df)<-c("year","desc","count")

ui <- fluidPage(
  
  # App title ----
  titlePanel("Crimes by year"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Slider for the number of bins ----
      selectInput(inputId = "crime",
                  label = "Crime:",choices=unique(df$desc),selected="BURGLARY")
      
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
    newdf=df[df$desc==input$crime,]
    print(newdf)
    plot(newdf$year,newdf$count, main="number of crimes per year",xlab="year",ylab="count",xlim=c(2006,2017),type="l")
    
  })
  
}
shinyApp(ui = ui, server = server)

