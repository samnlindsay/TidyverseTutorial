library(dplyr)
library(ggplot2)

flights <- tbl_df(read.csv("flights.csv",
                           stringsAsFactors = FALSE))
flights$date <- as.Date(flights$date)

# All flights to SFO or OAK
filter(flights, dest %in% c("SFO", "OAK"))

# All flights in January
filter(flights, date < "2011-02-01")

# All flights delayed by more than one hour
filter(flights, dep_delay > 60)

# All flights that departed between midnight and 5am
filter(flights, 
       (hour + dep_delay %/% 60 + floor((minute + dep_delay) / 60)) %% 24 < 5 &
       (hour + dep_delay %/% 60 + floor((minute + dep_delay) / 60)) %% 24 >= 0)

# All flights where the arrival delay was more than twice the departure delay
filter(flight, arr_delay > 2 * dep_delay)

