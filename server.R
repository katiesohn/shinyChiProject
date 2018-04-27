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
    thechisample %>%
      filter(charge %in% input$type &
               desc_classifier %in% input$premises)
              # year >= input$year7[1] &
               #year <= input$year7[2])

  })

    ################## DRAWS INITIAL MAP #######################    
  output$heatmap=renderLeaflet({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically (at least, not unless the
    # entire map is being torn down and recreated).
    leaflet() %>% 
      addProviderTiles(providers$CartoDB.DarkMatter) %>% 
      setView(-87.6105, 41.8947,zoom=11)
  })
  observe({
    proxy=leafletProxy("heatmap", data =reactheatmap) %>%
      removeWebGLHeatmap(layerId='a') %>%
      addWebGLHeatmap(layerId='a',data=reactheatmap(),
                      lng=~longitude, lat=~latitude,
                      size=300)
  })
  
  reactmap=reactive({
    thechi %>% 
      filter(charge %in% input$type1 &
               desc_classifier %in% input$premises1)
               #& Year >= input$year6[1] &
               #Year <= input$year6[2])
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
  
  
 })

