## Run model and save output as text files
##.args = list(commandArgs(trailingOnly=TRUE))

library(rstan)
library(rstanarm)
source("prep_model_data.R")

mm <- stan_model(file = "yield_model.stan", verbose = TRUE)

n.level <- function(x){
    length(unique(x))
    }
to.idx <- function(x){
    as.integer(factor(x))
    }

dd <- list(N = nrow(mod_data),
           n_cult = n.level(mod_data$id),
           n_site = n.level(mod_data$site),
           n_year = n.level(mod_data$year),
           n_yr_site = n.level(mod_data$yr_site_fact),
           n_var = 5L,
           cult = to.idx(mod_data$id),
           site = to.idx(mod_data$site),
           year = to.idx(mod_data$year),
           yr_site = to.idx(mod_data$yr_site_fact),
           duration = mod_data$yrs_in_trial,
           release_yr = mod_data$release_yr - 2000,
           yield = mod_data$yield_cs)

## Rprof("mod.Rprof")
fit <- sampling(mm, data = dd, iter = 100, cores = 1L, control = list(adapt_delta = 0.9))
## Rprof(NULL)

fit <- stan_glmer(yield_cs ~ (1|year) + (1|site) + (1|id) + (1|yr_site_fact) + yrs_in_trial,
                  data = mod_data, iter = 1000, cores = 2L)

fit2 <- stan_glmer(yield_cs ~ (1|year) + (1|site) + (1|id) + (1|yr_site_fact) + release_yr,
                  data = mod_data, iter = 1000, cores = 2L)


save(fit, file = "../output/h1_fit.Rda")
