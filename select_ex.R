library(dplyr)
library(ggplot2)

flights <- tbl_df(read.csv("flights.csv",
                           stringsAsFactors = FALSE))
flights$date <- as.Date(flights$date)

# Different ways to select the arr_delay and dep_delay columns
select(flights, arr_delay, dep_delay)
select(flights, arr_delay:dep_delay)
select(flights, ends_with("delay"))
select(flights, contains("delay"))

# Order flights by departure date and time
arrange(flights, date, hour, minute)

# Which flights were most delayed?
arrange(flights, desc(dep_delay))[, 10]

# Which flights caught up the most time during flight?
arrange(flights, desc(dep_delay - arr_delay))
