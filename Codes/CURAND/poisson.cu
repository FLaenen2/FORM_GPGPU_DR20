#include <stdio.h>
#include <curand.h>
#include "../COMMON/commons.cuh"
#include <thrust/device_ptr.h>
#include <thrust/reduce.h>

// Generates a random vector from a Poisson distribution from host side with parameter lamba. 
// Then computes the mean (should be equal to lambda).

#define N 100000

int main(int argc, char **argv)
{
	unsigned int lambda = 3;
	curandGenerator_t gen;
	unsigned int *h_v = new unsigned int[N];
	unsigned int *d_v;

	// Allocate device memory
	CUDA_CHECK(cudaMalloc(&d_v, N * sizeof(unsigned int)));

	// Create a curand generator (several generators exist, let's just take the default)
	CURAND_CHECK(curandCreateGenerator(&gen, CURAND_RNG_PSEUDO_DEFAULT));

	// Set a seed
	CURAND_CHECK(curandSetPseudoRandomGeneratorSeed(gen, 1));
		
	// Generate the random numbers on the device vector
	printf("Generating poisson distribution with parameter : %d\n", lambda);
	CURAND_CHECK(curandGeneratePoisson(gen, d_v, N, lambda));
	
	// Compute and print the mean
	thrust::device_ptr<unsigned int> t_v = thrust::device_pointer_cast(d_v);
	float mean = (float) thrust::reduce(t_v, t_v + N);
	mean /= N;
	printf("Mean : %g\n", mean);

	// Optionally copy the vector back to the CPU
	CUDA_CHECK(cudaMemcpy(h_v, d_v, N * sizeof(unsigned int), cudaMemcpyDeviceToHost));
	
	// Release the curand resource
	CURAND_CHECK(curandDestroyGenerator(gen));


	
   return 0;
}
