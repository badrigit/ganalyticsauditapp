library(shinydashboard)

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Analytics Audit Tool", tabName = "analyticsAudit", icon = icon("cog")),
    menuItem("Help", tabName = "help", icon = icon("th"),badgeLabel= "new", badgeColor = "green")
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "analyticsAudit",
            fluidRow(
              box(
                title = "Input Section",
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
                actionButton(inputId = "submit", label = "Submit")),
              box(
                tabsetPanel(
                  id = "tab",
                  tabPanel("Dashboard",htmlOutput(outputId = "dashboardOutput")),
                  tabPanel("Google Tag Manager",dataTableOutput(outputId = "gtmOuput")),
                  tabPanel("Google Analytics",dataTableOutput(outputId = "analyticsOuput"))
                )
              )
            )
    ),
    tabItem(tabName = "help", h2("Help Section"))
  )
)

ui <- dashboardPage(skin = "blue",
                    dashboardHeader(title = "Analytics Audit"),
                    sidebar,
                    body
)