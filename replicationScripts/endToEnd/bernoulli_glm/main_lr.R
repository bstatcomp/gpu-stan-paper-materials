# This script sets up and runs the logistic regression illustrative example measurements.
# Note: Assuming that working dir is set to this file's location and that folder structure was preserved
library(ggplot2)
library(cmdstanr)
library("posterior")

set_cmdstan_path("~/Desktop/cmdstan")

n = 4^c(8) # no. of observations
k = 10 # no. of input variables
res_type = "bernoulli" # response type
n_reps <- 1

# Source interface to dataset generator
source("../helperScripts/simple_linear/dg_simple_linear.R")

non_glm_model <- cmdstan_model("./Stan/lr_basic.stan")
glm_model <- cmdstan_model("./Stan/lr_glm.stan")
opencl_glm_model <- cmdstan_model("./Stan/lr_glm_opencl.stan", opencl = TRUE)

models <- list(non_glm_model, glm_model, opencl_glm_model)
# models <- list(glm_model)

# List datasets
datagens <- list(d0 = dg_simple_linear(variants = expand.grid(seed = 0,           
                                                              n = n,          # no. of observations
                                                              k = k,                # no. of input variables
                                                              type = "bernoulli")))  # response type
num_chains = 1
num_cores = 1
# Run experiment
for (datagen in datagens) {
  res <- list()
  for (i in 1:nrow(datagen$variants)) {
     variant <- datagen$variants[i,]
     stan_data <- datagen$generator(variant)
     for (model in models) {
       for (j in 1:n_reps) {
         fit <- model$sample(data = stan_data, seed = 1, num_chains = num_chains, num_cores = num_cores)
         res_variant <- list(stan_file = model$stan_file(),
                             datagen = datagen$name,
                             time_in_ms = fit$time(),
                             variant = i, rep = j,
                             variant,
                             results = summarise_draws(fit$draws(),"mean"))
         res[[length(res)+1]] <- res_variant
         saveRDS(res, file = "./lr_results.rds")
      }
    }
  }
}
# res <- benchmark(models, 
#                  datagens,                            
#                  n_reps = 1,                                          # number of measurements per setting
#                  temp_dir = paste0(getwd(), "/temp/"),                # output folder for caching temp files
#                  cmdstan_param_string = get_cmdstan_param_string())


# # Save and visualize results


# g1 <- ggplot(res$all_results, aes(x = n, y = time_in_ms, colour = paste(cmdstan_dir, stan_file, sep = ";"))) + 
#   geom_point() + geom_line() + facet_wrap(.~k)
# plot(g1)
