# Aim: get osm data for cities
library(tidyverse)
cities = readRDS("global-data/cities-polys.Rds")
cities
# get vital (but small) transport data ------------------------------------

library(osmdata)
accra_point = cities %>% filter(City == "Accra")
bus_stops_accra = opq(sf::st_bbox(accra_point$bb_poly)) %>% add_osm_feature("highway", "bus_stop") %>% osmdata_sf()
get_bus_stops = function(shp) {
  opq(sf::st_bbox(shp)) %>% add_osm_feature("highway", "bus_stop") %>% osmdata_sf()
  message("got bus stops!")
}
get_cycleways = function(shp) {
  opq(sf::st_bbox(shp)) %>% add_osm_feature("highway", "cycleway") %>% osmdata_sf()
  message("got bus stops!")
}

# nominatim died, reverting to bbs
# city_bbs = lapply(1:nrow(cities), FUN = function(x) try(getbb(x, format_out = "sf_polygon")))

bus_stops_cities = lapply(cities$bb_poly, FUN = get_bus_stops)
cycleways_cities = lapply(cities$bb_poly, FUN = get_cycleways)

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

devtools::install_github("ropensci/osmdata")
library(osmdata)
for(i in 1:10) {
  tryCatch(expr = {
    bus_stops_accra = opq("accra") %>% add_osm_feature("highway", "bus_stop") %>% osmdata_sf()
  },
  error = function(e) e,
  finally = print("Next")
  )
  Sys.sleep(time = 1)
}
mapview::mapview(bus_stops_accra$osm_points)


