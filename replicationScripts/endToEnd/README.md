## Installing cmdstan with GPU support

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
install.packages(c("devtools", "jsonlite"))
devtools::install_github("bstatcomp/cmdstanr")

# install cmdstan
library(cmdstanr)
install_cmdstan(repo_clone = TRUE)
```

### STEP 3: Determine the IDs of your target device

In order to run any OpenCL application you need to specify the platform and device IDs of your target device. If you only have a single OpenCL-enabled device (most likely a GPU) both IDs are 0. In this case you can proceed to step 4.

If you have multiple device you first need to determine the platform and device ID of your target device. You can use the `clinfo` tool to list all OpenCL-enabled devices and their IDs. On Linux `clinfo` can be obtained using `sudo apt install clinfo` or equivalent. You can also build the tool from source that is available [here](https://github.com/Oblomov/clinfo).

Windows binaries of `clinfo` are available [here](https://github.com/Oblomov/clinfo#windows-support).

### STEP 4: Edit the settings file for end-to-end tests

Edit `replicationScripts/endToEnd/system_settings.R` with the settings that match your system: platform and device ID and the path to the OpenCL.lib file (required on Windows systems only).

Example:
```R
end_to_end_tests_settings <- list(
    run_cpu = TRUE,
    opencl_platform_id = 0,
    opencl_device_id = 0,
    # leave empty on Unix systems
    opencl_lib_path = "C:/Program Files/OCL_SDK_Light/lib/x86_64"
)
```

### STEP 6: Run the end-to-end scripts

Source the [Bernoulli linear regression](bernoulli_glm/main_lr.R) or [Gaussian Process](bernoulli_glm/main_lr.R)) replication R scripts.