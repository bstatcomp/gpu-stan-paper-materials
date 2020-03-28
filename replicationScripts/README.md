# Replication scripts

## End-to-end measurements


## Cholesky decomposition C++ performance measurements

### STEP 1: Install the toolchain and GPU driver

In order to run the performance tests you need to have a proper toolchain and OpenCL-enabled GPU driver installed. 

##### Ubuntu

If using a NVIDIA device install the NVIDIA CUDA toolkit and clinfo tool.

```
apt update
apt install nvidia-cuda-toolkit clinfo
```

If you have an AMD GPU install the OpenCL driver available here:

https://www.amd.com/en/support/kb/release-notes/rn-prorad-lin-amdgpupro

##### Windows

Install the latest Rtools suite if you don't already have it. During the installation make sure that the 64-bit toolchain is installed. You also need to verify that you have the System Enviroment variable Path updated to include the path to the g++ compiler (<Rtools installation path>\mingw_64\bin).

If you have an NVIDIA device install the latest NVIDIA CUDA toolkit found on the NVIDIA support website. AMD users should use the AMD APP SDK.

### STEP 2: Prepare Stan Math 3.1.1

Download the Stan Math 3.1.1 [release archive](https://github.com/stan-dev/math/releases/tag/v3.1.1) and unzip/untar it. Further instructions label the installation folder of Stan Math as `$(STAN_MATH_PATH)`. Replace the label with the actual path on your system.

### STEP 3: Enable OpenCL in Stan Math

Enable OpenCL in Stan Math. Create a file named `local` in  `$(STAN_MATH_PATH)/make/`. Add the following lines to the created files:

```
STAN_OPENCL=true
OPENCL_DEVICE_ID=0
OPENCL_PLATFORM_ID=0
```

In the unlikely case that your system has more than one OpenCL-enabled device use the `clinfo` tool to determine the actual IDs and replace the zeros in the `make/local` file. On Linux `clinfo` can be obtained using `sudo apt install clinfo` or equivalent. You can also build the tool from source that is available [here](https://github.com/Oblomov/clinfo).

Windows binaries of `clinfo` are available [here](https://github.com/Oblomov/clinfo#windows-support).

TODO(Rok): supply typical paths for Nvidia and AMD

On Windows you need to add an additional line that links the OpenCL library. First locate the the OpenCL.lib file and then add the following line, where you replace `$(OPENCL_LIB_PATH)` with the actual path to the OpenCL.lib file:

```
LDFLAGS_OPENCL= -L"$(OPENCL_LIB_PATH)/" -lOpenCL
```

### STEP 4: Build performance tests

First build the Math library dependencies using
```
make -f $(STAN_MATH_PATH)/make/standalone math-libs
```
Move to the `replicationScripts/Cholesky` folder and build the performance tests
```
make -f $(STAN_MATH_PATH)/make/standalone cholesky_prim_perf cholesky_rev_perf cholesky_rev_grad_perf
```

On Windows use `mingw32-make` instead of `make`. `mingw32-make` is part of RTools for Windows.

### STEP 4: Run performances tests

Run the performance tests for Eigen<double> by running `./cholesky_prim_perf`, performance tests for Eigen<var> by running `./cholesky_rev_perf` and for the gradients using by running `./cholesky_rev_grad_perf`.