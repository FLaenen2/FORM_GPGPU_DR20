#include "../COMMON/commons.cuh"
__global__ void foo(){

}

int main(int argc, char **argv){

    dim3 grid(1, 1), block(3, 256);
    foo<<<grid, block>>>();
    CUDA_CHECK_ERROR();    

    SYNCGPU();
return 0;
}
