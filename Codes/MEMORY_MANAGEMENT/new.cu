#define N 100000
#include "../COMMON/commons.cuh"
int main(int argc, char **argv){

    float *d_arr;
    // Memory allocation
    CUDA_CHECK(cudaMalloc(&d_arr, N * sizeof(float)));
    // Memory set
    CUDA_CHECK(cudaMemset(d_arr, 0, N * sizeof(float)));
    
    float *h_arr = new float[N]();
    for (int i = 0; i < N; i++){
	h_arr[i] = (float) i;
    }

    // Memory Copy to GPU (destination, source, size, direction)
    CUDA_CHECK(cudaMemcpy(d_arr, h_arr, N * sizeof(float), cudaMemcpyHostToDevice));
    // Works also thanks to UVA
    CUDA_CHECK(cudaMemcpy(d_arr, h_arr, N * sizeof(float), cudaMemcpyDefault));

    //test<<<1,1>>>(h_arr);
    
    CUDA_CHECK(cudaMemcpy(h_arr, d_arr, N * sizeof(float), D2H));

    CUDA_CHECK(cudaFree(d_arr));

    CUDA_CHECK(cudaDeviceSynchronize());

    

return 0;
}
