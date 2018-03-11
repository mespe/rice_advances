## Run model and save output as text files
##.args = list(commandArgs(trailingOnly=TRUE))

# Set to TRUE to compare between models
compare = TRUE

library(rstan)
library(rstanarm)

# source("prep_model_data.R")
load("../data/model_data.rda")

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

# yrs_fit <- stan_glmer(yield_cs ~ (1|year) + (1|site) + (1|id) +
#                           (1|yr_site_fact) + yrs_in_trial,
#                       data = mod_data, iter = 1000, cores = 2L)

# release_fit <- stan_glmer(yield_cs ~ (1|year) + (1|site) +
#                               (1|id) + (1|yr_site_fact) + release_yr_c,
#                           data = mod_data, iter = 1000, cores = 2L)


RES_fullest = stan_glmer(yield_cs ~ (1|year) + (1|id) +
                             (1|id:year)+ release_yr_c + yrs_in_trial,
                         data = mod_data, iter = 2000, cores = 2L,
                         seed = 789)

if(compare){

    RES_full = stan_glmer(yield_cs ~ (1|year) + (1|id) + release_yr_c + yrs_in_trial,
                          data = mod_data, iter = 2000, cores = 2L,
                          seed = 789)
    
    RES_yrs_fit <- stan_glmer(yield_cs ~ (1|year) + (1|id) +  (1|id:year) + yrs_in_trial,
                              data = mod_data, iter = 2000, cores = 2L,
                              seed = 789)

    RES_rel_fit <- stan_glmer(yield_cs ~ (1|year) + (1|id) +  (1|id:year) + release_yr_c,
                              data = mod_data, iter = 2000, cores = 2L,
                              seed = 789)

    library(loo)
    compare(loo(RES_fullest), loo(RES_yrs_fit), loo(RES_rel_fit))
    save(RES_yrs_fit, RES_rel_fit, file = "../output/bivar_fit.Rda")
    # Add random slopes for ID
    RES_fuller = stan_glmer(yield_cs ~ (1|year) + (1 + yrs_in_trial|id) +
                                 (1|id:year) + release_yr_c + yrs_in_trial,
                      data = mod_data, iter = 2000, cores = 2L,
                      seed = 789)

    compare(loo(RES_fullest), loo(RES_yrs_fit), loo(RES_rel_fit), loo(RES_fuller))

# 10 Mar 2018 
# fuller and fullest are mis-labels,
# as fullest has fewer p than fuller but not going to change to avoid causing issues
#                  looic   se_looic elpd_loo se_elpd_loo p_loo   se_p_loo
# loo(RES_fullest)  4300.7    60.5  -2150.4     30.2       144.4     6.1 
# loo(RES_fuller)   4303.2    60.5  -2151.6     30.2       146.5     6.2 
# loo(RES_yrs_fit)  4303.2    60.6  -2151.6     30.3       145.4     6.1 
# loo(RES_rel_fit)  4451.4    64.1  -2225.7     32.1        47.5     2.5 

    RES_fullest = stan_glmer(yield_cs ~ (1|year) + (1|id) +
                                 (1|id:year)+ release_yr_c + yrs_in_trial,
                      data = mod_data, iter = 2000, cores = 2L,
                      seed = 789)

    compare(loo(RES_full), loo(RES_fullest))
}

save(RES_full, file = "../output/h1_fit.Rda")
save(RES_fullest, file = "../output/h1_fit_revised.Rda")
