#load in necessary packages
library(tidyverse)
library(leaflet)
library(htmlwidgets)
library(leaflet.providers)

#read in data
snitch <- read.csv("~/Dropbox/Policing the Pandemic (PtP) Interactive Map/Data/snitch_data_frame.csv")

#prepare data for mapping
snitch$event_url <- paste0("<b><a href='", snitch$event_url) %>%
  paste0("'>") %>%
  paste0(snitch$event_desc) %>%
  paste0("</a></b>")

snitch$lat <- jitter(snitch$lat, factor = 0.05)
snitch$long <- jitter(snitch$long, factor = 0.05)

snitch$date <- paste0("<strong>Date: </strong>", snitch$date)
snitch$place <- paste0("<strong>Place: </strong>", snitch$place)

snitchcontent <- paste(sep = "<br/>",
                       snitch$event_url,
                       snitch$date,
                       snitch$place)

phoneicon <- makeIcon(
  iconUrl = "~/Dropbox/Policing the Pandemic (PtP) Interactive Map/Images/phone_image_4.png",
  iconWidth = 20, iconHeight = 50,
  iconAnchorX = 20, iconAnchorY = 50)

#create interactive map of snitch events
snitchmap <- snitch %>%
  leaflet() %>%
  #addProviderTiles(providers$Stamen.TonerLite) %>%
  addLayersControl(overlayGroups = "COVID-19 Snitch Lines",
                   options = layersControlOptions(collapsed = FALSE)) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addMarkers(snitch$long, snitch$lat, popup = snitchcontent, icon = phoneicon,
             clusterOptions = TRUE, group = "COVID-19 Snitch Lines")

#save as HTML for website
saveWidget(widget=snitchmap, file="/Users/alexluscombe/Dropbox/Policing the Pandemic (PtP) Interactive Map/Snitch Map/index.html", selfcontained = FALSE)
