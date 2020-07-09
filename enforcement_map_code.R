#load in necessary packages
library(tidyverse)
library(leaflet)
library(htmlwidgets)
library(leaflet.providers)

#read in data
ptp <- read_csv("<name>")

#make urls in csv clickable links, titled by event description
ptp$event_url <- paste0("<b><a href='", ptp$event_url) %>%
  paste0("'>") %>%
  paste0(ptp$event_desc) %>%
  paste0("</a></b>")

#add headers to other data points
ptp$report_date <- paste0("<strong>Date: </strong>", ptp$report_date)
ptp$place <- paste0("<strong>Place: </strong>", ptp$place)
ptp$violation <- paste0("<strong>Violation: </strong>", ptp$violation)
ptp$acting_agency <- paste0("<strong>Acting agency: </strong>", ptp$acting_agency)
ptp$legislation <- paste0("<strong>Legislation: </strong>", ptp$legislation)
ptp$number_of_people <- paste0("<strong>Number of people: </strong>", ptp$number_of_people)

#jitter lat / long to prevent with point overlap
ptp$lat <- jitter(ptp$lat, factor = 0.5)
ptp$long <- jitter(ptp$long, factor = 0.5)

#subset
crim <- subset(ptp, offence_type == "Criminal law offence")
emerg <- subset(ptp, offence_type == "Emergency law offence")
health <- subset(ptp, offence_type == "Public health law offence")
bylaw <- subset(ptp, offence_type == "Municipal by-law offence")
mixed <- subset(ptp, offence_type == "Mixed offence")

#set content of addmarker
crimcontent <- paste(sep = "<br/>",
                     crim$event_url,
                     crim$report_date,
                     crim$number_of_people,
                     crim$acting_agency,
                     crim$place,
                     crim$legislation)

emergcontent <- paste(sep = "<br/>",
                      emerg$event_url,
                      emerg$report_date,
                      emerg$number_of_people,
                      emerg$acting_agency,
                      emerg$place,
                      emerg$legislation)

healthcontent <- paste(sep = "<br/>",
                       health$event_url,
                       health$report_date,
                       health$number_of_people,
                       health$acting_agency,
                       health$place,
                       health$legislation)

bylawcontent <- paste(sep = "<br/>",
                      bylaw$event_url,
                      bylaw$report_date,
                      bylaw$number_of_people,
                      bylaw$acting_agency,
                      bylaw$place,
                      bylaw$legislation)

mixedcontent <- paste(sep = "<br/>",
                      mixed$event_url,
                      mixed$report_date,
                      mixed$number_of_people,
                      mixed$acting_agency,
                      mixed$place,
                      mixed$legislation)

#set colours by event type
pal <- colorFactor(
  palette = c("red", "blue", "#228B22", "purple", "#9b870c"),
  levels = c("Criminal law offence", "Emergency law offence", "Public health law offence", "Municipal by-law offence", "Mixed offence")
)

#create interactive map of events
ptpmap <- ptp %>%
  leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addLayersControl(overlayGroups = c("Criminal law offence", "Emergency law offence",
                                     "Public health law offence",
                                     "Municipal by-law offence", "Mixed offence"),
                   options = layersControlOptions(collapsed = FALSE)) %>%
  addCircleMarkers(lng = crim$long, lat = crim$lat,
                   popup = crimcontent, color = "red",
                   fillOpacity = .75, stroke = T, group = "Criminal law offence",
                   clusterOptions = T) %>%
  addCircleMarkers(lng = emerg$long, lat = emerg$lat,
                   popup = emergcontent, color = "blue",
                   fillOpacity = .75, stroke = T, group = "Emergency law offence",
                   clusterOptions = T) %>%
  addCircleMarkers(lng = health$long, lat = health$lat,
                   popup = healthcontent, color = "#228B22",
                   fillOpacity = .75, stroke = T, group = "Public health law offence",
                   clusterOptions = T) %>%
  addCircleMarkers(lng = bylaw$long, lat = bylaw$lat,
                   popup = bylawcontent, color = "purple",
                   fillOpacity = .75, stroke = T, group = "Municipal by-law offence",
                   clusterOptions = T) %>%
  addCircleMarkers(lng = mixed$long, lat = mixed$lat,
                   popup = mixedcontent, color = "#9b870c",
                   fillOpacity = .75, stroke = T, group = "Mixed offence",
                   clusterOptions = T) %>%
  addLegend("bottomright", pal = (pal), values = ~offence_type,
            title = "LEGISLATION <br/>(cluster colours not reflected by legend)",
            labFormat = labelFormat(prefix = ""),
            opacity = 1
  )

#save interative map as HTML object for website
saveWidget(widget=ptpmap, file="<name>", selfcontained = FALSE)
