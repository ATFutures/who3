library(tidyverse)
nts_dir = "~/hd/data/raw/ind/nts/UKDA-5340-spss/spss/spss24/"
old_dir = setwd(nts_dir)
list.files()
# See https://stackoverflow.com/questions/49691736/havenread-sav-showing-value-labels-rather-than-codes
stages = haven::read_spss("stageeul2017.sav") %>% haven::as_factor()
class(stages)
names(stages)
stages_sample = stages %>% sample_n(10000)
summary(stages_sample$StageMode_B04ID)

w = stages %>% filter(str_detect(StageMode_B03ID, "Walk"))
summary(w$StageTime)
summary(w$StageTime_B01ID)


# get time of dat ---------------------------------------------------------

# TripStart_B01ID is hour band

t = haven::read_spss("tripeul2017.sav") %>% haven::as_factor()
ts = t %>% select(1:9, TripStart_B01ID)
wt = inner_join(w, ts) 
wt = wt %>% filter(str_detect(string = TripStart_B01ID, "0")) %>% 
  mutate(hour = as.character(TripStart_B01ID))

table(wt$hour)
table(wt$hour) %>% barplot()

wh = wt %>% 
  group_by(hour) %>% 
  summarise(
    n = n(),
    perc = n() / nrow(wt))

readr::write_csv(wh, "wh.csv")
piggyback::pb_upload("wh.csv", repo = "ATFutures/ATF-ideas")
