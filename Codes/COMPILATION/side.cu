//__device__ int dev();
__global__ void foo(void){
  // int a =  dev(); // calling the device function
}

void wrapper(void){
    foo<<<1,1>>>(); // calling the global function
}
