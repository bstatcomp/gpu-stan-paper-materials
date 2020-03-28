# This script sets up and runs the logistic regression illustrative example measurements.
library(ggplot2)
library(cmdstanr)
library("posterior")

set_cmdstan_path("~/cmdstan/")

n = c(4^c(3:9), 4^9*c(2,4,8)) # no. of observations
k = 10 # no. of input variables
res_type = "bernoulli" # response type
n_reps <- 3
num_cores <- c(1,2,4)
num_samples <- 500
num_warmup <- 500
# Source interface to dataset generator
source("../helperScripts/simple_linear/dg_simple_linear.R")

#non_glm_model <- cmdstan_model("./Stan/lr_basic.stan")
glm_model <- cmdstan_model("./Stan/lr_glm.stan")
opencl_glm_model <- cmdstan_model("./Stan/lr_glm_opencl.stan", opencl = TRUE)

# models <- list(non_glm_model, glm_model, opencl_glm_model)
models <- list(glm_model, opencl_glm_model)

# List datasets
datagens <- list(d0 = dg_simple_linear(variants = expand.grid(seed = 0,
                                                              num_cores = num_cores,
                                                              n = n,          # no. of observations
                                                              k = k,                # no. of input variables
                                                              type = res_type)))  # response type
# Run experiment
for (datagen in datagens) {
  res <- NULL
  for (i in 1:nrow(datagen$variants)) {
     variant <- datagen$variants[i,]
     print(variant)
     stan_data <- datagen$generator(variant)
     for (model in models) {
       for (j in 1:n_reps) {
         fit <- model$sample(data = stan_data, seed = 1, num_chains = variant$num_cores, num_cores = variant$num_cores, num_samples = num_samples, num_warmup = num_warmup)
         draws_mean_summary <- summarise_draws(fit$draws(),"mean")
         draws_mean <- t(draws_mean_summary[,2])
         colnames(draws_mean) <- t(draws_mean_summary[,1])
         res <- rbind(res, data.frame(stan_file = basename(model$stan_file()),
                                      total_time = fit$time()$total,
                                      variant,
                                      rep = j,
                                      draws_mean)
                      )
        saveRDS(res, file = "./lr_results.rds")
      }
    }
  }
}

# # Save and visualize results

g1 <- ggplot(res, aes(x = n, y = total_time, colour = stan_file)) +
  geom_point() + geom_line() + facet_wrap(.~k)
plot(g1)
