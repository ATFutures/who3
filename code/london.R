# Aim estimate active transport potential in London

# From https://github.com/moveability/calibration

settlement_name = "london"

library (osmdata)

bb <- getbb (settlement_name, format_out = "polygon") # no polygon available
hw <- opq (bb) %>%
  add_osm_feature (key = "highway") %>%
  osmdata_sc (quiet = FALSE)
hw <- osm_elevation (hw, elev_file = elev_file)
saveRDS (hw, file = file.path (data_dir, "accra-hw.Rds"))

library (moveability)
attractors <- get_attractors (bb)
saveRDS (attractors, file = file.path (data_dir, "accra-attractors.Rds"))
green_polys <- get_green_space (bb)
saveRDS (green_polys, file = file.path (data_dir, "accra-green.Rds"))