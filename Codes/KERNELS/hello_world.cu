#include <stdio.h>
#include "../COMMON/commons.cuh"

__global__ void hello_world(void){   
	int i = blockIdx.x * blockDim.x + threadIdx.x;
	printf("Hello from thread %d (global index %d) in block %d\n", threadIdx.x, i, blockIdx.x);
}

int main(int argc, char **argv){
	hello_world<<<2, 5>>>();
	SYNCGPU();
	return 0;
}