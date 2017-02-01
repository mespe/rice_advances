## EDA on VT data
## M. Espe
## Jan 2017

## Cleaned data from the other project
load("../data/all_vt_weather.Rda")

## Look at varieties over time
n_years <- aggregate(year ~ id, data = all_vt_result,
          function(x) {
              length(unique(x))})

first_yr <- aggregate(year ~ id, data = all_vt_result,
          min)

i <- match(all_vt_result$id, first_yr$id)
all_vt_result$first_yr <- first_yr$year[i]
all_vt_result$yrs_in_trial <- all_vt_result$year - first_yr$year[i]

j <- n_years$year >= 7

long_ids <- all_vt_result$id %in% n_years$id[j]

## Look by varieties
vt_split <- split(all_vt_result[long_ids,], all_vt_result$id[long_ids])

par(mfrow = c(5, 5))
sapply(vt_split, function(x){
    plot(x$yield_lb ~ x$year,
         xlim = c(1995, 2015),
         main = unique(x$id))
    abline(lm(x$yield_lb ~ x$year))
})

library(ggplot2)
ggplot(data = all_vt_result[long_ids,],
       aes(x = yrs_in_trial, y = yield_lb, group = id)) +
    geom_point(aes(color = id)) +
    geom_smooth(method = lm, aes(color = id)) +
    facet_wrap(~id) +
    theme_bw()

ggplot(data = all_vt_result[long_ids,],
       aes(x = yrs_in_trial, y = yield_lb, group = id)) +
    geom_point(aes(color = id)) +
    geom_smooth(method = lm, aes(color = id)) +
    facet_wrap(~id) +
    theme_bw()

library(rstanarm)
options(mc.cores = 2L)
fit <- stan_glmer(scale(yield_lb) ~ yrs_in_trial + (1 + yrs_in_trial|id),
                  data = all_vt_result[long_ids,],
                  prior = normal(), iter = 500)

## Look at side by side differences

fit <- stan_glmer(scale(yield_lb) ~ 
    
