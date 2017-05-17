library(dplyr)
library(ggplot2)

flights <- tbl_df(read.csv("flights.csv",
                           stringsAsFactors = FALSE))
flights$date <- as.Date(flights$date)

# For each plane, find the two most delayed flights
flights %>% group_by(plane) %>%
  filter(row_number(arr_delay) <= 2)

daily <- flights %>%
  group_by(date) %>%
  summarise(delay = mean(dep_delay, na.rm = TRUE))

# What's the day-to-day change in average flight delays?
daily %>% mutate(delay - lag(delay), order_by = date)
