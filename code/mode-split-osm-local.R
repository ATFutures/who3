# Aim: get osm data for cities
library(tidyverse)
cities = readRDS("global-data/cities-polys.Rds")
cities
# get vital (but small) transport data ------------------------------------

library(osmdata)
accra_point = cities %>% filter(City == "Accra")
bus_stops_accra = opq(sf::st_bbox(accra_point$bb_poly)) %>% add_osm_feature("highway", "bus_stop") %>% osmdata_sf()
get_bus_stops = function(shp) {
  message("got bus stops!")
  opq(sf::st_bbox(shp)) %>% add_osm_feature("highway", "bus_stop") %>% osmdata_sf()
}
get_cycleways = function(shp) {
  message("got bus stops!")
  opq(sf::st_bbox(shp)) %>% add_osm_feature("highway", "cycleway") %>% osmdata_sf()
}

get_tram = function(shp) {
  message("got bus stops!")
  opq(sf::st_bbox(shp)) %>% add_osm_feature("railway", "tram_stop") %>% osmdata_sf()
}

# nominatim died, reverting to bbs
# city_bbs = lapply(1:nrow(cities), FUN = function(x) try(getbb(x, format_out = "sf_polygon")))

bus_stops_cities = lapply(cities$bb_poly, FUN = get_bus_stops)
cycleways_cities = lapply(cities$bb_poly, FUN = get_cycleways)
has_tram_cities = lapply(cities$bb_poly, FUN = get_tram)

n_bus_stops_cities = purrr::map_int(bus_stops_cities, ~nrow(.$osm_points))
distance_cycleway_cities = purrr::map_dbl(cycleways_cities, ~sf::st_length(.$osm_lines) %>% as.numeric() %>% sum())

cities$bus_stops_per_1000 = n_bus_stops_cities / (cities$Population / 1000)
cities$m_cycleway_per_1000 = round(distance_cycleway_cities / (cities$Population / 1000) )
cities$has_tram = purrr::map_lgl(has_tram_cities, ~nrow(.$osm_points) > 0)
summary(cities$m_cycleway_per_1000)

saveRDS(cities, "global-data/cities-42-osm-bus-cycleway.Rds")


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


