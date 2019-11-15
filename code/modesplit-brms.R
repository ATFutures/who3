library(tidyverse)
library(brms)
d = readRDS("global-data/cities-101-osm-bus.Rds")
names(d)
# no zeros allowed: how to allow zero values?
d %>% sf::st_drop_geometry() %>% select(walking:cycling) %>% summary()
d = d %>% 
  st_drop_geometry() %>%
  # filter(cycling != 0) %>% 
  # filter(other != 0) %>% 
  mutate_at(vars(other, cycling), ~case_when(. == 0 ~ runif(n = 1, min = 0, max = 0.5), TRUE ~ .)) %>%
  ungroup() %>%
  select(-bb_poly) %>% 
  mutate(Density = Population / Area)
totals = d %>% select(walking:other, -City) %>% rowSums() - 100
d$car = d$car - totals
modes_matrix = d %>% select(walking:other) %>% as.matrix()
summary(rowSums(modes_matrix))
d = d %>% select(-(walking:other))
# modes_matrix[modes_matrix == 0] = 0.01
d$mode = modes_matrix / 100
names(d)
# set init to 0 - see https://discourse.mc-stan.org/t/initialization-error-try-specifying-initial-values-reducing-ranges-of-constrained-values-or-reparameterizing-the-model/4401
m = brm(mode ~ Density + bus_stops_per_1000 + has_tram, data = d, family = dirichlet(), inits = 0)
# ESS tool low on data with 42 cities: https://easystats.github.io/bayestestR/reference/effective_sample.html
# not working...
# m = brm_multiple(mode ~ Population + Density + bus_stops_per_1000 + has_tram, data = d, family = dirichlet(), inits = 0, combine = T)
# m = brm(mode ~ Population, data = d, family = dirichlet())
# shinystan::launch_shinystan(m)
# plot(m) # works
p = plot(marginal_effects(m, conditions = "Density:Population", categorical = T))  + ylab("Mode share")
p$`Density:cats__` + ylab("Mode share")
ggsave("figures/mode-share-prediction.png")
p$`m_cycleway_per_1000:cats__`
p$`has_tram:cats__` + ylab("Mode share")
ggsave("figures/mode-share-prediction-metro.png")  
