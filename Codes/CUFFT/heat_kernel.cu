#include <iostream> 
#include <stdio.h>
#include <cufft.h>
#include <thrust/copy.h>
#include <thrust/device_vector.h>
#include <iostream>
#include "../COMMON/commons.cuh"
#include <time.h>

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
            printf("[%d] %g\t", i, val[i].x * val[i].x + val[i].y * val[i].y);
        }
        printf("\n");
    }


#define TPB 512
__constant__ float d_nu;
__global__ void update(cufftComplex *vec, const float nu, const float dt, const int nk){
    int i = threadIdx.x + blockIdx.x * blockDim.x;
    //if (i < nk){
	int kx = i;
	float kk = kx * kx;	
	//vec[i].x -= dt * nu * kk * vec[i].x; // explicit, Euler
	//vec[i].y -= dt * nu * kk * vec[i].y;
	float tempr = vec[i].x - vec[i].x * kk * nu * dt/2; // Runge-Kutta 2
	float tempy = vec[i].y - vec[i].y * kk * nu * dt/2;
	vec[i].x = vec[i].x - dt * nu * kk * tempr;
	vec[i].y = vec[i].y - dt * nu * kk * tempy;
	//vec[i].x /= (1 + nu * dt * kk); // implicit version
	//vec[i].y /= (1 + nu * dt * kk);
    //}

}

using namespace std;
                        ///////////
                        /// MAIN //

int main(int argc, char **argv){
	
    int nx = 131072*16;
    int nk = nx/2 + 1;
    float L = 2. * M_PI;
    float *h_v = new float[nx]();
    cufftComplex *d_v;

    ofstream outFile;
    outFile.open("./outputHeat", ios::out);
    outFile.close();
    size_t spatSize = nx * sizeof(float);     // Shortcut for memory copies and allocations
    size_t specSize = nk * sizeof(cufftComplex);
    
    // Parameters
    float nu = .0;
    //CUDA_CHECK(cudaMemcpyToSymbol(d_nu, nu, sizeof(float)));
    float T  = .001;
    float dt = 0.0000001;
    int NT = round(T / dt);
    float dx = L / nx;
    float mean = 0.;
    float sigma = 0.5;
    // Generate a signal on the host
    for (int i = 0; i < nx; i++){
	    float xi = -M_PI + i * dx;
	    h_v[i] = 1. /sqrt(2.* M_PI * sigma * sigma) * exp(-(xi-mean)*(xi-mean)/(2.*sigma*sigma)); 
     }
    

    CUDA_CHECK(cudaMalloc(&d_v, specSize));
    // Pointer needs to be converted to cufftReal when necessary
    CUDA_CHECK(cudaMemset((cufftReal *)d_v, 0, specSize));
    CUDA_CHECK(cudaMemcpy((cufftReal *)d_v, h_v, spatSize, H2D));
    
    // Create plans
    cufftHandle planr2c;    // the names r2c and c2r will be used regardless of the precison
    cufftHandle planc2r;
    CUFFT_CHECK(cufftPlan1d(&planr2c, nx, CUFFT_R2C, 1));
    CUFFT_CHECK(cufftPlan1d(&planc2r, nx, CUFFT_C2R, 1));

		// for no padding  
    CUFFT_CHECK(cufftSetCompatibilityMode(planr2c, CUFFT_COMPATIBILITY_NATIVE));
    CUFFT_CHECK(cufftSetCompatibilityMode(planc2r, CUFFT_COMPATIBILITY_NATIVE));

    int grid (ceil((float)nk / TPB));
    outFile.open("./outputHeat", ios::app);
    thrust::device_ptr<cufftReal> dev_ptr((cufftReal *)d_v);
    thrust::copy(dev_ptr, dev_ptr + nx, ostream_iterator<cufftReal>(outFile, " "));
    CUDA_CHECK(cudaDeviceSynchronize());
    outFile << endl;
    outFile.close();

    // DIRECT TRANSFORM, inplace
    CUFFT_CHECK(cufftExecR2C(planr2c, (cufftReal *)d_v,  d_v));
    scale_cmp<<<grid, TPB>>>(d_v, 1./nx, nk);
    CUDA_CHECK_ERROR();
    clock_t start, stop;
    start = clock();
    GpuTimer myTimer(1);
    myTimer.Start();

    for (int it = 0; it < NT ; it++){
	
	update<<<grid, TPB>>>(d_v, nu, dt, nk);     
	CUDA_CHECK_ERROR();
	CUDA_CHECK(cudaDeviceSynchronize());
	
	// INVERSE TRANSFORM
	   /* if (!(it % 500)){
		CUFFT_CHECK(cufftExecC2R(planc2r, d_v, (cufftReal *)d_v));
		CUDA_CHECK(cudaDeviceSynchronize());
		outFile.open("./outputHeat", ios::app);
		thrust::device_ptr<cufftReal> dev_ptr((cufftReal *)d_v);
		thrust::copy(dev_ptr, dev_ptr + nx, ostream_iterator<cufftReal>(outFile, " "));
		CUDA_CHECK(cudaDeviceSynchronize());
		outFile << endl;
		outFile.close();
		CUFFT_CHECK(cufftExecR2C(planr2c, (cufftReal *)d_v,  d_v));
		scale_cmp<<<grid, TPB>>>(d_v, 1./nx, nk);
		CUDA_CHECK_ERROR();
	    } */
    }
    SYNCGPU();
    myTimer.Stop();
    std::cout << "Elapsed " << myTimer.Elapsed()/1000 << std::endl;
    stop = clock() - start;
    printf("Duration %g seconds\n", (float) stop / CLOCKS_PER_SEC);

    // Release plans
    //CUFFT_CHECK(cufftDestroy(planr2c));
    //CUFFT_CHECK(cufftDestroy(planc2r));
    CUDA_CHECK(cudaDeviceReset());
    SYNCGPU();	
    return 0;
    
}




