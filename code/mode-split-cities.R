# Aim: get mode split for cities

library(tidyverse)
modes = c("car", "pt", "cycling", "walking")

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
  mutate_at(vars(-1), as.numeric) %>%
  arrange(walking) %>%
  mutate(n = 1:nrow(d)) %>%
  na.omit() %>%
  filter(rowSums(.[modes]) == 100)
saveRDS(dc, "global-data/city-mode-split-wiki.Rds")

names(dc)
dt = dc %>% pivot_longer(cols = 2:(ncol(dc) - 2), names_to = "mode")
summary(dt)
unique(dt$mode)
dt$mode_factor = factor(dt$mode, levels = modes)

ggplot(dt) + geom_area(aes(n, value, fill = mode_factor))
ggsave(filename = "figures/city-mode-split-wiki.png")
cor_mat = cor(dc[modes])
png(filename = "figures/city-mode-cor.png")
corrplot::corrplot(cor_mat, type = "lower", tl.pos = "d")
dev.off()
# corrr::rplot(rdf = .Last.value)
# now: get predictors that policy makers control
# - speeds
# - car parking spaces
