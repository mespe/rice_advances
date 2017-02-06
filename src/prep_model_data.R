## Prepares data for write-up

load("../data/all_vt_weather.Rda")
##fit <- read_stan_csv(list.files("~/Dropbox/vt_results", "^samples[0-9].csv",
##                                full.names = TRUE))

## Get the number of years in the trial
n_years <- aggregate(year ~ id, data = all_vt_result,
          function(x) {
              length(unique(x))})

first_yr <- aggregate(year ~ id, data = all_vt_result,
          min)

i <- match(all_vt_result$id, first_yr$id)
all_vt_result$first_yr <- first_yr$year[i]
all_vt_result$yrs_in_trial <- all_vt_result$year - first_yr$year[i]


## Get some centered and scaled vars for model
all_vt_result$yield_cs <- (all_vt_result$yield - 9000) / 1000
all_vt_result$yr_fact <- factor(all_vt_result$year)
all_vt_result$yr_site_fact <- factor(paste(all_vt_result$year, all_vt_result$site))

## Subset to medium grains
vars <- grepl("^M[0-9]{3}$", all_vt_result$id)
mod_data <- all_vt_result[vars,]

