library(dplyr)
library(ggplot2)

flights <- tbl_df(read.csv("flights.csv",
                           stringsAsFactors = FALSE))
flights$date <- as.Date(flights$date)

# Summarise dep_delay for each day
by_date <- group_by(flights, date)
no_missing <- filter(flights, !is.na(dep))
delays <- summarise(no_missing,
                    mean = mean(dep_delay),
                    median = median(dep_delay),
                    q75 = quantile(dep_delay, 0.75),
                    over_15 = mean(dep_delay > 15),
                    over_30 = mean(dep_delay > 30),
                    over_60 = mean(dep_delay > 60)
                    )
