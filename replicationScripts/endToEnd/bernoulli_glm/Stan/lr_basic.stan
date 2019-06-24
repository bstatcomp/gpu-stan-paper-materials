data {
  int<lower=1> k;
  int<lower=0> n;
  matrix[n, k] X;
  int y[n];
}

parameters {
  vector[k] beta;
  real alpha;
}

model {
  target += bernoulli_logit_lpmf(y | X * beta + alpha);
}
