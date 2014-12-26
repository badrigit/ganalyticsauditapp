library(shiny)

shinyUI(
  fluidPage(
    
    titlePanel(title = "Audit Application", windowTitle = "Web Analytics Audit"),
    
    sidebarLayout(
      
      sidebarPanel(
        textInput(inputId = "sitemap", label = "Sitemap URL"),
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
