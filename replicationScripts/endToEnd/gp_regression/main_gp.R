# This script sets up and runs the GP regression illustrative example measurements.
# Note: Assuming that working dir is set to this file's location and that folder structure was preserved
# This script sets up and runs the logistic regression illustrative example measurements.
library(ggplot2)
library(cmdstanr)
library("posterior")

n = c(16, 32, 64, 128, 256, 512, 1024, 2048)
num_chains <- c(2,4) # number of chains
n_reps <- 3 # no. of repeats for each input size

# sampling settings
num_samples <- 200
num_warmup <- 200

source("../system_settings.R")

# Source interface to cmdstan and dataset generator
source("../helperScripts/1D_nonlinear/dg_1D_nonlinear.R")

if (end_to_end_tests_settings$run_cpu) {
  set_cmdstan_cpp_options(list()) # clear all cmdstan options to compile the CPU model
  cpu_model <- cmdstan_model("GP.stan")
  models <- c(cpu_model)
} else {
  cpu_model <- NULL
}

opencl_options <- list(
  stan_opencl = TRUE,
  opencl_platform_id = end_to_end_tests_settings$opencl_platform_id,
  opencl_device_id = end_to_end_tests_settings$opencl_device_id
)
if (isTRUE(.Platform$OS.type == "windows")) {
  opencl_options$ldflags_opencl = paste0("-L","\"", end_to_end_tests_settings$opencl_lib_path, "\""," -lOpenCL")
}

set_cmdstan_cpp_options(opencl_options)
opencl_model <- cmdstan_model("GP.stan", model_name = "gp_opencl", stanc_options = list("use-opencl"=TRUE), force_recompile=TRUE)

models <- c(cpu_model, opencl_model)

# List datasets
datagens <- list(d0 = dg_1D_nonlinear(variants = expand.grid(seed = 0,
                                                             n = n,
                                                             num_chains = num_chains)))

for (datagen in datagens) {
  res <- NULL
  for (i in 1:nrow(datagen$variants)) {
     variant <- datagen$variants[i,]
     print(variant)
     stan_data <- datagen$generator(variant)
     for (model in models) {
       for (j in 1:n_reps) {
         fit <- model$sample(data = stan_data,
                             seed = 1,
                             num_chains = variant$num_chains,
                             num_cores = variant$num_chains,
                             num_samples = num_samples,
                             num_warmup = num_warmup)
         num_params <- dim(fit$draws())[[3]]
         draws_mean_summary <- summarise_draws(fit$draws(),"mean")[1:min(num_params,10),]
         draws_mean <- t(draws_mean_summary[,2])
         colnames(draws_mean) <- t(draws_mean_summary[,1])
         res <- rbind(res, data.frame(model_name = model$model_name(),
                                      total_time = fit$time()$total,
                                      variant,
                                      rep = j,
                                      draws_mean)
                      )
        saveRDS(res, file = "./gp_results.rds")
      }
    }
  }
}

g1 <- ggplot(res$all_results, aes(x = n, y = time_in_ms, colour = paste(cmdstan_dir, stan_file, sep = "; "))) +
  geom_point() + geom_line()
plot(g1)

