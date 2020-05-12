library(cmdstanr)

data_path <- "./lr_glm.data.json"
model_path <- "./lr_glm.stan"

opencl_options = list(
  stan_opencl = TRUE,
  opencl_platform_id = 0, # replace the ID based on step 3
  opencl_device_id = 0 # replace the ID based on step 3
)

mod <- cmdstan_model(model_path, exe_file = "lr_glm_opencl", cpp_options = opencl_options, quiet = FALSE)

fit <- mod$sample(data = data_path, num_samples=500, num_warmup = 500, num_chains = 1, num_cores = 1)

print(fit$summary())