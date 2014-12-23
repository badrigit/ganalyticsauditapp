library(shiny)
library(XML)
library(RSelenium)

shinyServer(function(input, output) {
  
  #input <- "http://www.scottishpower.co.uk/sitemap.xml"
  
  # Parse XML file
  getSitemapUrls <- function(sitemapURL){
     sitemap <- htmlTreeParse(sitemapURL, useInternalNodes = T)
     urls <- data.frame(URL=xpathSApply(sitemap, "//url/loc", xmlValue))
     return(urls)
  }
  
  # Get network log for each url
  getNetworkLog <- function(urls){
    pJS <- phantom()
    Sys.sleep(5) # give the binary a moment
    remDr <- remoteDriver(browserName = "phantom")
    remDr$open()
    result <- remDr$phantomExecute("var page = this;
                                    page.onResourceRequested = function (req) {
                                      if (req.url.indexOf('collect?') > -1) {
                                        var collect = req.url;
                                        console.log(collect);
                                      }
                                    }
                                  ")
    for(i in 1:nrow(urls)){
      remDr$navigate(urls[i,1])
      Sys.sleep(5)
    }
    pJS$stop()
  }
  
  output$urlsTable <- renderTable({
    if(input$submit == 0)
      return()
    isolate({
      output <- getSitemapUrls(input$sitemap)
      getNetworkLog(output)
      output
    })
  })

})