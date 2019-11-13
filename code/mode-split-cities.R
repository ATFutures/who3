# Aim: get mode split for cities

library(tidyverse)
library(sf)
modes_min = c("car", "pt", "cycling", "walking")
modes = c(modes_min, "other")


d1 = htmltab::htmltab("https://en.wikipedia.org/wiki/Modal_share", which = 1)
d2 = htmltab::htmltab("https://en.wikipedia.org/wiki/Modal_share", which = 2)
names(d1)
names(d2)

d = bind_rows(d1, d2) %>%
  rename(pt = `public transport`) %>%
  rename(car = `private motor vehicle`)
names(d)
summary(d)
str_replace(d$walking[1], "%", "")
dc = d %>% # clean data
  mutate_all(str_replace, "\\%", "") %>%
  mutate(City = gsub(pattern = "New York City", "New York", x = City)) %>%
  mutate_at(vars(-1), as.numeric) %>%
  arrange(walking) %>%
  na.omit() %>%
  filter(rowSums(.[modes_min]) <= 100) %>%
  mutate(other = 100 - rowSums(.[modes_min])) %>%
  select(City, matches("ing|pt|car|other"), year)
saveRDS(dc, "city-mode-split-wiki.Rds")
nrow(dc)

names(dc)
dc$n = 1:nrow(dc)
dt = dc %>% pivot_longer(cols = 2:(ncol(dc) - 2), names_to = "mode") %>% na.omit()
dt
summary(dt)
unique(dt$mode)
dt$mode = factor(dt$mode, levels = modes)


g = ggplot_build(g1)
cols = unique(g$data[[1]]["fill"])
class(cols)
length(cols)

g1 = ggplot(dt) + geom_bar(aes(n, value, fill = mode), stat = "identity", width = 1)
g1
ggsave(filename = "figures/city-mode-split-wiki.png", plot = g1)
dc %>% arrange(car) %>% mutate(n = 1:nrow(dc)) %>%
  pivot_longer(cols = 2:(ncol(dc) - 2), names_to = "mode") %>%
  mutate(mode = factor(dt$mode, levels = rev(modes))) %>%
  ggplot() + geom_bar(aes(n, value, fill = mode), stat = "identity", width = 1) +
  # scale_fill_discrete(h = c(0, 360) + 15, c = 100, l = 65, h.start = 0)
  scale_fill_manual(values = rev(scales::hue_pal()(5)))
# ggplot(dt) + geom_area(aes(n, value, fill = mode_factor), stat = "identity")
ggsave(filename = "figures/city-mode-split-wiki-cars.png")
cor_mat = cor(dc[modes])
png(filename = "figures/city-mode-cor.png")
corrplot::corrplot(cor_mat, type = "lower", tl.pos = "d")
dev.off()

dc$n = NULL

# mode split results for ghana --------------------------------------------

modes_ghana = read_csv("https://github.com/ATFutures/who3/raw/master/global-data/travel_to_work_ghana.csv")
modes_ghana_long = pivot_longer(modes_ghana %>% select(-Male, -Female, -Ghana, -contains("Total")), cols = 2:5, names_to = "Type")
modes_ghana_long %>%
  ggplot() + geom_bar(aes(Type, value, fill = `Means of travel`), stat = "identity")
ggsave(filename = "figures/modes-ghana-work.png")

modes_ghana_long = modes_ghana_long %>%
  mutate(mode = case_when(
    str_detect(`Means of travel`, pattern = "car|Car|indi") ~ "car",
    str_detect(`Means of travel`, pattern = "Bus|Train|share") ~ "pt",
    str_detect(`Means of travel`, pattern = "Bicy") ~ "cycling",
    str_detect(`Means of travel`, pattern = "foot") ~ "walking",
    # TRUE ~ `Means of travel`
    TRUE ~ "other"
  ))
gmodes = c("other", modes)
modes_ghana_long = modes_ghana_long %>%
  mutate(mode = factor(mode, levels = modes)) %>%
  mutate(Type = factor(Type, levels = (unique(Type))))

cols_modes = scales::hue_pal()(5)
cols_gmodes = c("grey", cols_modes)
modes_ghana_long %>%
  ggplot() + geom_bar(aes(Type, value, fill = `mode`), stat = "identity") +
  scale_fill_manual(values = cols_modes)

ggsave("figures/modes-ghana-work-simple.png")

# install.packages("rnaturalearth")
# library(rnaturalearth)
# ne_download()
ne_cities = ukboundaries::duraz("https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_populated_places.zip")
names(ne_cities)
# ne_cities = ukboundaries::duraz("https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_populated_places_simple.zip")
plot(ne_cities$GTOPO30, ne_cities$ELEVATION)
summary(ne_cities$NAME %in% dc$City)
ne_cities_modes = ne_cities %>%
  filter(NAME %in% dc$City) %>%
  group_by(NAME) %>%
  top_n(n = 1, wt = POP_MAX) %>%
  select(City = NAME, Population = POP_MAX, Area = MIN_AREAKM, Height = GTOPO30, Country = ADM0NAME)
summary(ne_cities_modes)
set.seed(22)
ne_cities_to_label = ne_cities_modes[sample(1:nrow(ne_cities_modes), size = 10), ]
ne_cities_large = ne_cities_modes %>% filter(Area > 2000 | Population > 7e6 | City == "New York")
ne_cities_to_label = rbind(ne_cities_to_label, ne_cities_large)
cities = inner_join(ne_cities_modes, dc)

cities %>%  
  ggplot(aes(Area, Population)) + geom_point(aes(colour = walking)) +
  ggrepel::geom_label_repel(aes(Area, Population, label = City), data = ne_cities_to_label)
ggsave("~/atfutures/who3/figures/cities-area-population.png")

saveRDS(ne_cities_modes, "vignettes/cities.Rds")
plot(ne_cities_modes)

# corrr::rplot(rdf = .Last.value)
# now: get predictors that policy makers control
# - speeds
# - car parking spaces

# starting point: which cities?
dc = readRDS("global-data/city-mode-split-wiki.Rds")
gci = readRDS("global-data/global-city-indicators.Rds")
summary(dc$City %in% gci$City) # 35 matching cities
gci_min = gci %>%
  select(City, `City Population (millions)`, `City Area (km2)`, `Public Transportation`, `Green Spaces (km2)`, `Bike Share Program`)
dcj = inner_join(dc, gci_min) %>% na.omit() %>%  # 28 cities
  mutate_at(vars(matches("ing|pt|car|other")), ~./100) %>%
  janitor::clean_names() %>%
  mutate(bike_share_program = case_when(bike_share_program == "Yes" ~ TRUE, TRUE ~ FALSE )) %>%
  mutate(metro = case_when(bike_share_program == "Yes" ~ TRUE, TRUE ~ FALSE )) %>%
  mutate(density = (city_population_millions * 1000) / city_area_km2 )
saveRDS(dcj, "global-data/data-cities-mode-share-predictors.Rds")
