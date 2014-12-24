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
    for(i in 1:nrow(urls)){
      pJS <- phantom()
      Sys.sleep(5) # give the binary a moment
      remDr <- remoteDriver(browserName = "phantom")
      remDr$open()
      result <- remDr$phantomExecute("var page = this;
                                      var fs = require('fs');
                                      page.onResourceRequested = function (req) {
                                        if (req.url.indexOf('analytics.com/collect?') > -1) {
                                          var collect = req.url;
                                          console.log(collect);

                                          try{
                                            fs.write('output.txt',collect+'\\n','a',function(err){
                                              if(err) {
                                                console.log(err);
                                              } else {
                                                  console.log('The file was saved!');
                                              }
                                            });
                                          } catch(e){
                                            console.log(e);
                                          }
                                        }
                                      }
                                    ")
      remDr$navigate(urls[i,1])
      pJS$stop()
    }
  }
  
  output$urlsTable <- renderTable({
    if(input$submit == 0)
      return()
    isolate({
      output <- getSitemapUrls(input$sitemap)
      getNetworkLog(output)
      analytics <- read.table(file = "output.txt", col.names = c("url"))
      unlink("output.txt")
      analytics
    })
  })

})