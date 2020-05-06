## Installing cmdstan with GPU support

These instructions assume that you have an NVIDIA or AMD GPU in your system.

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

Make sure you have `mingw32-make` and `g++ 4.9.3` or higher. You can install both as part of Rtools 4.0 suite if you don't already have them. During the installation make sure that the 64-bit toolchain is installed. Upon installing RTools 4.0 open the RTools bash and enter `pacman -Sy mingw-w64-x86_64-make`. This will install `mingw32-make`. Make sure `C:\RTools40\usr\bin` and `C:\RTools40\mingw64\bin` are added to the PATH environment variable.

If you have an NVIDIA device install the latest NVIDIA CUDA toolkit found on the NVIDIA support website. AMD users can use the [OCL-SDK](https://github.com/GPUOpen-LibrariesAndSDKs/OCL-SDK/releases).

### STEP 2: Determine the IDs of your target device

In order to run any OpenCL application you need to specify the platform and device IDs of your target device. If you only have a single OpenCL-enabled device (most likely a GPU) both IDs are 0. In this case you can proceed to step 4.

If you have multiple device you first need to determine the platform and device ID of your target device. You can use the `clinfo` tool to list all OpenCL-enabled devices and their IDs. On Linux `clinfo` can be obtained using `sudo apt install clinfo` or equivalent. You can also build the tool from source that is available [here](https://github.com/Oblomov/clinfo).

Windows binaries of `clinfo` are available [here](https://github.com/Oblomov/clinfo#windows-support).

### STEP 3: Install cmdstan and configure

Download the latest relese of cmdstan from [here](https://github.com/stan-dev/cmdstan/releases/tag/v2.23.0). Download and untar the .tar.gz file.

Create a file named `local` inside the `make` folder and populate it with the following:

```
STAN_OPENCL=true
OPENCL_PLATFORM_ID= #
OPENCL_DEVICE_ID= #
```
where you replace # with the IDs from step 2.

On Windows you also need to specify the path to the OpenCL.lib file by adding the following (replace $(PATH) with the actual path):

```
LDLFLAGS_OPENCL= -L$(PATH) -lOpenCL"
```

### STEP 4: Build cmdstan

On Linux run `make build`. On Windows run `mingw32-make build`.

### STEP 5: Compile and run your model

Compile the bernoulli_glm example with 

`make lr_glm` or `mingw32-make lr_glm.exe` on Windows. 

TODO(sample data)