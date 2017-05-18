library(dplyr)
library(zoo)

flights <- tbl_df(read.csv("flights.csv",
                           stringsAsFactors = FALSE))
flights$date <- as.Date(flights$date)

df <- data.frame(
  houseID = rep(1:10, each = 10),
  year = 1995:2004,
  price = ifelse(runif(10 * 10) > 0.50, NA, exp(rnorm(10 * 10)))
)

df %>%
  group_by(houseID) %>%
  do(na.locf(.))

df %>%
  group_by(houseID) %>%
  do(head(., 2))

df %>%
  group_by(houseID) %>%
  do(data.frame(year = .$year[1]))

# Goal fit a linear model to each day, predicting # delay from time of day
usual <- flights %>%
  mutate(time = hour + minute / 60) %>%
  filter(hour >= 5, hour <= 20)

models <- usual %>%
  group_by(date) %>%
  do(
    mod = lm(dep_delay ~ time, data = .)
  )

models
str(models) # don't do this!
str(models[1, ])

rsq <- function(x) summary(x)$r.squared
fit <- models %>% 
  summarise(date = as.Date(date[1]), rsq = rsq(mod))
fit %>% arrange(desc(rsq))
fit %>% arrange(rsq)

coef_df <- function(x) {
  sc <- coef(summary(x))
  colnames(sc) <- c("est", "se", "t", "P")
  data.frame(coef = rownames(sc), sc)
}
models %>% do(coef_df(.$mod))

hourly <- flights %>%
  filter(hour >= 5, hour <= 20) %>%
  group_by(date, hour) %>%
  summarise(dep_delay = mean(dep_delay))

qplot(hour, dep_delay, data = hourly %>% semi_join(fit %>% filter(rsq > 0.2)), geom = "line") + facet_wrap(~date)
qplot(hour, dep_delay, data = hourly %>% semi_join(fit %>% filter(rsq < 0.001)), geom = "line") + facet_wrap(~date)
