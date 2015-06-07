/**
 * Copyright 1993-2012 NVIDIA Corporation.  All rights reserved.
 *
 * Please refer to the NVIDIA end user license agreement (EULA) associated
 * with this source code for terms and conditions that govern your use of
 * this software. Any use, reproduction, disclosure, or distribution of
 * this software and related documentation outside the terms of the EULA
 * is strictly prohibited.
 */
#include <stdio.h>
#include <stdlib.h>



/**
 * This macro checks return value of the CUDA runtime call and exits
 * the application if the call failed.
 */
#define CUDA_CHECK_RETURN(value) {											\
	cudaError_t _m_cudaStat = value;										\
	if (_m_cudaStat != cudaSuccess) {										\
		fprintf(stderr, "Error %s at line %d in file %s\n",					\
				cudaGetErrorString(_m_cudaStat), __LINE__, __FILE__);		\
		exit(1);															\
	} }
#define N 100

__global__ void kernel_1() { double sum = 0.0;
for (int i = 0; i < N; i++) {
sum = sum + tan(0.1) * tan(0.1); }
}
__global__ void kernel_2() { double sum = 0.0;
for (int i = 0; i < N; i++) {
sum = sum + tan(0.1) * tan(0.1); }
}
__global__ void kernel_3() { double sum = 0.0;
for (int i = 0; i < N; i++) {
sum = sum + tan(0.1) * tan(0.1); }
}


/**
 * Host function that prepares data array and passes it to the CUDA kernel.
 */
int main(void) {

	int n_streams = 3;
	cudaStream_t *streams = (cudaStream_t *)malloc(n_streams * sizeof(cudaStream_t));
	for (int i = 0 ; i < n_streams; i++) {
	cudaStreamCreate(&streams[i]);
	}
	dim3 block(1);
	dim3 grid(1);
	for (int i = 0; i < n_streams; i++) {
		kernel_1<<<grid, block, 0, streams[i]>>>();
	//}
		//for (int i = 0; i < n_streams; i++) {
		kernel_2<<<grid, block, 0, streams[i]>>>();
		//}
		//for (int i = 0; i < n_streams; i++) {
		kernel_3<<<grid, block, 0, streams[i]>>>();
	}
printf("done\n");

	CUDA_CHECK_RETURN(cudaDeviceSynchronize());	// Wait for the GPU launched work to complete
//	CUDA_CHECK_RETURN(cudaGetLastError());

	CUDA_CHECK_RETURN(cudaDeviceReset());

	return 0;
}
