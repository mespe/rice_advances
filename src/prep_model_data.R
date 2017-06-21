## Prepares data for write-up
load("../data/all_w_2016.Rda")

# Replace "-" in variety names
all_vt_result$id = gsub("M-", "M", all_vt_result$id)

## Replace 08Y3269 with M209
all_vt_result$id[all_vt_result$id == "08Y3269"] <- "M209"

## Merge with pre95 data
source("../src/munge_pre95.R")

## Subset to medium grains
vars <- grepl("^M[0-9]{3}$", all_data$id)

mod_data <- all_data[vars,]

# To simplify model interpretation, only analyze RES
# since this is the best managed site
# with the most data

mod_data = mod_data[mod_data$site == "RES",]

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

save(mod_data, scl, center, file = "../data/model_data.rda")

################################################################################
