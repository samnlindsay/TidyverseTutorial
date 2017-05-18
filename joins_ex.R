library(dplyr)
library(ggplot2)

# Motivation: how can we show airport delays on a map? 
# Need to connect to airports dataset

flights <- tbl_df(read.csv("flights.csv", stringsAsFactors = FALSE))
flights$date <- as.Date(flights$date)
airports <- tbl_df(read.csv("airports.csv", stringsAsFactors = FALSE))

location <- airports %>%
  select(dest = iata, name = airport, lat, long)

flights %>%
  group_by(dest) %>%
  filter(!is.na(arr_delay)) %>%
  summarise(arr_delay = mean(arr_delay), n=n()) %>%
  arrange(desc(arr_delay)) %>%
  left_join(location)

# Let's combine hourly delay data with weather information
hourly_delay <- flights %>%
  group_by(date, hour) %>%
  filter(!is.na(dep_delay)) %>%
  summarise(delay = mean(dep_delay), n=n()) %>%
  filter(n > 10)

delay_weather <- hourly_delay %>% left_join(weather)

#qplot(temp, delay, data = delay_weather)
#qplot(gust_speed, delay, data = delay_weather)
#qplot(is.na(gust_speed), delay, data = delay_weather, geom = "boxplot")
#qplot(conditions, delay, data = delay_weather, geom = "boxplot")
#qplot(events, delay, data = delay_weather, geom = "boxplot")


# Are older planes more likely to be delayed?
planes <- tbl_df(read.csv("planes.csv", stringsAsFactors = FALSE))

planes_delay <- flights %>%
  group_by(plane) %>%
  filter(!is.na(dep_delay)) %>%
  summarise(delay = mean(dep_delay), n=n()) %>%
  filter(n > 10)


