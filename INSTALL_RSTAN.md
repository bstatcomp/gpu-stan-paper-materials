## Installing cmdstan with GPU support

These instructions assume that you have an NVIDIA or AMD GPU in your system. While modern Intel GPUs support OpenCL, their double-precision performance is unlikely to bring speedup compared to a modern CPU. For that reason, instructions for Intel GPUs are currently not present.

### STEP 1: Install the toolchain and GPU driver

##### Ubuntu

Make sure you have `make`, `g++ 4.9.3` or higher (or `clang++ 6.0` or higher).
If using a NVIDIA device install the NVIDIA CUDA toolkit and clinfo tool.

```
apt update
apt install nvidia-cuda-toolkit clinfo
```

If you have an AMD GPU install the Radeon Open Computer platform (ROCm). The instructions are given [here](https://rocm-documentation.readthedocs.io/en/latest/Installation_Guide/Installation-Guide.html)

##### Windows

Make sure you have `mingw32-make` and `g++ 4.9.3` or higher. You can install both as part of Rtools 4.0 suite if you don't already have them. During the installation make sure that the 64-bit toolchain is installed. Upon installing RTools 4.0, open the RTools bash and enter `pacman -Sy mingw-w64-x86_64-make`. This will install `mingw32-make`. Add `C:\RTools40\usr\bin` and `C:\RTools40\mingw64\bin` to the PATH environment variable if they are not added automatically.

In order to make sure both `mingw32-make` and `g++` are installed, try out the `mingw32-make.exe --version` and `g++ --version` commands.

If you have an NVIDIA device install the latest NVIDIA CUDA toolkit found [here](https://developer.nvidia.com/cuda-toolkit). AMD users can use the [OCL-SDK](https://github.com/GPUOpen-LibrariesAndSDKs/OCL-SDK/releases).

### STEP 2: Determine the IDs of your target device

In order to run any OpenCL application you need to specify the platform and device IDs of your target device. If you only have a single OpenCL-enabled device (most likely a GPU) both IDs are 0. In this case you can proceed to step 4.

If you have installed OpenCL runtimes (drivers) for multiple GPUs or have previously installed the OpenCL runtime for your CPU, you first need to determine the platform and device ID of your target device. You can use the `clinfo` tool to list all OpenCL-enabled devices and their IDs. On Linux `clinfo` can be obtained using `sudo apt install clinfo` or equivalent using `yum`. You can also build the tool from source which is available at [here](https://github.com/Oblomov/clinfo).

Windows binaries of `clinfo` are available [here](https://github.com/Oblomov/clinfo#windows-support).

On Windows also identify the location of the `OpenCL.lib` file.


### STEP 2: Install the rstan R package

Install rstan by running

```R
install.packages("rstan")
```

### STEP 3: Determine the IDs of your target device

In order to run any OpenCL application you need to specify the platform and device IDs of your target device. If you only have a single OpenCL-enabled device (most likely a GPU) both IDs are 0. In this case you can proceed to step 4.

If you have multiple device you first need to determine the platform and device ID of your target device. You can use the `clinfo` tool to list all OpenCL-enabled devices and their IDs. On Linux `clinfo` can be obtained using `sudo apt install clinfo` or equivalent. You can also build the tool from source that is available [here](https://github.com/Oblomov/clinfo).

Windows binaries of `clinfo` are available [here](https://github.com/Oblomov/clinfo#windows-support).

### STEP 4: Setup compiler flags

Place the following in the `.Rmakevars` file:

```
STAN_OPENCL=true
OPENCL_PLATFORM_ID=#PLATFORM_ID
OPENCL_DEVICE_ID=#DEVICE_ID
```
where you replace #PLATFORM_ID and #DEVICE_ID with the IDs from step 2.

On Windows you also need to specify the path to the OpenCL.lib file by adding the following (replace $(PATH) with the actual path):

```
LDFLAGS_OPENCL= -L$(PATH) -lOpenCL"
```

### STEP 5: Compile and run the model with GPU support

```R

library(rstan)

gp_model <- stan_model("gp.stan")


```
