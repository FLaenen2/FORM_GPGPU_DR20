#include <stdio.h>
__device__ float giveFloat(void);
__device__ int dev(){ return 2;}
__global__ void foo(void){
   int a =  dev(); // calling the device function
    printf("a = %d\n", a);
    float b = giveFloat();
}

void wrapper(void){
    foo<<<1,1>>>(); // calling the global function
    cudaDeviceSynchronize();
}
