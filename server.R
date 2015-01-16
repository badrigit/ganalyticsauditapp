library(shiny)
library(XML)
library(RSelenium)
library(httr)
library(RCurl)
library(googleVis)

shinyServer(function(input, output, session) {
  
  source("www/global.R") # Read global functions
  
  # Get sitemap URL or file
  dataInput <- reactive({
    if (input$sitemap != "") 
    {
      sitemap <- input$sitemap # Get URL for sitemap
    }
    else{
      inFile <- input$file # Get sitemap xml file otherwise
      if (is.null(inFile))
        return(NULL)
      sitemap <- inFile$datapath
    }
  })
  
  # Network log datacut
  outputData <- reactive({
    if(input$submit == 0)
      return()
    isolate({
      urls <- getSitemapUrls(dataInput())
      getNetworkLog(urls) # Get network log by connecting to phantomjs
      data <- read.table(file = "/usr/share/iauditOutput/output.txt", 
                         sep = ",", row.names = NULL) # Read network log text file
      output <- processNetWorkLog(data) # Process log file
      unlink("/usr/share/iauditOutput/output.txt") # Delete log text file
      output
    })
  })
  
  # Summary of network log in user readble format
  output$dashboardOutput <- renderGvis({
    if(input$submit == 0) # waits for submit button click
      return()
    isolate({
      dashboardData <- getDashboard(outputData())
      
      # Build visualisation for dasboard
      gvisBarChart(data = dashboardData, options = list(
        legend="bottom",
        title="Overview of tags fired"
      ))
    })
  })
  
  # Analytics granular 
  output$analyticsOuput <- renderDataTable({
    if(input$submit == 0)
      return()
    isolate({
      output <- getAnalyticsData(outputData())
    })
  })
  
  output$gtmOuput <- renderDataTable({
    if(input$submit == 0)
      return()
    isolate({
      output <- getGTMData(outputData())
    })
  })
})