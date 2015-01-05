library(compiler)
library(data.table)

# Parse XML from URL
getSitemapUrls <- cmpfun(function(sitemapURL){
  sitemap <- htmlTreeParse(sitemapURL, useInternalNodes = T)
  urls <- data.frame(URL=xpathSApply(sitemap, "//url/loc", xmlValue))
  return(urls)
})

# Parse XML from file
getSitemapUrlsFromFile <- cmpfun(function(sitemap){
  urls <- xmlToDataFrame(doc = sitemap)[-1,] # Skipped first row, may skip first Url
  urls <- data.frame(URL=urls[,"loc"])
  return(urls)
})

# Get Analytics URL parameters
getAnalyticsUrlParam <- cmpfun(function(analyticsUrl){
  parseUrl <- parse_url(analyticsUrl)
  params <- cbind(parseUrl$query$dl, parseUrl$query$t, parseUrl$query$tid)
  return(params)
})

# Process Network Log
processNetWorkLog <- function(data){
  data <- data[,-ncol(data)] # Remove last column
  colnames(data) <- c("Page", "NetLog")
  dt <- data.table(data)
  return(data)
}

# Get network log for each url
getNetworkLog <- cmpfun(function(urls){
  withProgress(message = paste("Total Number of URLs: ",nrow(urls),sep = ""),
               min = 1, 
               max = nrow(urls), expr = for(i in 1:nrow(urls)){
    pJS <- phantom()
    Sys.sleep(2) # give the binary a moment
    remDr <- remoteDriver(browserName = "phantom")
    remDr$open()
    result <- remDr$phantomExecute("var page = this;
                                     var fs = require('fs');
                                     page.onResourceRequested = function (req) {
                                     if (req.url.indexOf('analytics.com/collect?') > -1 ||
                                     req.url.indexOf('analytics.com/r/collect?') > -1 ||
                                     req.url.indexOf('utm.gif?') > -1 || 
                                     req.url.indexOf('googletagmanager.com') > -1) {
                                     var collect = req.url;
                                     console.log(collect);
                                     console.log(page.url);

                                     var content = [
                                        page.url,
                                        collect,
                                        '\\n'
                                     ];
                                     
                                     try{
                                     fs.write('output.txt',content.join(','),'a',function(err){
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
      
    incProgress(amount = 1/nrow(urls), message = paste("Remaining Urls: ", nrow(urls) - i, sep=""))
    pJS$stop()
  }
  )
})

# Get total tag manager
getGTMCount <- function(data){
  totalUrls <- length(unique(data[,"Page"]))
  totalGTM <- nrow(subset(data, grepl("googletagmanager.com", NetLog)))
  totalPageviews <- nrow(subset(data, grepl("t=pageview.*tid=UA-", NetLog)))
  gtmCount <- data.table(Category=c("# of Urls","# of GTM", "# of Pageviews"), Count=c(totalUrls,totalGTM,totalPageviews))
  return(gtmCount)
}