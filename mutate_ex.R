library(dplyr)
library(ggplot2)

flights <- tbl_df(read.csv("flights.csv",
                           stringsAsFactors = FALSE))
flights$date <- as.Date(flights$date)

# Speed in mph
flights <- mutate(flights, speed = dist / (time / 60))

arrange(flights, desc(speed))

# Time made up in flight
flights <- mutate(flights, delta = dep_delay - arr_delay)

# Hour and minute from dep
mutate(flights, hour = dep %/% 100, minute = dep %% 100)
