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
library(xts)
library(highcharter)
library(shinythemes)
library(markdown)
library(tidyverse)
library(anytime)




thechi=fread("~/Documents/Bootcamp/Lectures/R/SHINY/thechi.csv", stringsAsFactors=F)
thechi=as.data.frame(thechi)
# mutate(Year  = factor(year(date), levels=2012:2017),
#        month = factor(month(date), levels=1:12),
#        day_of_month   = mday(date),
#        hour  = factor(hour(date), levels=0:23),
#        #daydate = as.POSIXct(round(date, units = "days")),
#        day_of_week = factor(wday(date))
# thechi$date=as.POSIXct(thechi$date, format = "%m/%d/%Y %I:%M:%S %p", 
#                        tz= "America/Chicago")

thechi$year = factor(thechi$year, levels=2012:2017)
thechi$month = factor(thechi$month, levels =1:12)
thechi$hour = factor(thechi$hour, levels=0:23)
#thechi$day_of_week= factor(thechi$date, levels=wday(date))

thechisamp=thechi[1:30000,]

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
choice3=unique(count_by_premises$desc_classifier)
choice4=unique(count_by_type$primary_type)


#Arrests_by_Date <- na.omit(thechisamp[thechisamp$arrest == 'TRUE',]) %>% group_by(date_alone) %>% summarise(Total = n())
#arrests_tseries <- xts(Arrests_by_Date$Total, order.by=as.POSIXct(Arrests_by_Date$date_alone))

groupColors=colorFactor(c('#009DDC','#62BB47'),
                        domain = c('MISDEMEANOR','FELONY'))

