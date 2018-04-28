library(shiny)
library(shinydashboard)
library(ggplot2)
library(data.table)
library(leaflet)
library(dplyr)
library(plotly)
library(DT)
library(leaflet.extras)
library(rMaps)
library(dygraphs)
library(xts)
library(highcharter)
library(anytime)



thechisamp=fread("~/Documents/Bootcamp/Lectures/R/SHINY/thechisampple2.csv", stringsAsFactors=F)
thechisamp=as.data.frame(thechisamp)

#count by crime type 
count_by_type = thechisamp %>%
  group_by(primary_type) %>%
  summarise(Count=n())

#count by charge type
count_by_charge = thechisamp %>%
  group_by(charge) %>%
  summarise(Count=n())

count_by_month = thechisamp %>% 
  group_by(month) %>%
  summarise(Count=n())

count_by_hour = thechisamp %>%
  group_by(hour) %>%
  summarise(Count=n())

count_by_premises= thechisamp %>%
  group_by(desc_classifier) %>%
  summarise(Count=n())

choice1=unique(count_by_charge$charge)
#choice2=c('ALL',unique(count_by_type$year))
choice3=unique(count_by_premises$desc_classifier)
#choice4=unique(count.boro$Boro)


#Arrests_by_Date <- na.omit(thechisamp[thechisamp$arrest == 'TRUE',]) %>% group_by(date_alone) %>% summarise(Total = n())
#arrests_tseries <- xts(Arrests_by_Date$Total, order.by=as.POSIXct(Arrests_by_Date$date_alone))

groupColors=colorFactor(c('#009DDC','#62BB47'),
                        domain = c('MISDEMEANOR','FELONY'))

