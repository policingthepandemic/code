#load in necessary packages
library(DT)
library(tidyverse)
library(magrittr)
library(htmlwidgets)

#read in data
ptp <- read.csv("<name>")
                    
#build table
ptp$event_url <- paste0("<b><a href='", ptp$event_url) %>%
  paste0("'>") %>%
  paste0(ptp$event_desc) %>%
  paste0("</a></b>")

myvars <- names(ptp) %in% c("place", "violation", "report_date", 
                            "acting_agency", "legislation", "event_url", 
                            "number_of_people", 
                            "known_demographic", "individual_business") 

newdata <- ptp[myvars]

newdata <- newdata %>%
  arrange(report_date)

table <- datatable(newdata, class = "display", escape = FALSE, options = list(
  initComplete = JS("
                    function(settings, json) {
                    $(this.api().table().body()).css({
                    'background-color': '#F0350F',
                    'outline-color': '#F0350F',
                    'margin':'100px',
                    'color': 'black',
                    'text-align': 'left',
                    'font-family': 'Helvetica Neue',
                    'border-radius': '25px'
                    });
                    $(this.api().table().header()).css({
                    'background-color': '#FFFFFF',
                    'color': '#F0350F',
                    'outline-color': 'red',
                    'margin':'100px',
                    'text-align': 'center',
                    'font-family': 'Times New Roman',
                    'border-radius': '25px'
                    });
                    }
                    "),
  pageLength = 50
  ),
  caption = htmltools::tags$caption(
    style = 'caption-side: top; text-align: center; color:black;
    font-size:200% ;',''),
  filter=list(position = 'top')
  ) %>%
  formatStyle(
    'number_of_people',
    background = gsub(
      "value", "Math.abs(value)", styleColorBar(abs(newdata$number_of_people), '#F0350F'),
      fixed = TRUE),
    backgroundSize = '100% 80%',
    backgroundRepeat = 'no-repeat',
    backgroundPosition = 'center'
  )

#save table as HTML object
saveWidget(widget=table, file="<name>", selfcontained = FALSE)
