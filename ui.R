library(shiny)

shinyUI(
  fluidPage(
    
    titlePanel(title = "Audit Application", windowTitle = "Web Analytics Automated Audit Tool"),
    
    sidebarLayout(
      
      sidebarPanel(
        textInput(inputId = "sitemap", label = "Sitemap URL"),
        submitButton(text = "Submit")
      ),
      
      mainPanel(
      )
    
      )
  )
)
