library(dplyr)
library(ggplot2)

flights <- tbl_df(read.csv("flights.csv",
                           stringsAsFactors = FALSE))
flights$date <- as.Date(flights$date)

# Which destinations have the highest average delays
flights %>%
  group_by(dest) %>%
  summarise(arr_delay=mean(arr_delay, na.rm = TRUE), n = n()) %>%
  arrange(desc(arr_delay))

# Which flights (i.e. carrier + flight) happen every day? Where to?
flights %>%
  group_by(carrier, flight, dest) %>%
  summarise(n = n()) %>%
  filter(n == 365)

# On average, how do delays of non-canc. flights vary over the course of day?
per_hour <- flights %>%
  filter(cancelled == 0) %>%
  mutate(time = hour + minute / 60) %>%
  group_by(time) %>%
  summarise(arr_delay = mean(arr_delay, na.rm = TRUE), n = n())

