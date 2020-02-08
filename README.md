# gpu-stan-paper-materials

TODO(Rok): New title
Replication scripts, measurement data, visualization scripts, and installation instructions for the paper "GPU-based Parallel Computation Support for Stan".

## Installing cmdstan with GPU support

These instructions assume that you have an NVIDIA or AMD GPU installed in your system.

### STEP 1: Install the toolchain and GPU driver

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

### STEP 2: Setup cmdstanr and install cmdstan 2.22.1


### STEP 3: Determine the ID of your target device

In order to run any OpenCL application you need to specify the platform and device ID of your target device. If you only have a single OpenCL-enabled device both IDs are 0. In this case you can proceed to the next step.

If you have multiple device you first need to determine the platform and device ID of your target device. You can use the `clinfo` tool to list all OpenCL-enabled devices and their IDs. On Linux `clinfo` can be obtained using `sudo apt install clinfo` or equivalent. You can also build the tool from source that is available [here](https://github.com/Oblomov/clinfo).

Windows binaries of `clinfo` are available [here](https://github.com/Oblomov/clinfo#windows-support).

#### Windows

If you only have a single GPU and no CPU OpenCL installation, you can proceed to the next step. Note that the OpenCL platform and device IDs are 0 as you only have a single OpenCL-enabled device.

If you have multiple device you need to determine the platform and device ID of your target device. You can use the `clinfo` tool to list all OpenCL-enabled devices and their. On Ubuntu `lclinfo` can be obtained using `sudo apt install clinfo`. 

### STEP 4: (Windows only) Specify the location of the OpenCL library

### STEP 5: Use OpenCL-enabled cmdstanr for your models or run the replication scripts

### STEP 6: Run the end-to-end scripts

