# This script sets up and runs the logistic regression illustrative example measurements.
# Note: Assuming that working dir is set to this file's location and that folder structure was preserved
library(ggplot2)

path_to_cmdstan <- "d:/work/cmdstan/"

# Source interface to cmdstan and dataset generator
source("../helperScripts//performance.R")
source("../helperScripts//datagen/simple_linear/dg_simple_linear.R")

# List models and cmdstan version to use
models   <- list(m1 = create_model("./stan/lr_basic.stan", cmdstan_dir = path_to_cmdstan), # without GLM primitive
                 m2 = create_model("./stan/lr_glm.stan", cmdstan_dir = path_to_cmdstan))   # with GLM primitive

# List datasets
datagens <- list(d0 = dg_simple_linear(variants = expand.grid(seed = 0,           
                                                              n = 4^c(3:8),          # no. of observations
                                                              k = 10,                # no. of input variables
                                                              type = "bernoulli")))  # response type
# Run experiment
res <- benchmark(models, 
                 datagens,                            
                 n_reps = 1,                                          # number of measurements per setting
                 temp_dir = paste0(getwd(), "/temp/"),                # output folder for caching temp files
                 cmdstan_param_string = get_cmdstan_param_string())


# Save and visualize results
print(res$all_results)
saveRDS(res, file = "./lr_results.rds")

g1 <- ggplot(res$all_results, aes(x = n, y = time_in_ms, colour = paste(cmdstan_dir, stan_file, sep = ";"))) + 
  geom_point() + geom_line() + facet_wrap(.~k)
plot(g1)
