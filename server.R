library(shiny)
library(XML)
library(RSelenium)
library(httr)

shinyServer(function(input, output, session) {
  
  source("www/global.R")
  
  output$urlsTable <- renderDataTable({
    if(input$submit == 0)
      return()
    isolate({
      urls <- getSitemapUrls(input$sitemap)
      getNetworkLog(urls)
      analytics <- read.table(file = "output.txt", col.names = c("url"))
      output <- data.frame(Url = character(0), 
                           Type = character(0), 
                           Property = character(0),
                           stringsAsFactors=FALSE)
      for(i in 1:nrow(analytics)){
        output[i,] <- getAnalyticsUrlParam(analytics[i,])
      }
      unlink("output.txt")
      output
    })
  })

})