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


thechi=fread("~/Documents/Bootcamp/Lectures/R/SHINY/thechi.csv", stringsAsFactors=F)
thechi=as.data.frame(thechisample)

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
#choice2=c('ALL',unique(count_by_type$year))
choice3=unique(count_by_premises$desc_classifier)
#choice4=unique(count.boro$Boro)

groupColors=colorFactor(c('#009DDC','#62BB47'),
                        domain = c('MISDEMEANOR','FELONY'))

