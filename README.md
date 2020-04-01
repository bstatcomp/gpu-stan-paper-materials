# gpu-stan-paper-materials

Replication scripts, measurement data, visualization scripts, and installation instructions for the paper "GPU-based Parallel Computation Support for Stan".

The replication scripts are split in two parts: the C++ function-level measurement scripts for the Cholesky decomposition function and the end-to-end R scripts that run Stan models with generated input data.

## Cholesky decomposition C++ measurement scripts


[Link](replicationScripts/Cholesky/README.md)

Prerequisites to run: 
- C++ toolchain (make and a C++ compiler)
- GPU driver with OpenCL support
- A copy of the Stan Math library of version 3.1.1 or newer

These scripts run three time measurements on the C++ level for the Cholesky decomposition function:
- function evaluation when the input is a matrix of doubles
- function evaluation when the input is a matrix of stan::math::var
- gradient evaluation


## End-to-end tests for Stan models


[Link](replicationScripts/endToEnd/README.md)

Prerequisites to run: 
- a R enviroment and a C++ toolchain 
- GPU driver with OpenCL support
- cmdstanr R package

These scripts run three time measurements on the C++ level for the Cholesky decomposition function:
- function evaluation when the input is a matrix of doubles
- function evaluation when the input is a matrix of stan::math::var
- gradient evaluation