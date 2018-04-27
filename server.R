#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#



# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

    reactheatmap=reactive({
    thechi %>%
      filter(charge %in% input$type &
               desc_classifier %in% input$premises &
               year >= input$year2[1] &
               year <= input$year2[2])

  })

    ################## DRAWS INITIAL HEATMAP #######################    
  output$heatmap=renderLeaflet({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically (at least, not unless the
    # entire map is being torn down and recreated).
    leaflet() %>% 
      addProviderTiles(providers$CartoDB.DarkMatter) %>% 
      setView(-87.6105, 41.8947,zoom=11)
  })
  observe({
    proxy=leafletProxy("heatmap", data = reactheatmap) %>%
      removeWebGLHeatmap(layerId='a') %>%
      addWebGLHeatmap(layerId='a',data=reactheatmap(),
                      lng=~longitude, lat=~latitude,
                      size=300)
  })
  
  reactmap=reactive({
    thechi %>% 
      filter(charge %in% input$type1 &
               desc_classifier %in% input$premises1
               & Year >= input$year2[1] &
               Year <= input$year2[2])
  })
 
  ################## DRAWS INITIAL MAP #######################
   output$map=renderLeaflet({
    leaflet() %>% 
      addProviderTiles(providers$Esri.WorldStreetMap) %>% 
      setView(-87.6105, 41.8947,zoom=11)
  })
  observe({
    proxy=leafletProxy("map", data=reactmap()) %>% 
      #clearMarkers() %>% 
      #clearMarkerClusters() %>%
      addCircleMarkers(clusterOptions=markerClusterOptions(), 
                       lng=~longitude, lat=~latitude,radius=5, group='Cluster',
                       popup=~paste('<b><font color="Black">','Crime Information','</font></b><br/>',
                                    'Crime Type:', primary_type,'<br/>',
                                    'Date:', date_alone,'<br/>',
                                    #'Time:', Time,'<br/v',
                                    'Arrest:', arrest, '<br/>',
                                    'Location:', desc_classifier,'<br/>')) 

  })
  
  ################## DATA TABLE #######################
  output$table <- DT::renderDataTable({
    datatable(thechi, rownames=FALSE) %>% 
      formatStyle(input$selected,  #this is the only place that requires input from the UI. so
                  #here we are highlighting only the column that the user selected 
                  background="skyblue", fontWeight='bold')
    # Highlight selected column using formatStyle
  })
  
  ################## CREATING TIMESERIES #######################
  # Arrests_by_Date <- na.omit(thechi[thechi$arrest == 'TRUE',]) %>% group_by(date_alone) %>% summarise(Total = n())
  # arrests_tseries <- xts(Arrests_by_Date$Total, order.by=as.POSIXct(Arrests_by_Date$date_alone))
  # 
  # output$hcontainer <-renderHighchart({
  
    #y = arrests_tseries
    
    # highchart() %>% 
    #   hc_title(text = "Scatter chart with size and color") %>% 
    #   hc_add_series_scatter(mtcars$wt, mtcars$mpg,
    #                         mtcars$drat, mtcars$hp)
    # 
    
    # highchart() %>%
    #   hc_exporting(enabled = TRUE) %>%
    #   hc_add_series(data=arrests_tseries) %>%
    #   
      
                         #yAxis = 0, name = "Sample Data", smoothed = TRUE, forced = TRUE,
                         #groupPixelWidth = 24) %>%
      # hc_rangeSelector(buttons = list(
      #   list(type = 'all', text = 'All'),
      #   list(type = 'hour', count = 2, text = '2h'),
      #   list(type = 'month', count = 1, text = '1h'),
      #   list(type = 'minute', count = 30, text = '30m'),
      #   list(type = 'minute', count = 10, text = '10m'),
      #   list(type = 'minute', count = 5, text = '5m')
      #)) %>%
    
    
      # hc_add_theme(hc_theme_538(colors = c("red", "blue", "green"),
      #                           chart = list(backgroundColor = "white")))
    
  
  })
    
 # })

