
// Illustrates the main functions used in CUDA to allocate and free memory, and copy it between host and device

#include "../COMMON/commons.cuh"
#define N 10000
#define H2D cudaMemcpyHostToDevice

int main(int argc, char **argv){
 
    // Create a host vector in host / cpu memory
    float *hv = new float[N];
    
    // Initialize it 
    for (int i = 0; i < N; i++){
	hv[i] = i * sqrt(2);
    }
    
    // Declare a pointer that will reside on the device
    float *dv;    
    
    // Allocate memory using this last pointer. Note that the function requires the adress of the pointer
    CUDA_CHECK(cudaMalloc(&dv, N * sizeof(float)));

    // Initialize it to 0 (not necessary if will be copied over but good practice)
    CUDA_CHECK(cudaMemset(dv, 0, N * sizeof(float)));
    
    // Copy the array from CPU to GPU (host to device)
    CUDA_CHECK(cudaMemcpy(dv, hv, N * sizeof(float), cudaMemcpyHostToDevice)); // cudaMemcpyDefault works also
    // Illustration 
    CUDA_CHECK(cudaMemcpy(dv, hv, N * sizeof(float), cudaMemcpyDefault)); // works also
    CUDA_CHECK(cudaMemcpy(dv, hv, N * sizeof(float), H2D)); // using a macro fro shortcut

    // Perform some operations on it
    // ...
    // Get the data back to the host
    CUDA_CHECK(cudaMemcpy(hv, dv, N * sizeof(float), cudaMemcpyDeviceToHost));
    
    // Free useless device memory
    CUDA_CHECK(cudaFree(dv));

    // Synchronize 
    CUDA_CHECK(cudaThreadSynchronize());

    printf("Success\n");
    return 0;
}


