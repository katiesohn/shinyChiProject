library(shiny)
library(shinydashboard)

shinyUI(dashboardPage(skin="black", 
    
  dashboardHeader(title = "Welcome to the Chi"), 
  dashboardSidebar(
    sidebarUserPanel("Katie Sohn"),
    sidebarMenu(
      menuItem("Overview", tabName = "overview", icon = icon("gem"),
               menuSubItem("Crime Types By Year", tabName="crimetypesyear"),
               menuSubItem("Crime Locations", tabName="crimelocations")),
      menuItem("Heat Map", tabName = "heatmap", icon = icon("fire-extinguisher")),
      menuItem("Map",tabName = "map",icon = icon("map-pin")),
      menuItem("Time Series", tabName = "timeseries", icon = icon("hourglass"),
               menuSubItem("Arrests Over Time", tabName= "arrests"),
               menuSubItem("Crimes Over Time", tabName="crimes")),
      menuItem("Data", tabName = "data", icon = icon("database")))
  ), 
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "style.css")),
    
    tabItems(
      tabItem(tabName = 'arrests',
              fluidRow((highchartOutput('hcontainer')))),
      
      tabItem(tabName = 'crimes',
              fluidRow((highchartOutput('hcontainer2')))),
      
      tabItem(tabName = 'crimetypesyear',
              selectInput(inputId='crimetype', label=h3('Crime Type'), choices = choice4,
                          selected = 'HOMICIDE'),
              plotlyOutput('crimetypesyear', height = "auto", width ="auto")),
              # fluidRow((highchartOutput('crimetypesyear')))),
      
      tabItem(tabName = 'crimelocations',
              fluidRow(
                column(3, checkboxGroupInput(inputId='location_type',
                          label = h4("Select Locations"),choices = choice3)
                ),
                
                column(9,
                       h3(''),
                       plotlyOutput(outputId = "reactbargraphlocationsbyhour", 
                                    height="auto", width ="auto"))
              )),
              
              
              # selectInput(inputId='location_type', label=h3('Locations'), choices = choice3,
              #             selected = 'STREET'),
              # plotlyOutput('locations', height = "auto", width ="auto")),
      
      tabItem(tabName = "data",
              # datatable
              fluidRow(box(DT::dataTableOutput("table"), width = 12))), 
      #changing width to 12 makes it take up whole page )
      
      tabItem(tabName='heatmap',
              div(class="outer",
              tags$head(
                tags$style(type = "text/css", "#heatmap {height: calc(100vh - 80px) !important;}")
              
              )),
              
                         leafletOutput("heatmap",width = '100%',height = '100%'),
                                      
                                       div(class="outer"), 
                         absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = TRUE,
                                       top = 150, left = "auto", right = 15, bottom = "auto",
                                       width = 200, height = "auto",
                                       
                                       
                                       checkboxGroupInput(inputId="type", label=h4("Select Crime Type"),
                                                   choices=choice1, selected='FELONY'),
                                       #kept line below in case i'd rather do a drop down
                                       #selectInput(inputId="type", label = h3("Select Crime Type"), 
                                                   #choices = choice1, selected = 'FELONY')

                                       checkboxGroupInput(inputId="premises", label=h4("Select Location"),
                                                          choices=choice3, selected='RESIDENCE'))),
                                
                                       # sliderInput(inputId = "year2", label = h4("Select Year"), min=2012, max=2017, step =1,
                                       # sep='', value = thechisamp$year)),
                                       # style = "opacity: 0.92"),
      
      tabItem(tabName='map',
              div(class="outer",
                  tags$head(
                    tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}")
                  )),
                        leafletOutput("map",width = '100%',height = '100%'),
                        
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = TRUE, 
                                      top = 150, left = "auto", right = 15, bottom = "auto",
                                      width = 200, height = "auto",
                                      checkboxGroupInput(inputId = "type1", label = h4("Select Crime Type"), 
                                                   choices = choice1, selected = 'FELONY'),
                                      checkboxGroupInput(inputId = "premises1", label = h4("Select Premises"), 
                                                   choices = choice3, selected = 'RESIDENCE')
                                      #sliderInput(inputId = "year6", label = h4("Select Year"), min=2006, max=2016, step =1,
                                                  #sep='', value = c(2012, 2016)))
                                      ))
))))




