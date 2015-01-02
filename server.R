library(shiny)
library(XML)
library(RSelenium)
library(httr)
library(RCurl)

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
  
  output$urlsTable <- renderDataTable({
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
      data.frame(output)
    })
  })

})