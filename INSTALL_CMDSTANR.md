## Installing and using cmdstanr with GPU support

These instructions assume that you have an NVIDIA or AMD GPU installed in your system.

### STEP 1: Install the toolchain and GPU driver

##### Ubuntu

Make sure you have `make`, `g++ 4.9.3` or higher (or `clang++ 6.0` or higher) and the `R` environment installed.
If using a NVIDIA device install the NVIDIA CUDA toolkit and clinfo tool.

```
apt update
apt install nvidia-cuda-toolkit clinfo
```

If you have an AMD GPU install the Radeon Open Computer platform (ROCm). The instructions are given [here](https://rocm-documentation.readthedocs.io/en/latest/Installation_Guide/Installation-Guide.html)

##### Windows

You need to first install R and the Rtools suite if you don't already have it. During the installation make sure that the 64-bit toolchain is installed. You also need to verify that you have the System Enviroment variable Path updated to include the path to the g++ compiler (<Rtools installation path>\mingw_64\bin).

If you have an NVIDIA device install the latest NVIDIA CUDA toolkit found on the NVIDIA support website. AMD users can use the [OCL-SDK](https://github.com/GPUOpen-LibrariesAndSDKs/OCL-SDK/releases).

### STEP 2: Install the cmdstanr R package and the latest cmdstan

Install cmdstanr by running

```
# install the pacakges required to install via Github
install.packages("remotes")
remotes::install_github("bstatcomp/cmdstanr")

# install cmdstan
library(cmdstanr)
install_cmdstan()
```

### STEP 3: Determine the IDs of your target device

In order to run any OpenCL application you need to specify the platform and device IDs of your target device. If you only have a single OpenCL-enabled device (most likely a GPU) both IDs are 0. In this case you can proceed to step 4.

If you have multiple device you first need to determine the platform and device ID of your target device. You can use the `clinfo` tool to list all OpenCL-enabled devices and their IDs. On Linux `clinfo` can be obtained using `sudo apt install clinfo` or equivalent. You can also build the tool from source that is available [here](https://github.com/Oblomov/clinfo).

Windows binaries of `clinfo` are available [here](https://github.com/Oblomov/clinfo#windows-support).

### STEP 4: Compile and run the model with GPU support

```R

library(cmdstanr)

opencl_options <- list(
  stan_opencl = TRUE,
  opencl_platform_id = 0, # replace with your ID
  opencl_device_id = 0 # replace with your ID
)
set_cmdstan_cpp_options(opencl_options)

glm_model <- cmdstan_model("./lr_glm.stan", model_name = "lr_glm_opencl")

#TODO (data)

fit <- model$sample(data = stan_data,
                             seed = 1,
                             num_chains = 1,
                             num_cores = 1,
                             num_samples = 1000,
                             num_warmup = 1000)

```
