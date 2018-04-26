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


thechisample=fread("~/Documents/Bootcamp/Lectures/R/SHINY/thechisample.csv", stringsAsFactors=F)
thechisample=as.data.frame(thechisample)

#count by crime type 
count_by_type = thechisample %>%
  group_by(primary_type) %>%
  summarise(Count=n())

#count by charge type
count_by_charge = thechisample %>%
  group_by(charge) %>%
  summarise(Count=n())

count_by_month = thechisample %>% 
  group_by(month) %>%
  summarise(Count=n())

count_by_hour = thechisample %>%
  group_by(hour) %>%
  summarise(Count=n())

count_by_premises= thechisample %>%
  group_by(desc_classifier) %>%
  summarise(Count=n())

choice1=unique(count_by_charge$charge)
#choice2=c('ALL',unique(count_by_type$year))
choice3=unique(count_by_premises$desc_classifier)
#choice4=unique(count.boro$Boro)

groupColors=colorFactor(c('#009DDC','#62BB47'),
                        domain = c('MISDEMEANOR','FELONY'))

