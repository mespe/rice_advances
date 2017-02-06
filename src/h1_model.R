## Run model and save output as text files
##.args = list(commandArgs(trailingOnly=TRUE))

library(rstanarm)
source("prep_model_data.R")

mod <- stan_glmer(yield_cs ~ (1|yr_fact) + (1|site) + (1|yr_site_fact) +
                      yrs_in_trial + yrs_in_trial:id,
                  data = mod_data, prior = normal(), cores = 2L, iter = 2000,## ... = .args
                  )

save(mod, file = "../output/h1_fit.Rda")
