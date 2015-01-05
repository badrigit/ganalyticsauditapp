library(shiny)
library(XML)
library(RSelenium)
library(httr)
library(RCurl)
library(googleVis)

shinyServer(function(input, output, session) {
  
  source("www/global.R")
  
  # Get sitemap URL or file
  dataInput <- reactive({
    if (input$sitemap != "") 
    {
      sitemap <- input$sitemap # Get the URL for sitemap
    }
    else{
      inFile <- input$file
      if (is.null(inFile))
        return(NULL)
      sitemap <- inFile$datapath
    }
  })
  
  outputData <- reactive({
    if(input$submit == 0)
      return()
    isolate({
      urls <- getSitemapUrls(dataInput())
      getNetworkLog(urls)
      data <- read.table(file = "output.txt", sep = ",", row.names = NULL)
      'output <- data.frame(Url = character(0), 
                           Type = character(0), 
                           Property = character(0),
                           stringsAsFactors=FALSE)
      
      for(i in 1:nrow(analytics)){
        output[i,] <- getAnalyticsUrlParam(analytics[i,])
      }'
      
      output <- processNetWorkLog(data)
      unlink("output.txt")
      output
    })
  })
  
  output$dashboardOutput <- renderGvis({
    if(input$submit == 0)
      return()
    isolate({
      dashboardData <- getDashboard(outputData())
      gvisBarChart(data = dashboardData, options = list(
        legend="bottom",
        title="Overview of tags fired"
      ))
    })
  })
  
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