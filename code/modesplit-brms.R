library(tidyverse)
library(brms)
d = readRDS("global-data/data-cities-mode-share-predictors.Rds")
names(d)
# no zeros allowed: how to allow zero values?
d = d %>% 
  filter(other > 0, cycling > 0) %>% 
  mutate(has_metro = str_detect(public_transportation, "Metro"))
modes_matrix = d %>% select(2:6) %>% as.matrix()
# modes_matrix[modes_matrix == 0] = 0.01
d$mode = modes_matrix
m = brm(mode ~ city_population_millions + density + green_spaces_km2 + has_metro + bike_share_program, data = d, family = dirichlet())
# shinystan::launch_shinystan(m)
# plot(m) # works
p = plot(marginal_effects(m, conditions = "density:city_population_millions", categorical = T))
p$`city_population_millions:cats__` +
  ylab("Mode share")
ggsave("figures/mode-share-prediction.png")
p$`bike_share_program:cats__`
p$`has_metro:cats__` +
  ylab("Mode share")
ggsave("figures/mode-share-prediction-metro.png")  
