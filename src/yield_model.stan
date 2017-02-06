data{
  int N;
  int n_cult;
  int n_site;
  int n_year;
  int n_var;
  int<lower = 1, upper = n_cult> cult[N];
  int<lower = 1, upper = n_site> site[N];
  int<lower = 1, upper = n_year> year[N];
  vector[N] duration;
  vector[N] yield;
  
  
}

parameters{
  real alpha;
  vector[n_cult] b_cult_raw;
  vector[n_site] b_site_raw;
  vector[n_year] b_year_raw;
  real b_dur;
  vector<lower = 0>[n_var] tau;
  real<lower = 0> sigma;
}

transformed parameters{
  vector[n_cult] b_cult = b_cult_raw * tau[1];
  vector[n_site] b_site = b_site_raw * tau[2];
  vector[n_year] b_year = b_year_raw * tau[3];
}

model{
  // mu vector
  vector[N] mu = alpha +
	b_cult[cult] +
	b_site[site] +
	b_year[year] + 
	b_dur * duration;
  
  //Priors
  target += normal_lpdf(alpha | 0, 1);
  target += normal_lpdf(b_cult_raw | 0, 1);
  target += normal_lpdf(b_site_raw | 0, 1);
  target += normal_lpdf(b_year_raw | 0, 1);
  target += normal_lpdf(b_dur | 0, 1);
  target += normal_lpdf(tau | 0, 1);
  target += normal_lpdf(sigma| 0, 1);
  
  // Likelihood
  target += student_t_lpdf(yield | 5, mu, sigma);
}

generated quantities{
  vector[N] log_lik;
  for(n in 1:N)
	log_lik[n] = student_t_lpdf(yield[n] | 5,
									 alpha +
									 b_cult[cult[n]] +
									 b_site[site[n]] +
									 b_year[year[n]] + 
									 b_dur * duration[n],
									 sigma);
}
