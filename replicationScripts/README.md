# Replication scripts

## Cholesky measurements

1. Setup cmdstan with GPU support (see instructions [here](https://github.com/bstatcomp/gpu-stan-paper-materials/blob/master/README.md)).

2. Place the cholesky_prim_perf.cpp, cholesky_rev_perf.cpp, and cholesky_rev_grad_perf.cpp in the cmdstan folder.

3. Run the compile and run commands for each performance test:

- Run the performance tests for Eigen<double>:
  
```
g++ -std=c++1y -I ./cmdstan/stan/lib/stan_math -I ./cmdstan/stan/lib/stan_math/lib/eigen_3.3.3/ -I ./cmdstan/stan/lib/stan_math/lib/boost_1.69.0/ -I ./cmdstan/stan/lib/stan_math/lib/sundials_4.1.0/include -I ./cmdstan/stan/lib/stan_math/lib/opencl_1.2.8 -DSTAN_OPENCL=true -DOPENCL_DEVICE_ID=0 -DOPENCL_PLATFORM_ID=0 -D__CL_ENABLE_EXCEPTIONS -DCL_USE_DEPRECATED_OPENCL_1_2_APIS cholesky_prim_perf.cpp -o cholesky_prim_perf -lOpenCL
./cholesky_prim_perf
```

- Run the performance tests for Eigen<var>:
  
```
g++ -std=c++1y -I ./cmdstan/stan/lib/stan_math -I ./cmdstan/stan/lib/stan_math/lib/eigen_3.3.3/ -I ./cmdstan/stan/lib/stan_math/lib/boost_1.69.0/ -I ./cmdstan/stan/lib/stan_math/lib/sundials_4.1.0/include -I ./cmdstan/stan/lib/stan_math/lib/opencl_1.2.8 -DSTAN_OPENCL=true -DOPENCL_DEVICE_ID=0 -DOPENCL_PLATFORM_ID=0 -D__CL_ENABLE_EXCEPTIONS -DCL_USE_DEPRECATED_OPENCL_1_2_APIS cholesky_rev_perf.cpp -o cholesky_prim_perf -lOpenCL
./cholesky_rev_perf
```

- Run the performance tests for the gradient:

```
g++ -std=c++1y -I ./cmdstan/stan/lib/stan_math -I ./cmdstan/stan/lib/stan_math/lib/eigen_3.3.3/ -I ./cmdstan/stan/lib/stan_math/lib/boost_1.69.0/ -I ./cmdstan/stan/lib/stan_math/lib/sundials_4.1.0/include -I ./cmdstan/stan/lib/stan_math/lib/opencl_1.2.8 -DSTAN_OPENCL=true -DOPENCL_DEVICE_ID=0 -DOPENCL_PLATFORM_ID=0 -D__CL_ENABLE_EXCEPTIONS -DCL_USE_DEPRECATED_OPENCL_1_2_APIS cholesky_rev_grad_perf.cpp -o cholesky_rev_grad_perf -lOpenCL
./cholesky_rev_grad_per
f```

