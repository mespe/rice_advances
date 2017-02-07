## Prepares data for write-up

load("../data/all_vt_weather.Rda")

## Replace 08Y3269 with M209
all_vt_result$id[all_vt_result$id == "08Y3269"] <- "M209"

##fit <- read_stan_csv(list.files("~/Dropbox/vt_results", "^samples[0-9].csv",
##                                full.names = TRUE))

## Get the number of years in the trial
n_years <- aggregate(year ~ id, data = all_vt_result,
          function(x) {
              length(unique(x))})

## Subset to medium grains
vars <- grepl("^M[0-9]{3}$", all_vt_result$id)

## Do not include San Joaquin sites - known to hammer with cold and
## Not managed similar to most of CA rice production
no_sj <- all_vt_result$county != "SAN JOAQUIN"
mod_data <- all_vt_result[(vars & no_sj),]

## Use officially published years instead of years in trial
load("../data/yrTbl.Rda")
i <- match(mod_data$id, yrTbl$Cultivar)

mod_data$release_yr <- yrTbl$Year[i]
mod_data$yrs_in_trial <- mod_data$year - mod_data$release_yr

## Get some centered and scaled vars for model
mod_data$yield_cs <- (mod_data$yield - 9000) / 1000
mod_data$yr_fact <- factor(mod_data$year)
mod_data$yr_site_fact <- factor(paste(mod_data$year, mod_data$site))


