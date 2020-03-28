#include <stan/math/rev.hpp>
#include <iostream>
#include <chrono>

#define NUM_OF_ITERATIONS 9
//#define CPU 1
const int R = -1;
const int C = -1;
void generate_matrix(stan::math::matrix_v& A){
  // generate a positive definite matrix
  for(int i=0;i<A.rows();i++){
    for(int j=0;j<A.rows();j++){
      A(i,j) = A.rows()-abs(i-j);
    }
  }
}

double time_iteration(int size){
  stan::math::matrix_v A(size, size);
  generate_matrix(A);
  using namespace std::chrono;
  high_resolution_clock::time_point t1 = high_resolution_clock::now();
  auto B = stan::math::cholesky_decompose(A);
  high_resolution_clock::time_point t2 = high_resolution_clock::now();
  stan::math::recover_memory();
  duration<double> time_span = duration_cast<duration<double>>(t2 - t1);
  return static_cast<double>(time_span.count());
}

int main(){
  std::vector<int> sizes{100,500,1000,2000,3000,4000,6000,8000,10000,12000};
  for (auto &size : sizes)
  {  
    std::cout << "N = " << size << std::endl;
    // force CPU execution
    std::cout << "CPU\t";
    stan::math::opencl_context.tuning_opts().cholesky_size_worth_transfer = 13000*2;
    for(int i=0;i<NUM_OF_ITERATIONS;i++){
      double duration = time_iteration(size);
      std::cout << duration << "\t";
    }
    std::cout << std::endl;
    //force GPU execution
    std::cout << "GPU\t";
    stan::math::opencl_context.tuning_opts().cholesky_size_worth_transfer = 0;
    for(int i=0;i<NUM_OF_ITERATIONS;i++){
      double duration = time_iteration(size);
      std::cout << duration << "\t";
    }
    std::cout << std::endl;
  }
}
