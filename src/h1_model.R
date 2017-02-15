## Run model and save output as text files
##.args = list(commandArgs(trailingOnly=TRUE))

library(rstan)
library(rstanarm)
source("prep_model_data.R")

## mm <- stan_model(file = "yield_model.stan", verbose = TRUE)

## n.level <- function(x){
##     length(unique(x))
##     }
## to.idx <- function(x){
##     as.integer(factor(x))
##     }

## Pull M401, M402 - remove Tucker 2015
## look at only RES vs.  
## M202 vs M206 vs. M209

## dd <- list(N = nrow(mod_data),
##            n_cult = n.level(mod_data$id),
##            n_site = n.level(mod_data$site),
##            n_year = n.level(mod_data$year),
##            n_yr_site = n.level(mod_data$yr_site_fact),
##            n_var = 4L,
##            cult = to.idx(mod_data$id),
##            site = to.idx(mod_data$site),
##            year = to.idx(mod_data$year),
##            yr_site = to.idx(mod_data$yr_site_fact),
##            yield = mod_data$yield_cs)

## Rprof("mod.Rprof")
## yrs_fit <- sampling(mm, data = c(dd, list(x = mod_data$yrs_in_trial)),
##                     iter = 500, cores = 2L, control = list(adapt_delta = 0.9))
## release_fit <- sampling(mm, data = c(dd, list(x = mod_data$release_yr - 2000)),
##                     iter = 500, cores = 2L, control = list(adapt_delta = 0.9))

yrs_fit <- stan_glmer(yield_cs ~ (1|year) + (1|site) + (1|id) +
                          (1|yr_site_fact) + yrs_in_trial,
                      data = mod_data, iter = 1000, cores = 2L)

release_fit <- stan_glmer(yield_cs ~ (1|year) + (1|site) +
                              (1|id) + (1|yr_site_fact) + release_yr_c,
                          data = mod_data, iter = 1000, cores = 2L)

i <- mod_data$site == "RES"

RES_yrs_fit <- stan_glmer(yield_cs ~ (1|year) + (1|id) + yrs_in_trial,
                          data = mod_data[i,], iter = 1000, cores = 2L)

RES_rel_fit <- stan_glmer(yield_cs ~ (1|year) + (1|id) + release_yr_c,
                          data = mod_data[i,], iter = 1000, cores = 2L)


save(yrs_fit, release_fit, RES_yrs_fit, RES_rel_fit, file = "../output/h1_fit.Rda")
