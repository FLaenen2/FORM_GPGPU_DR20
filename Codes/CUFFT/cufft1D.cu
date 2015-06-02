#include <iostream> 
#include <stdio.h>
#include <cufft.h>
#include "../COMMON/commons.cuh"
#include <cuComplex.h>

template<class C>
__global__ void scale_cmp(C *arr, const float scale, const int size){

    int i = blockDim.x * blockIdx.x + threadIdx.x;
    if (i < size){
        arr[i].x *= scale;
        arr[i].y *= scale;
    }

}


template<typename T>
    __global__ void printme(T *val, int size = 1){

        for (int i = 0; i < size; i++){
            printf("%g\t", val[i]);
        }
        printf("\n");

    }


template<typename C>
    __global__ void print_cmp(C *val, int size = 1){

        for (int i = 0; i < size; i++){
            //printf("[%d] %g\t", i, val[i].x * val[i].x + val[i].y * val[i].y);
            printf("[%d] %g\t", i, cuCabsf(val[i]) * cuCabsf(val[i]));
        }
        printf("\n");

    }



#define TPB 512

using namespace std;
                        ///////////
                        /// MAIN //

int main(int argc, char **argv){
	
    int nx = 64;
    int f1 = 5;  // Frequencies
    int f2 = 10;
    int nk = nx/2 + 1;
    float L = 2. * M_PI;
    float *h_v = new float[nx]();
    cufftComplex *d_v;

    size_t spatSize = nx * sizeof(float);     // Shortcut for memory copies and allocations
    size_t specSize = nk * sizeof(cufftComplex);
    
    // Generate a signal on the host
    for (int i = 0; i < nx; i++){
	    h_v[i] = cos((float) f1 * i / nx * L) + 2 * cos((float) f2 * i / nx * L) ; 
     }
    

    CUDA_CHECK(cudaMalloc(&d_v, specSize));
    // Pointer needs to be converted to cufftReal when necessary
    CUDA_CHECK(cudaMemset((cufftReal *)d_v, 0, specSize));
    CUDA_CHECK(cudaMemcpy((cufftReal *)d_v, h_v, spatSize, H2D));
    cout << endl << "Before : " << endl;
    printme<<<1,1>>>((cufftReal *) d_v, nx);
    CUDA_CHECK_ERROR();
    CUDA_CHECK(cudaDeviceSynchronize());
    
    // Create plans
    cufftHandle planr2c;    // the names r2c and c2r will be used regardless of the precison
    cufftHandle planc2r;
    CUFFT_CHECK(cufftPlan1d(&planr2c, nx, CUFFT_R2C, 1));
    CUFFT_CHECK(cufftPlan1d(&planc2r, nx, CUFFT_C2R, 1));

		// for no padding
    CUFFT_CHECK(cufftSetCompatibilityMode(planr2c, CUFFT_COMPATIBILITY_NATIVE));
    CUFFT_CHECK(cufftSetCompatibilityMode(planc2r, CUFFT_COMPATIBILITY_NATIVE));


	// Illustrates the use of timer
    GpuTimer myT(1);

    myT.Start();
    // DIRECT TRANSFORM, inplace
    CUFFT_CHECK(cufftExecR2C(planr2c, (cufftReal *) d_v,  d_v));
    int grid (ceil((float)nk / TPB));
    scale_cmp<<<grid, TPB>>>(d_v, 1./nx, nk);
    CUDA_CHECK_ERROR();
    cout << endl << "Power spectrum : " << endl;
    print_cmp<<<1, 1>>>(d_v, nk);
    CUDA_CHECK_ERROR();
    CUDA_CHECK(cudaDeviceSynchronize());
    myT.Stop();
    cout << "Time elapsed " << myT.Elapsed() << endl;

    // INVERSE TRANSFORM
    CUFFT_CHECK(cufftExecC2R(planc2r, d_v, (cufftReal *)d_v));
    
    // PRINT AFTER
    cout << endl << "After : " << endl;
    printme<<<1,1>>>((cufftReal *) d_v, nx);
    CUDA_CHECK_ERROR();
    CUDA_CHECK(cudaDeviceSynchronize());

    // Release plans
    CUFFT_CHECK(cufftDestroy(planr2c));
    CUFFT_CHECK(cufftDestroy(planc2r));
	
    return 0;
    
}




