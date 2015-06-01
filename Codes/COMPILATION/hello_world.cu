#include <stdio.h>
//#ifdef __NVCC__
__global__ void hello(){
#if (__CUDA_ARCH__ > 200)
    printf("hello world !\n");
#endif
}
//#endif
int main(int argc, char **argv){
    //float *ptr;
    //cudaMalloc(&ptr, sizeof(float));
    hello<<<1,2>>>();
    cudaDeviceSynchronize();
    return 0;
}
