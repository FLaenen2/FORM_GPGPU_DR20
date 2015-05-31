#include "../COMMON/commons.cuh"

#define H2D cudaMemcpyHostToDevice
#define D2H cudaMemcpyDeviceToHost

template<typename T>
__global__ void sum(const T *S1, const T *S2, T *S3, const int n){

	int i = blockIdx.x * blockDim.x + threadIdx.x; 
	if (i < n) { // or if (i >= n){ return ;}
		S3[i] = S1[i] + S2[i];
	}

}


int main (int argc, char **argv){

	int n = 100;
	
	// Make memory space for host arrays, optionally instanciated to zero
	int *h_S1 = new int[n]();
	int *h_S2 = new int[n]();
	
	// Fill CPU arrays;
	for (int i = 0; i < n; i++){
		h_S1[i] = i;
		h_S2[i] = 2 * i;
	}
	
	// Declare pointers for memory arrays
	int *d_S1, *d_S2, *d_S3;
	
	// Allocate memory on device for arrays
	CUDA_CHECK(cudaMalloc(&d_S1, n * sizeof(int)));
	CUDA_CHECK(cudaMalloc(&d_S1, n * sizeof(int)));
	CUDA_CHECK(cudaMalloc(&d_S1, n * sizeof(int)));
	
	// Instanciate to zero (also optional in this case)
	CUDA_CHECK(cudaMemset(d_S1, 0, n * sizeof(int)));
	CUDA_CHECK(cudaMemset(d_S2, 0, n * sizeof(int)));
	CUDA_CHECK(cudaMemset(d_S3, 0, n * sizeof(int)));
	
	// Copy CPU arrays to GPU (device) arrays
	CUDA_CHECK(cudaMemcpy(d_S1, h_S1, n * sizeof(int), cudaMemcpyHostToDevice)); // without using macro shortcut
	CUDA_CHECK(cudaMemcpy(d_S1, h_S1, n * sizeof(int), H2D)); // using macro shortcut
	CUDA_CHECK(cudaMemcpy(d_S1, h_S1, n * sizeof(int), H2D));
	
	// launch kernels

	int TPB = 32;
	int nblocks = ceil((float)n/TPB); 
	sum<<<nblocks, TPB>>>(d_S1, d_S2, d_S3, n);
	CUDA_CHECK_ERROR();
	
	// Retrieve result to host in S1
	CUDA_CHECK(cudaMemcpy(h_S1, d_S1, n * sizeof(int), D2H));
	
	// Synchronize host and device
	CUDA_CHECK(cudaThreadSynchronize());	
	
	
	return 0;
}
