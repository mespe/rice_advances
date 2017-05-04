## Prepares data for write-up
load("../data/all_vt_weather.Rda")

## Replace 08Y3269 with M209
all_vt_result$id[all_vt_result$id == "08Y3269"] <- "M209"

## Subset to medium grains
vars <- grepl("^M[0-9]{3}$", all_vt_result$id)

## Do not include San Joaquin sites - known to hammer with cold and
## Not managed similar to most of CA rice production
no_sj <- all_vt_result$county != "SAN JOAQUIN"
mod_data <- all_vt_result[(vars & no_sj),]

## Exclude M-401/402 and Tucker site, per conversation with Bruce
## 10 Feb 2017:
## M-401 and M-402 are often mis-managed in trials, however they are also old varieties
## Question if excluding them is not creating more issues
## not4s <- !mod_data$id %in% c("M401","M402")

## Tucker was a problematic site with high variability and low yields
notTuck <- mod_data$site != "TUCKER"

mod_data <- mod_data[(notTuck),]

## Use officially published years instead of years in trial
load("../data/yrTbl.Rda")
i <- match(mod_data$id, yrTbl$Cultivar)

mod_data$release_yr <- yrTbl$Year[i]
mod_data$release_yr_c <- mod_data$release_yr - 2000

mod_data$yrs_in_trial <- mod_data$year - mod_data$release_yr

# convert yield to kg/ha here once, rather than repeatedly in paper
mod_data$yield_kg = mod_data$yield_lb * 1.12

## Get some centered and scaled vars for model
center = 10000
scl = 1000

mod_data$yield_cs <- (mod_data$yield_kg - center) / scl
mod_data$yr_fact <- factor(mod_data$year)
mod_data$yr_site_fact <- factor(paste(mod_data$year, mod_data$site))


