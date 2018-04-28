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
    thechisamp %>%
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
                      size=120)
  })
  
  reactmap=reactive({
    thechisamp %>% 
      filter(charge %in% input$type1 &
               desc_classifier %in% input$premises1
               & Year >= input$year2[1] &
               Year <= input$year2[2])
  })
 
  ################## DRAWS INITIAL REGULAR MAP #######################
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
    datatable(thechisamp, rownames=FALSE) %>% 
      formatStyle(input$selected,  #this is the only place that requires input from the UI. so
                  #here we are highlighting only the column that the user selected 
                  background="skyblue", fontWeight='bold')
    # Highlight selected column using formatStyle
  })
  
  
  ######## Test #######
  # output$finalTest =  renderHighchart({
  #   highchart() %>% 
  #     hc_title(text = "Scatter chart with size and color") %>% 
  #     hc_add_series_scatter(mtcars$wt, mtcars$mpg,
  #                           mtcars$drat, mtcars$hp)
  # })
  ######## End of Test #######
  
  
  
  ################## CREATING TIMESERIES #######################
  #arrest by date time series 
  #thechisamp$date_alone=as.POSIXct(thechisamp$date_alone, format = "%Y-%m-%d")
  #Arrests_by_Date <- na.omit(thechisamp[thechisamp$arrest == 'TRUE',]) %>% group_by(date_alone) %>% summarise(Total = n())
  Arrests_by_Date <- na.omit(thechisamp[thechisamp$arrest == 'TRUE',]) %>% group_by(date) %>% summarise(Total = n())
  arrests_tseries <- xts(Arrests_by_Date$Total, order.by=as.POSIXct(Arrests_by_Date$date))
  
  output$hcontainer <-renderHighchart({
  
    y = arrests_tseries
    
    highchart(type="stock") %>%
      hc_exporting(enabled = TRUE) %>%
      hc_xAxis(anydate(arrests_tseries, tz="America/Chicago")) %>%
      hc_title(text = "Arrest by Day (2012 - 2017)",
               margin = 20, align = "center") %>%
      hc_add_series(y, name = "Arrests", id="T1", smoothed = TRUE, forced = TRUE,
                         groupPixelWidth = 24) %>%
      hc_rangeSelector(buttons = list(
        list(type = 'all', text = 'All'),
        list(type = 'month', count = 12, text = '1Y'),
        list(type = 'month', count = 6, text = '6M'),
        list(type = 'month', count = 3, text = '3M'),
        list(type = 'day', count = 30, text = '1M'),
        list(type = 'day', count = 7, text = '1 Week')
      )) %>%
    
      #https://github.com/jbkunst/highcharter/issues/293 <-- themes
      hc_add_theme(hc_theme_538(colors = c("red", "white", "blue"),
                                chart = list(backgroundColor = "white")))
    
  })
  
  by_Date <- na.omit(thechisamp) %>% group_by(date) %>% summarise(Total = n())
  tseries <- xts(by_Date$Total, order.by=as.POSIXct(by_Date$date))
  
  output$hcontainer2 <-renderHighchart({
    
    z = tseries
    
    highchart(type="stock") %>%
      hc_exporting(enabled = TRUE) %>%
      hc_add_series(z, name = "Number of Crimes by Day", smoothed = TRUE, forced = TRUE,
                    groupPixelWidth = 24) %>%
      hc_title(text = "Total Crimes by Day (2012-2017)",
               margin = 20, align = "center") %>%
      hc_add_theme(hc_theme_538(colors = c("red", "white", "blue"),
                                  chart = list(backgroundColor = "white"))) %>%
      hc_rangeSelector(buttons = list(
        list(type = 'all', text = 'All'),
        list(type = 'month', count = 12, text = '1Y'),
        list(type = 'month', count = 6, text = '6M'),
        list(type = 'month', count = 3, text = '3M'),
        list(type = 'day', count = 30, text = '1M'),
        list(type = 'day', count = 7, text = '1 Week')
      )) #%>%
      
  })
  
})

