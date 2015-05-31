#include <stdio.h>
__global__ void hello(){
//#if (__CUDA_ARCH__ > 200)
    printf("hello world !\n");
//#endif
}
int main(int argc, char **argv){
    //float *ptr;
    //cudaMalloc(&ptr, sizeof(float));
    hello<<<1,1>>>();
    cudaDeviceSynchronize();
    return 0;
}
