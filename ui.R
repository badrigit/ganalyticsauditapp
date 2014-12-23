library(shiny)

shinyUI(
  fluidPage(
    
    titlePanel(title = "Audit Application", windowTitle = "Web Analytics Automated Audit Tool"),
    
    sidebarLayout(
      
      sidebarPanel(
        textInput(inputId = "sitemap", label = "Sitemap URL"),
        br(),
        actionButton(inputId = "submit", label = "Submit")
      ),
      
      mainPanel(
        tabsetPanel(
          id = "tab",
          tabPanel("Preview", tableOutput(outputId = "urlsTable"))
        )
      )
    )
  )
)
