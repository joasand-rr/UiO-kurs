###################################################
### SWAPI as an example for .json-scraping in R ###
###################################################

library(jsonlite) # Package for structuring json
library(httr)     # Package for testing urls

# SWAPI base url -- list over availabel data sources
base_swapi_url <- "https://swapi.dev/api/"

# Downloading data sources
swapi_base <- read_json(base_swapi_url)

# See which elements are in the list
names(swapi_base)

# Downloading a list of people
swapi_people <- read_json(paste0(base_swapi_url, "people/"))

# Checks the structure of people
# listviewer::jsonedit(swapi_people)

# There are 82 people in "count"
swapi_people$count

# Creates an empty list
swapi_people_individuals <- list()

# Loops over the numbers 1 through 82
for(i in 1:swapi_people$count){
  
  # Progressbar
  it <- 100 * (i / swapi_people$count)
  cat(paste0(sprintf("%.2f%%         ", it), "\r"))
  
  # Testing urls (e.g 17 is empty)
  tmp <- GET(paste0(base_swapi_url, "people/", i, "/"))
  
  # If the status code on the request is not 200 (sucess),
  # give NULL and proceed to the next i
  if(tmp$status_code != 200){
    swapi_people_individuals[[i]] <- NULL
    next
  }
  
  # Insert data on person i
  swapi_people_individuals[[i]] <- read_json(tmp$url)
}

# Binding all persons into one data.frame()
# (`x[1:8]` subseets the first 8th elemtents in each list element.)
swapi_people_df <- purrr::map_df(swapi_people_individuals, 
                                 function(x) data.frame(x[1:8]))

# Table over eye color and gender
table(swapi_people_df$eye_color, swapi_people_df$gender)