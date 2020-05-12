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

In order to make sure both `mingw32-make` and `g++` are installed, try out the `mingw32-make --version` and `g++ --version` commands.

If you have an NVIDIA device install the latest NVIDIA CUDA toolkit found [here](https://developer.nvidia.com/cuda-toolkit). AMD users can use the [OCL-SDK](https://github.com/GPUOpen-LibrariesAndSDKs/OCL-SDK/releases).

### STEP 2: Determine the IDs of your target device

In order to run any OpenCL application you need to specify the platform and device IDs of your target device. If you only have a single OpenCL-enabled device (most likely a GPU) both IDs are 0. In this case you can proceed to step 4.

If you have installed OpenCL runtimes (drivers) for multiple GPUs or have previously installed the OpenCL runtime for your CPU, you first need to determine the platform and device ID of your target device. You can use the `clinfo` tool to list all OpenCL-enabled devices and their IDs. On Linux `clinfo` can be obtained using `sudo apt install clinfo` or equivalent using `yum`. You can also build the tool from source which is available at [here](https://github.com/Oblomov/clinfo).

Windows binaries of `clinfo` are available [here](https://github.com/Oblomov/clinfo#windows-support).

### STEP 3: Install and configure cmdstan 

Download the latest release of cmdstan from [here](https://github.com/stan-dev/cmdstan/releases/tag/v2.23.0). Download and untar the .tar.gz file.

Create a file named `local` inside the `make` folder and populate it with the following:

```
STAN_OPENCL=true
OPENCL_PLATFORM_ID=#PLATFORM_ID
OPENCL_DEVICE_ID=#DEVICE_ID
```
where you replace #PLATFORM_ID and #DEVICE_ID with the IDs from step 2.

On Windows you also need to specify the path to the OpenCL.lib file by adding the following (replace $(PATH) with the actual path to the file):
```
LDFLAGS_OPENCL= -L$(PATH) -lOpenCL
```

If you are using and AMD GPU with the OCL SDK suggested in step 1 the LDFLAGS_OPENCL will typically be:
```
LDFLAGS_OPENCL= -L"C:/Program Files (x86)/OCL_SDK_Light/lib/x86_64" -lOpenCL
```

If using and NVIDIA GPU then a typical LDFLAGS_OPENCL will be (depending on the installed version):
```
LDFLAGS_OPENCL= -L"C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v10.2/lib/x64" -lOpenCL
```

### STEP 4: Build cmdstan

On Linux run `make build`. On Windows run `mingw32-make build`. If you have multiple cores available you can also use the `-j` flag to specify building with multiple cores. Example `make build -j 4` or `mingw32-make build -j 4` will use 4 cores to build cmdstan.

### STEP 5: Compile and run the supplied logistic regression model

##### Linux

First generate the input data for the logistic regression model. You can do that by running 
```R
Rscript generate_glm_data.R
```
in the `lr_glm` folder. The script requires the `jsonlite` package that can be installed by running `install.packages("jsonlite")`.

If you place the `lr_glm` folder in the home (`~`) folder compile from the cmdstan folder with
```
make ~/lr_glm/lr_glm
```
and start sampling with
```
./lr_glm sample num_samples=500 num_warmup=500 random seed=1 data file=lr_glm.data.json
```

##### Windows

First generate the input data for the logistic regression model. You can do that by running 
```R
Rscript.exe generate_glm_data.R
```
in the `lr_glm` folder. The script requires the `jsonlite` package that can be installed by running `install.packages("jsonlite")`.

If you place the `lr_glm` folder in the home (`~`) folder compile from the cmdstan folder 
```
mingw32-make ~/lr_glm/lr_glm.exe
```
and start sampling with:
```
~/lr_glm/lr_glm.exe sample num_samples=500 num_warmup=500 random seed=1 data file=~/lr_glm/lr_glm.data.json
```
