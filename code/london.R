# Aim estimate active transport potential in London

# From https://github.com/moveability/calibration

settlement_name = "hereford"
dir.create(settlement_name)
devtools::install_github("moveability/moveability")
library (osmdata)

bb <- getbb (settlement_name, format_out = "polygon") # no polygon available
bb <- bb[[1]][[1]]
plot(bb)
hw <- opq (bb) %>%
  add_osm_feature (key = "highway") %>%
  osmdata_sc (quiet = FALSE)
hw <- osm_elevation (hw, elev_file = elev_file)
saveRDS (hw, file = file.path(settlement_name, "hw.Rds"))
# hw = readRDS(file.path(settlement_name, "hw.Rds"))

# hw_sf = moveability::moveability_to_lines(hw)
library (moveability)
attractors <- get_attractors (bb)
saveRDS (attractors, file = file.path (settlement_name, "attractors.Rds"))
# attractors = readRDS(file.path (settlement_name, "attractors.Rds"))
green_polys <- get_green_space (bb)
saveRDS (green_polys, file = file.path (settlement_name, "green.Rds"))
# green_polys = readRDS(file.path(settlement_name, "green.Rds"))
green_polys

graph <- dodgr::weight_streetnet (hw, wt_profile = "foot")
saveRDS(graph, file = file.path (settlement_name, "graph.Rds"))
graph = readRDS(file = file.path (settlement_name, "graph.Rds"))
graphc <- dodgr::dodgr_contract_graph (graph)
v <- dodgr::dodgr_vertices (graphc)

ids <- split (v$id, cut (v$n, breaks = 1000))
i = ids[1:10]

# computationally monstrous # 50 GB on 1mil g
# should have randomly sampled from points?
mf <- parallel::mclapply (mc.cores = 6, ids, function (i)
{
  moveability (graphc, from = i,
               green_polys = green_polys,
               activity_points = attractors,
               mode = "foot", d_threshold = 0.7)
})
saveRDS(mf, file.path(settlement_name, "mf.Rds"))
mf <- do.call (rbind, mf)
summary(mf)
rownames (mf) <- NULL
mf$green_area [is.nan (mf$green_area)] <- 0
saveRDS (mf, file.path (settlement_name, "moveability.Rds"))
# _to_lines scales moveability by sqrt of num. activity centres
mfsf <- moveability_to_lines (mf, streetnet)
saveRDS (mfsf, file.path (settlement_name, "moveability-sf.Rds"))

m <- readRDS (file.path (settlement_name, "moveability.Rds"))
popdens <- readRDS ("<...>/who-data/accra/osm/popdens_nodes.Rds")
popdens <- popdens [popdens$osm_id %in% m$id, ]
m$popdens <- NA
m$popdens [match (popdens$osm_id, m$id)] <- popdens$pop
m <- m [!is.na (m$popdens), ]
m$m <- m$m * m$popdens
streetnet <- readRDS (file.path (settlement_name, "hw.Rds"))
msf <- moveability_to_lines (m, streetnet)
saveRDS (msf, file.path (settlement_name, "moveability-sf.Rds"))
```

Have to use google rather than OSM places, by loading the file from the
binaries in the `who-data` repo.

```{r, eval = FALSE}
attractors <- readRDS ("<...>/atfutures/who-data/accra/osm/gplaces.Rds")
index <- dodgr::match_points_to_graph (v, attractors [, c ("lon", "lat")])
attractors$id <- v$id [index]
names (attractors) [which (names (attractors) %in% c ("lon", "lat"))] <- c ("x", "y")

m <- readRDS (file.path (settlement_name, "moveability-sf.Rds"))
m <- mfsf
m$flow <- m$flow * 50 / max (m$flow)
library (mapdeck)
set_token (Sys.getenv ("MAPBOX_TOKEN"))
mapdeck (style = 'mapbox://styles/mapbox/dark-v9') %>%
    add_path (data = m,
              layer_id = "foot",
              stroke_colour = "flow",
              stroke_width = "flow",
              palette = "inferno")


u = "https://github.com/Robinlovelace/movingpandas/raw/rmarkdown/0_getting_started.Rmd"
download.file(u, "py.Rmd")
file.edit("py.Rmd")
