#include <iostream> 
#include <stdio.h>
#include <cufft.h>
#include "../COMMON/commons.cuh"


 template<class C>
    __global__ void compLap(const C *src, C *dst, const int nx, const int ny, const float dkx = 1, const float dky = 1){
    
        int i = blockIdx.x * blockDim.x + threadIdx.x;
        int j = blockIdx.y * blockDim.y + threadIdx.y;
        if (i < (nx/2+1) && j < ny){
            int gidx = j * (nx/2+1) + i;
            j = (j > ny/2) ? (j - ny) : j;
            float kx = i*dkx;
            float ky = j*dky;
            float kk = (float)(kx*kx + ky*ky);
            dst[gidx].x = -kk * src[gidx].x;
            dst[gidx].y = -kk * src[gidx].y;
        }    
    }
    
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
            printf("%g\t", val[i].x * val[i].x + val[i].y * val[i].y);
        }
        printf("\n");

    }



#define TPB 512

using namespace std;
                        ///////////
                        /// MAIN //

int main(int argc, char **argv){

	CUDA_CHECK(cudaDeviceReset());
	
    int nx = 16;
    int ny = 16;
    int nk = ny * (nx/2 + 1);
    float L = 2. * M_PI;
    float dx = L / nx, dy = L / ny;
    float *h_v = new float[nx * ny]();
    cufftComplex *d_v;

    size_t spatSize = nx * ny * sizeof(float);     // Shortcut for memory copies and allocations
    size_t specSize = nk * sizeof(cufftComplex);
    
    // Generate a signal on the host
    for (int i = 0; i < ny; i++){
        for (int j = 0; j < nx; j++){
	    	h_v[i*nx + j] = sin(j * dx) * cos(i * dy) ; 
	    }
     }

    CUDA_CHECK(cudaMalloc(&d_v, specSize));
    CUDA_CHECK(cudaMemset(d_v, 0, specSize));
    CUDA_CHECK(cudaMemcpy((cufftReal *) d_v, h_v, spatSize, H2D));
    cout << endl << "Before : " << endl;
    printme<<<1,1>>>((cufftReal *) d_v, nx);
    CUDA_CHECK_ERROR();
    CUDA_CHECK(cudaDeviceSynchronize());
    
    // Create plans
    cufftHandle planr2c;    // the names r2c and c2r will be used regardless of the precison
    cufftHandle planc2r;
	CUFFT_CHECK(cufftPlan2d(&planr2c, ny, nx, CUFFT_R2C));
    CUFFT_CHECK(cufftPlan2d(&planc2r, ny, nx, CUFFT_C2R));
	SYNCGPU();
		// for no padding
    CUFFT_CHECK(cufftSetCompatibilityMode(planr2c, CUFFT_COMPATIBILITY_NATIVE));
    CUFFT_CHECK(cufftSetCompatibilityMode(planc2r, CUFFT_COMPATIBILITY_NATIVE));
	SYNCGPU();
    int grid (ceil((float)nk / TPB));

    // DIRECT TRANSFORM
    CUFFT_CHECK(cufftExecR2C(planr2c, (cufftReal *) d_v,  d_v));
    scale_cmp<<<grid, TPB>>>(d_v, 1./(nx*ny), nk);
    CUDA_CHECK_ERROR();
    CUDA_CHECK(cudaDeviceSynchronize());
    int tpbx = 16;
    int tpby = 16;
    dim3 block2D(tpbx, tpby);
    dim3 grid2D(ceil((float)nx/2+1/tpbx), ceil((float)ny/tpby));
    compLap<<<grid2D, block2D>>>(d_v, d_v, nx, ny);
    CUDA_CHECK_ERROR();
    CUDA_CHECK(cudaDeviceSynchronize());
    
    // INVERSE TRANSFORM
    CUFFT_CHECK(cufftExecC2R(planc2r, d_v, (cufftReal *) d_v));
        
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




