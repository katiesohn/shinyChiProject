library(shiny)
library(shinydashboard)

shinyUI(dashboardPage(skin="black", 
    
  dashboardHeader(title = "Welcome to the Chi"), 
  dashboardSidebar(
    sidebarUserPanel("Katie Sohn"),
    sidebarMenu(
      menuItem("Heat Map", tabName = "heatmap", icon = icon("fire-extinguisher")),
      menuItem("Map",tabName = "map",icon = icon("map-pin")),
      menuItem("Time", tabName = "timeseries", icon = icon("hourglass"),
               menuSubItem("Arrests and Crimes", tabName= "arrestsandcrimes"),
               menuSubItem("Crime Types By Year", tabName="crimetypesyear"),
               menuSubItem("Crimes & Locations By Hour", tabName="crimelocations"),
               menuSubItem("Crime Rates By Year", tabName="crimeratesyear")),
      menuItem("Data", tabName = "data", icon = icon("database")))
  ), 
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "style.css")),
    
    tabItems(
      tabItem(tabName = 'arrestsandcrimes',
              fluidRow((highchartOutput('hcontainer'))),
              fluidRow((highchartOutput('hcontainer2')))),
      
      
      tabItem(tabName = 'crimetypesyear',
              selectInput(inputId='crimetype', label=h3('Crime Type'), choices = choice4,
                          selected = 'HOMICIDE'),
              plotlyOutput('crimetypesyear', height = "auto", width ="auto")),
      
      tabItem(tabName = 'crimeratesyear',
              selectInput(inputId='crimetype3', label=h3('Crime Rates'), choices = choice4,
                          selected = 'HOMICIDE'),
              plotlyOutput('crimeratesyear', height = "auto", width ="auto")),
      
      tabItem(tabName = 'crimelocations',
              fluidRow(
                column(3, 
                       selectInput(inputId='location_type', label=h3('Select Locations'), choices = choice3,
                                   selected = 'RESIDENCE')),
                
                column(9,
                       h3(''),
                       plotlyOutput(outputId = "reactbargraphlocationsbyhour", 
                                    height="auto", width ="auto"))),
              
              fluidRow(
                column(3, 
                        selectInput(inputId='crime_type2', label=h3('Select Crime'), choices = choice4,
                            selected = 'HOMICIDE')),
                column(9,
                       h3(''),
                       plotlyOutput(outputId = "reactareacrimesbyhour", 
                                    height="auto", width ="auto")))
              ),
              
      
      tabItem(tabName = "data",
              # datatable
              fluidRow(box(DT::dataTableOutput("table"), width = 12))), 
      #changing width to 12 makes it take up whole page )
      
      tabItem(tabName='heatmap',
              div(class="outer",
              tags$head(
                tags$style(type = "text/css", "#heatmap {height: calc(100vh - 80px) !important;}"
              ))),
              
                         leafletOutput("heatmap",width = '100%',height = '100%'),
                                      
                                       div(class="outer"), 
                         absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = TRUE,
                                       top = 150, left = "auto", right = 15, bottom = "auto",
                                       width = 200, height = "auto",
                                       
                                       
                                       checkboxGroupInput(inputId="type", label=h4("Select Crime Type"),
                                                   choices=choice1, selected='FELONY'),

                                       checkboxGroupInput(inputId="premises", label=h4("Select Location"),
                                                          choices=choice3, selected='RESIDENCE'),
                                
                                        sliderInput(inputId = "year2", label = h4("Select Year"), min=2012, max=2016, step =1,
                                        sep='', value = c(2012,2016)))),
      
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
                                                   choices = choice3, selected = 'RESIDENCE'),
                                      sliderInput(inputId = "year6", label = h4("Select Year"), min=2012, max=2016, step =1,
                                                   sep='', value = c(2012,2016)))
                                      
)))))




