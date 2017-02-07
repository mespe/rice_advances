data{
  int N;
  int n_cult;
  int n_site;
  int n_year;
  int n_yr_site;
  int n_var;
  int<lower = 1, upper = n_cult> cult[N];
  int<lower = 1, upper = n_site> site[N];
  int<lower = 1, upper = n_year> year[N];
  int<lower = 1, upper = n_yr_site> yr_site[N];
  vector[N] duration;
  vector[N] release_yr;
  vector[N] yield;    
}

parameters{
  real alpha;
  vector[n_cult] b_cult_raw;
  vector[n_site] b_site_raw;
  vector[n_year] b_year_raw;
  vector[n_yr_site] b_yrsite_raw;
  real<upper = 0> b_dur_shared;
  real<lower = 0> b_rel_yr;
  vector[n_cult] b_dur_raw;
  vector<lower = 0>[n_var] tau;
  real<lower = 0> sigma;
}

transformed parameters{
  vector[n_cult] b_cult = b_cult_raw * tau[1];
  vector[n_site] b_site = b_site_raw * tau[2];
  vector[n_year] b_year = b_year_raw * tau[3];
  vector[n_yr_site] b_yrsite = b_yrsite_raw * tau[4];
  vector[n_cult] b_dur = b_dur_raw * tau[5];
  vector[N] mu = alpha +
	b_cult[cult] +
	b_site[site] +
	b_year[year] +
	b_yrsite[yr_site] +
	b_rel_yr * release_yr +
	(b_dur_shared + b_dur[cult]) .* duration;
}

model{
  
  //Priors
  target += normal_lpdf(alpha | 0, 1);
  target += normal_lpdf(b_cult_raw | 0, 1);
  target += normal_lpdf(b_site_raw | 0, 1);
  target += normal_lpdf(b_year_raw | 0, 1);
  target += normal_lpdf(b_yrsite_raw | 0, 1);
  target += normal_lpdf(b_dur_raw | 0, 1);
  target += normal_lpdf(b_dur_shared | 0, 1);
  target += normal_lpdf(b_rel_yr | 0, 1);
  target += normal_lpdf(tau | 0, 1);
  target += normal_lpdf(sigma | 0, 1);
  
  // Likelihood
  target += student_t_lpdf(yield | 5, mu, sigma);
}

generated quantities{
  vector[N] log_lik;
  for(n in 1:N)
	log_lik[n] = student_t_lpdf(yield[n] | 5, mu[n], sigma);
}
