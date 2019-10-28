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
  na.omit() %>%
  filter(rowSums(.[modes]) == 100)
# saveRDS(dc, "global-data/city-mode-split-wiki.Rds")
nrow(dc)
dc$n = 1:nrow(dc)

names(dc)
dt = dc %>% pivot_longer(cols = 2:(ncol(dc) - 2), names_to = "mode") %>% na.omit()
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
  scale_fill_manual(values = rev(scales::hue_pal()(4)))
# ggplot(dt) + geom_area(aes(n, value, fill = mode_factor), stat = "identity")
ggsave(filename = "figures/city-mode-split-wiki-cars.png")
cor_mat = cor(dc[modes])
png(filename = "figures/city-mode-cor.png")
corrplot::corrplot(cor_mat, type = "lower", tl.pos = "d")
dev.off()
# corrr::rplot(rdf = .Last.value)
# now: get predictors that policy makers control
# - speeds
# - car parking spaces


# get explanatory variables -----------------------------------------------

# u = "https://data.london.gov.uk/download/global-city-data/ffcefcba-829c-4220-911f-d4bf17ef75d6/global-city-indicators.xlsx"
# download.file(u, "global-city-indicators.xlsx")
# gci = readxl::read_excel("global-city-indicators.xlsx", 2)
# gci_mat = t(gci)
# gci_names = gci_mat[1, ]
# explanatory_variables = gci_mat[-c(1, 2), !is.na(gci_names)] %>% as_tibble()
# names(explanatory_variables) = gci_names[!is.na(gci_names)]
# explanatory_variables = explanatory_variables %>% select(People, everything()) 
# contains_london = explanatory_variables[1, ] %>% str_detect(pattern = "London")
# contains_london[1] = FALSE
# explanatory_variables = explanatory_variables %>% select(which(!contains_london))
# could_be_numeric = function(x) sum(is.na(as.numeric(x))) < 0.8 * length(x)
# # could_be_numeric(explanatory_variables$`City Area (km2)`, 0.8)
# # could_be_numeric(explanatory_variables$`Primary Industry`, 0.8)
# num_vars = map_lgl(explanatory_variables, could_be_numeric)
# explanatory_variables = explanatory_variables %>%
#   mutate_if(could_be_numeric, as.numeric) %>% 
#   rename(City = People)
# saveRDS(explanatory_variables, "global-data/global-city-indicators.Rds")
# explanatory_variables = readRDS("global-data/global-city-indicators.Rds")
# 
# summary(dc$City %in% explanatory_variables$City)
# cities_long = inner_join(dt, explanatory_variables)
# cities_wide = inner_join(dc, explanatory_variables)
# 
# X = cities_wide %>% select(2:5) / 100
# Y = cities_wide %>% select(`Green Spaces (km2)`, `City Area (km2)`, `City Population (millions)`)
# XY = bind_cols(City = cities_wide$City, X, Y) %>% na.omit()
# 
# library(DirichletReg)
# XY$Y = DR_data(XY[, 2:5])
# m1 = DirichReg(Y ~ `Green Spaces (km2)` + `City Population (millions)`, XY)
# m2 = DirichReg(Y ~ `Green Spaces (km2)` + `City Population (millions)` + `City Area (km2)`, XY)
# anova(m1, m2)
# plot(m1)
# 
# predict(m2, XY) # that's the badger!
# m1 = fmlogit(XY[2:5], XY[6:ncol(XY)]) # Very slow...
# summary(m1)

# tests
# devtools::install_github("f1kidd/fmlogit")
# ?fmlogit::fmlogit
# library(fmlogit)
# data = spending
# head(spending)
# X = data[,2:5]
# y = data[,6:11]
# results1 = fmlogit(y,X)
# y2 = predict(results1, X)
# plot(y$governing, y2$governing)
summary(results1)
