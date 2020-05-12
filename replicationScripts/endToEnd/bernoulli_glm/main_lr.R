# This script sets up and runs the logistic regression illustrative example measurements.
library(ggplot2)
library(cmdstanr)
library("posterior")

n = 200000
k = 500 # no. of input variables
num_chains <- c(1,2,4) # number of chains
n_reps <- 3 # no. of repeats for each input size

# sampling settings
num_samples <- 500
num_warmup <- 500

res_type = "bernoulli" # response type

source("../system_settings.R")

# Source interface to dataset generator
source("../helperScripts/simple_linear/dg_simple_linear.R")

# if (end_to_end_tests_settings$run_cpu) {
#   set_cmdstan_cpp_options(list()) # clear all cmdstan options to compile the CPU model
#   glm_model <- cmdstan_model("./lr_glm.stan")
# } else {
#   glm_model <- NULL
# }

# opencl_options <- list(
#   stan_opencl = TRUE,
#   opencl_platform_id = end_to_end_tests_settings$opencl_platform_id,
#   opencl_device_id = end_to_end_tests_settings$opencl_device_id
# )
# if (isTRUE(.Platform$OS.type == "windows")) {
#   opencl_options$ldflags_opencl = paste0("-L","\"", end_to_end_tests_settings$opencl_device_id, "\""," -lOpenCL")
# }

# set_cmdstan_cpp_options(opencl_options)
# opencl_glm_model <- cmdstan_model("./lr_glm.stan", model_name = "lr_glm_opencl", stanc_options = list("use-opencl"=TRUE), quiet = FALSE, force_recompile=TRUE)
#
# models <- c(glm_model, opencl_glm_model)
glm_model <- cmdstan_model("./lr_glm.stan")

# List datasets
datagens <- list(d0 = dg_simple_linear(variants = expand.grid(seed = 0,
                                                              num_chains = num_chains,
                                                              n = n,          # no. of observations
                                                              k = k,                # no. of input variables
                                                              type = res_type)))  # response type
stan_data <- datagens$d0$generator(datagens$d0$variants[1,])
write_stan_json(stan_data, file = "lr_glm.data.json")
# Run experiment
# for (datagen in datagens) {
#   res <- NULL
#   for (i in 1:nrow(datagen$variants)) {
#      variant <- datagen$variants[i,]
#      print(variant)
#      stan_data <- datagen$generator(variant)
#      for (model in models) {
#        for (j in 1:n_reps) {
#          fit <- model$sample(data = stan_data,
#                              seed = 1,
#                              num_chains = variant$num_chains,
#                              num_cores = variant$num_chains,
#                              num_samples = num_samples,
#                              num_warmup = num_warmup)
#          num_params <- dim(fit$draws())[[3]]
#          draws_mean_summary <- summarise_draws(fit$draws(),"mean")[1:min(num_params,10),]
#          draws_mean <- t(draws_mean_summary[,2])
#          colnames(draws_mean) <- t(draws_mean_summary[,1])
#          res <- rbind(res, data.frame(model_name = model$model_name(),
#                                       total_time = fit$time()$total,
#                                       variant,
#                                       rep = j,
#                                       draws_mean)
#                       )
#         saveRDS(res, file = "./lr_results.rds")
#       }
#     }
#   }
# }
#
# # Save and visualize results
#
# g1 <- ggplot(res, aes(x = n, y = total_time, colour = model_name)) +
#   geom_point() + geom_line() + facet_wrap(.~k)
# plot(g1)
