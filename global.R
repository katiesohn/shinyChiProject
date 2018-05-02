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





#thechi=fread("~/Documents/Bootcamp/Lectures/R/SHINY/thechi.csv", stringsAsFactors=F)
thechi = readRDS("thechi.rds")


thechi$year = factor(thechi$year, levels=2012:2017)
thechi$month = factor(thechi$month, levels =1:12)
thechi$hour = factor(thechi$hour, levels=0:23)
#thechi$day_of_week= factor(thechi$date, levels=wday(date))

#SAMPLE FOR FIRST 100K ROWS
thechisamp=thechi[1:100000,]
#SAMPLE FROM JUST 2014 - 2016
thechi1416=thechi[thechi$year==2014 | thechi$year ==2015 | thechi$year == 2016,]

#count by crime type 
count_by_type = thechi %>%
  group_by(primary_type) %>%
  summarise(Count=n())

#count by charge type
count_by_charge = thechi %>%
  group_by(charge) %>%
  summarise(Count=n())

count_by_month = thechi %>% 
  group_by(month) %>%
  summarise(Count=n())

count_by_hour = thechi %>%
  group_by(hour) %>%
  summarise(Count=n())

count_by_premises= thechi %>%
  group_by(desc_classifier) %>%
  summarise(Count=n())

choice1=unique(count_by_charge$charge)
choice3=unique(count_by_premises$desc_classifier)
choice4=unique(count_by_type$primary_type)
chicagopop=2700000



groupColors=colorFactor(c('#009DDC','#62BB47'),
                        domain = c('MISDEMEANOR','FELONY'))

