library(shiny)

shinyUI(
  fluidPage(
    
    titlePanel(title = "Audit Application", windowTitle = "Web Analytics Audit"),
    
    sidebarLayout(
      
      sidebarPanel(
        radioButtons(inputId = "inputType",
                     label = "InputType", 
                     choices = c("Sitemap URL" = "sitemapURL", "File Upload" = "fileUpload")),
        conditionalPanel(
          condition = "input.inputType == 'sitemapURL'",
          textInput(inputId = "sitemap", label = "Sitemap URL")
        ),
        conditionalPanel(
          condition = "input.inputType == 'fileUpload'",
          fileInput('file', 'Choose file to upload',
                    accept = c(
                      'text/csv',
                      'text/comma-separated-values',
                      'text/tab-separated-values',
                      'text/plain',
                      '.csv',
                      '.xml'
                    )
          )
        ),
        br(),
        actionButton(inputId = "submit", label = "Submit")
      ),
      
      mainPanel(
        tabsetPanel(
          id = "tab",
          tabPanel("Preview", dataTableOutput(outputId = "urlsTable"))
        )
      )
    )
  )
)
