# title: "SWFWMD Water Quality App"
# author: "Thomas LaRoue"
# date: "2016-06-08"


##load required packages

library(shiny)

DataPull <- read.csv("T:/Swm/Users/T_LaRoue/R Projects/DataPull.csv")
listStations <- split(DataPull, DataPull$STATION_ID)



## UI CODE
Available.Stations <- as.list(unique(as.character(DataPull$STATION_NAME)))

ui <- fluidPage(
  title = "TJ <3's Nathan",
  headerPanel("Download Station Information"),
  sidebarPanel(
    selectInput(inputId = "Stations.Selected",                         
                label="Available Stations",                          
                choices=Available.Stations,                          
                multiple=TRUE,
                selectize=TRUE
                )
    ),
    downloadButton("downloadData","Download"),
  mainPanel(tableOutput("DLtable"))
)

###############################################################################################################
##SERVER CODE

server <- (function(input, output) {
  Download.Stations.Selected <- reactive(input$Stations.Selected)
  output$DLtable <- renderTable(DataPull[DataPull$STATION_NAME == input$Stations.Selected,])
  output$downloadData <- downloadHandler(
    filename = function() {paste("WQData", Sys.Date(), ".csv", sep = " ")},
    content=function(file) {
      write.csv(DataPull[DataPull$STATION_NAME == input$Stations.Selected,], file)
    }
  )
})



shinyApp(ui = ui, server = server)
