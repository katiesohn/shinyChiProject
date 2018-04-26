library(shiny)
library(shinydashboard)

shinyUI(dashboardPage( 
  skin = 'green',
  dashboardHeader(title = "Welcome to the Chi"), 
  dashboardSidebar(
    sidebarUserPanel("Katie Sohn"),
    sidebarMenu(
      menuItem("Heat Map", tabName = "heatmap", icon = icon("map")), 
      menuItem("Data", tabName = "data", icon = icon("database")))
  ), 
  dashboardBody(
    tabItems(
      tabItem(tabName = "data",
              "to be replaced with datatable"),
      
      tabItem(tabName='heatmap',
              h2("Heat Map"),
              #div(class="outer",
              #tags$style(type = "text/css", "html, body {width:100%;height:100%}",
                         #tags$head(tags$script(src="leaflet-heatmap.js")),
                         #includeCSS("style.css")),
                         leafletOutput("heatmap",width = '900',height = '900')
                         
                         # absolutePanel(id = "controls1", class = "panel panel-default", fixed = TRUE, draggable = TRUE, 
                         #               top = 150, left = "auto", right = 15, bottom = "auto",
                         #               width = 200, height = "auto",
                         #               checkboxGroupInput(inputId="type", label=h4("Select Crime Type"), 
                         #                                  choices=choice1, selected='FELONY'),
                         #               
                         #               checkboxGroupInput(inputId="premises", label=h4("Select Location"), 
                         #                                  choices=choice3, selected='RESIDENCE')
                         #               #sliderInput(inputId = "year7", label = h4("Select Year"), min=2012, max=2017, step =1,
                         #               #sep='', value = thechisample$Year)))
                         ))
      )
    ))
# )




