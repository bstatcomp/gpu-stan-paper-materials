# gpu-stan-paper-materials

Replication scripts, measurement data, visualization scripts, and installation instructions for the paper "GPU-based Parallel Computation Support for Stan".

## Installing cmdstan with GPU support

### Install the toolchain and GPU driver

##### Ubuntu

If using a NVIDIA device install the NVIDIA CUDA toolkit and clinfo tool.

`apt update`
`apt install nvidia-cuda-toolkit clinfo`

If you have an AMD GPU install the OpenCL driver available here:

https://www.amd.com/en/support/kb/release-notes/rn-prorad-lin-amdgpupro

##### Windows

Install the latest Rtools suite if you don't already have it. During the installation make sure that the 64-bit toolchain is installed. You also need to verify that you have the System Enviroment variable Path updated to include the path to the g++ compiler (<Rtools installation path>\mingw_64\bin).

If you have an NVIDIA device install the latest NVIDIA CUDA toolkit found on the NVIDIA support website. AMD users should use the AMD APP SDK.

2. Clone cmdstan with the appropriate branch

The cmdstan with the experimental branch can be cloned with the following command

git clone --shallow-submodules --recursive --depth 1 -b jss_special_issue --single-branch https://github.com/bstatcomp/cmdstan.git

3. Set up cmdstan to run with OpenCL

This instruction presume that you have only 1 GPU in the system. If used on a system with multiple GPUs you need to modify the device and platform IDs. The correct IDs can be retrieved using the clinfo tool.

Create a cmdstan/make/local file. Write the following content in the file:

STAN_OPENCL=true

OPENCL_DEVICE_ID=0

OPENCL_PLATFORM_ID=0

CXXFLAGS+= -DSTAN_OPENCL_CACHE=true

On Windows add the following line if you are using NVIDIA

LDFLAGS_OPENCL= -L"$(CUDA_PATH)\lib\x64" -lOpenCL

or 

LDFLAGS_OPENCL= -L"$(AMDAPPSDKROOT)lib\x86_64" -lOpenCL

if you are using an AMD GPU. If CUDA_PATH or AMDAPPSDKROOT environment variables are not present on your system search for the OpenCL.lib file and replace the variables with the path to the OpenCL.lib file.

4. Run the tests script with `Rscript XXXXX.R`
