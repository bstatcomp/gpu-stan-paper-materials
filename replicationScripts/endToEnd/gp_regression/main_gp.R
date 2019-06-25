# This script sets up and runs the GP regression illustrative example measurements.
# Note: Assuming that working dir is set to this file's location and that folder structure was preserved
library(ggplot2)

path_to_cmdstan <- "d:/work/cmdstan/"

# Source interface to cmdstan and dataset generator
source("../helperScripts/performance.R")
source("../helperScripts/datagen/1D_nonlinear/dg_1D_nonlinear.R")

# List models and cmdstan version to use
models   <- list(m1 = create_model("./Stan/GP.Stan", cmdstan_dir = path_to_cmdstan))

# List datasets
datagens <- list(d0 = dg_1D_nonlinear(variants = expand.grid(seed = 0, 
                                                             n = c(32, 64, 128, 256))))
# Run experiment
res <- benchmark(models, 
                 datagens,                            
                 n_reps = 1,                                           # number of measurements per setting
                 temp_dir = paste0(getwd(), "/temp/"),                # output folder for caching temp files
                 cmdstan_param_string = get_cmdstan_param_string())

# Save and visualize results
print(res$all_results)
saveRDS(res, file = "./GP_results.rds")

g1 <- ggplot(res$all_results, aes(x = n, y = time_in_ms, colour = paste(cmdstan_dir, stan_file, sep = "; "))) + 
  geom_point() + geom_line()
plot(g1)

