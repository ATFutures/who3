# Aim: get osm data for cities
library(tidyverse)
cities = readRDS("global-data/cities-polys.Rds")
cities
# get vital (but small) transport data ------------------------------------

library(osmdata)
bus_stops_accra = opq("accra") %>% add_osm_feature("highway", "bus_stop") %>% osmdata_sf()
city_bbs = lapply(1:nrow(cities), FUN = function(x) try(getbb(x, format_out = "sf_polygon")))
redo_bb = sapply(city_bbs, class) == 


# download global osm data ------------------------------------------------



library(geofabric)
cities = readRDS("global-data/cities.Rds")
# get osm data (download it at least)
for(i in 1:nrow(cities)) {
  message("Getting data from ", cities$City[i])
  get_geofabric(cities$geometry[i], ask = FALSE)
}
summary(cities)


# out-takes ---------------------------------------------------------------


for(i in 1:5) {
  tryCatch(expr = {
    bus_stops_accra = opq("accra") %>% add_osm_feature("highway", "bus_stop") %>% osmdata_sf()
  },
  error = function(e) e,
  finally = print("Next")
  )
  Sys.sleep(time = 1)
}
mapview::mapview(bus_stops_accra$osm_points)


