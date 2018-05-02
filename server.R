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

  ################## DRAW BAR GRAPH FOR CRIME RATES BY YEAR #######################    
  
  observeEvent(
    eventExpr = input[["crimetype"]],
    handlerExpr = {

      reactbargraph2 =  thechi1416[thechi1416$primary_type == input$crimetype3,] %>%
        group_by(year) %>%
        summarise(Crimerate=(n()/chicagopop)*100000)

      output$crimeratesyear = renderPlotly({

        f2 <- list(
          family = "Helvetica Neue', Helvetica",
          size = 14,
          color = "black")

        p <- plot_ly(data=reactbargraph2, x = ~year, y = ~Crimerate, type = 'bar', width =0.1,
                     marker = list(color = 'rgb(23, 190, 207)',
                                   line = list(color = 'transparent')),
                     add_text = list(text= ~Crimerate, textposition="top center")) %>%
          layout(title = "Crime Rates by Year",
                 titlefont = f2,
                 xaxis = list(title = "Years"),
                 yaxis = list(title = "Rates"),
                 plot_bgcolor = "#FFFFFF",
                 paper_bgcolor='#FFFFFF',
                 height=400,
                 width=650,
                 bargap = 0.7)

      })
    })

  
  ################## DRAW AREA GRAPH FOR CRIME TYPES BY YEAR #######################    
  
  
  observeEvent(
    eventExpr = input[["crimetype"]],
    handlerExpr = {
    
    reactbargraph =  thechi1416[thechi1416$primary_type == input$crimetype,] %>%
        group_by(year) %>%
        summarise(Total = n())
  
    output$crimetypesyear = renderPlotly({
      
      f2 <- list(
        family = "Helvetica Neue', Helvetica",
        size = 14,
        color = "black")
      
      p <- plot_ly(data=reactbargraph, x = ~year, y = ~Total, type = 'bar', width =0.1,
                   marker = list(color = 'rgb(23, 190, 207)',
                                 line = list(color = 'transparent'))) %>%
        layout(title = "Crime Types by Year",
               titlefont = f2,
               xaxis = list(title = "Years"),
               yaxis = list(title = "Totals"),
               plot_bgcolor = "#FFFFFF",
               paper_bgcolor='#FFFFFF',
               height=400,
               width=650,
               bargap = 0.7)

    })
      
    })     

  ################## DRAW AREA GRAPH FOR LOCATIONS BY HOUR #######################     
  
  observeEvent(

    eventExpr = input[["location_type"]],

    handlerExpr = {

      validate(
        need(input$location_type != "", "Please select at least one location"))
      if (input$location_type=='ALL'){
        thechi1416
      }
      else{
        thechi1416 %>% filter(desc_classifier %in% input$location_type)
      }

  reactbargraphlocationsbyhour = thechi1416[thechi1416$desc_classifier == input$location_type,] %>%
      group_by(hour) %>%
      summarise(Total = n())

   output$reactbargraphlocationsbyhour = renderPlotly({



    p = plot_ly(reactbargraphlocationsbyhour, x= ~hour, y = ~Total, type = 'scatter', mode = 'markers',
                fill = 'tonexty') %>%
        layout(yaxis=list(title="Total Crimes by Location by Hour"))

    })
    })

  
  # reactbargraphlocationsbyhour=reactive({
  #   validate(
  #     need(input$location_type != "", "Please select at least one location")
  #   )
  #   if (input$location_type=='all'){
  #     thechi1416}
  #   else{
  #     thechi1416 %>% filter(desc_classifier %in% input$location_type)
  #   }
  # 
  # })
  # 
  # output$reactbargraphlocationsbyhour<-renderPlot({
  #   ggplot(reactbargraphlocationsbyhour(), aes(x= hour, color=desc_classifier, fill=desc_classifier))+
  #     
  #     geom_area(alpha=0.55, stat='bindot')+
  #     guides(fill=guide_legend(),color=guide_legend())+
  #     labs(x = "Hours", y = "Location Count",
  #          title = "Locations by Hour")
  # 
  # })
  
  
  
  
  ########################## CRIME TYPE BY HOUR ######################
  observeEvent(
    
    eventExpr = input[["crime_type2"]],
    
    handlerExpr = {
      
      reactareacrimesbyhour = thechi1416[thechi1416$primary_type == input$crime_type2,] %>%
        group_by(hour) %>%
        summarise(Total = n())
      
      output$reactareacrimesbyhour = renderPlotly({
        
        p = plot_ly(reactareacrimesbyhour, x= ~hour, y = ~Total, type = 'scatter', mode = 'markers',
                    fill = 'tozeroy', fillcolor= input$crime_type2) %>%
          layout(yaxis=list(title="Crime Types by Hour"))
        #p = add_trace(reactareacrimesbyhour, x = ~hour, y = ~Total, type="scatter", mode="markers", fill = "tonexty")
        
      })
    })
  

  
  ################## HEATMAP REACTIVE DATA #######################   
  
  reactheatmap=reactive({
    thechi1416 %>%
      filter(charge %in% input$type &
               desc_classifier %in% input$premises &
               year %in% cbind(input$year2[1],input$year2[2]))
             

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
    thechi1416 %>% 
      filter(charge %in% input$type1 &
               desc_classifier %in% input$premises1 &
               year %in% cbind(input$year6[1],input$year6[2]))
              
  })
 
  ################## DRAWS INITIAL REGULAR MAP #######################
   output$map=renderLeaflet({
    leaflet() %>% 
      addProviderTiles(providers$Esri.WorldStreetMap) %>% 
      setView(-87.6105, 41.8947,zoom=11)
  })
  observe({
    proxy=leafletProxy("map", data=reactmap()) %>% 
      clearMarkers() %>%
      clearMarkerClusters() %>%
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
    datatable(thechi1416, rownames=FALSE) %>% 
      formatStyle(input$selected,  #this is the only place that requires input from the UI. so
                  #here we are highlighting only the column that the user selected 
                  background="skyblue", fontWeight='bold')
    # Highlight selected column using formatStyle
  })
  
  ################## CREATING TIMESERIES #######################
  
  Arrests_by_Date <- na.omit(thechi1416[thechi1416$arrest == 'TRUE',]) %>% group_by(date) %>% summarise(Total = n())
  arrests_tseries <- xts(Arrests_by_Date$Total, order.by=as.POSIXct(Arrests_by_Date$date))
  
  output$hcontainer <-renderHighchart({

    y = arrests_tseries
    
    highchart(type="stock") %>%
      hc_exporting(enabled = TRUE) %>%
      hc_xAxis(anydate(arrests_tseries, tz="America/Chicago")) %>%
      hc_title(text = "Arrests 2012 - 2016") %>%
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
      hc_add_theme(hc_theme_darkunica()) #,
                                #chart = list(backgroundColor = "white")))
      #hc_add_theme(hc_theme_538(colors = c("red", "white", "blue"),
                              #chart = list(backgroundColor = "white")))
  })
  
  by_Date <- na.omit(thechi1416) %>% group_by(date) %>% summarise(Total = n())
  tseries <- xts(by_Date$Total, order.by=as.POSIXct(by_Date$date))
  
  output$hcontainer2 <-renderHighchart({
    z = tseries
    
    highchart(type="stock") %>%
      hc_exporting(enabled = TRUE) %>%
      hc_add_series(z, name = "Crimes Over Time", smoothed = TRUE, forced = TRUE,
                    groupPixelWidth = 24) %>%
      hc_title(text = "Crimes (2012 - 2016)",
               margin = 20, align = "center") %>%
      hc_add_theme(hc_theme_darkunica()) %>% #,
                                  #chart = list(backgroundColor = "white"))) %>%
      hc_rangeSelector(buttons = list(
        list(type = 'all', text = 'All'),
        list(type = 'month', count = 12, text = '1Y'),
        list(type = 'month', count = 6, text = '6M'),
        list(type = 'month', count = 3, text = '3M'),
        list(type = 'day', count = 30, text = '1M'),
        list(type = 'day', count = 7, text = '1 Week')
      )) 
      
  })
  
})

