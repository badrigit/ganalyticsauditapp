library(shiny)
library(XML)

shinyServer(function(input, output) {
  
  #input <- "http://www.scottishpower.co.uk/sitemap.xml"
  
  # Function to parse XML file
  getSitemapUrls <- function(sitemapURL){
     sitemap <- htmlTreeParse(sitemapURL, useInternalNodes = T)
     urls <- data.frame(URL=xpathSApply(sitemap, "//url/loc", xmlValue))
     return(urls)
  }
  
  output$urlsTable <- renderTable({
    if(input$submit == 0)
      return()
    isolate({output <- getSitemapUrls(input$sitemap)})
  })

})
