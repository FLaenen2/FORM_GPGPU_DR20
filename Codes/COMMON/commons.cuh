#ifndef CUDA_HELPERS
#define CUDA_HELPERS

#include <helper_cuda.h>
#include <stdio.h>
#define H2D cudaMemcpyHostToDevice
#define D2H cudaMemcpyDeviceToHost


#define CUFFT_CHECK( err )    __cufftSafeCall( err, __FILE__, __LINE__ )
#define CUBLAS_CHECK(err)  __cublasSafeCall( err, __FILE__, __LINE__ )
//#ifndef NDEBUG
#define CUDA_CHECK( err ) __cudaSafeCall( err, __FILE__, __LINE__ )
//#elseif
//#define CUDA_CHECK(err) err;
//#endif
 
#define CURAND_CHECK(x) do { if((x)!=CURAND_STATUS_SUCCESS) { \
printf("Error at %s:%d\n",__FILE__,__LINE__);\
return EXIT_FAILURE;}} while(0)

#define CUDA_CHECK_ERROR()    __cudaCheckError( __FILE__, __LINE__ )
#define SYNCGPU() CUDA_CHECK(cudaDeviceSynchronize());



inline void __cudaSafeCall( cudaError err, const char *file, const int line )
{
    if ( cudaSuccess != err )
    {
        fprintf( stderr, "cudaSafeCall() failed at %s:%i : %s\n",
                file, line, cudaGetErrorString( err ) );
        exit( -1 );
    }
    return;
}

inline void __cudaCheckError( const char *file, const int line )
{
    cudaError err = cudaGetLastError();
    if ( cudaSuccess != err )
    {
        fprintf( stderr, "cudaCheckError() failed at %s:%i : %s\n",
                file, line, cudaGetErrorString( err ) );
        exit( -1 );
    }
    return;
}


#ifdef CUBLAS_API_H_
	inline void __cublasSafeCall( cublasStatus_t err, const char *file, const int line)
	{
		if ( CUBLAS_STATUS_SUCCESS != err ){
			fprintf(stderr, "CUBLAS_CHECK failed at %s:%i : %d : %s\n", file, line, err, _cudaGetErrorEnum(err));
			cudaDeviceReset();
			exit( EXIT_FAILURE );
		}
	}
#endif

#ifdef _CUFFT_H_
	inline void __cufftSafeCall( cufftResult err, const char *file, const int line)
	{
		if ( CUFFT_SUCCESS != err ){
			fprintf(stderr, "CUFFT failed at %s:%i : %d : %s\n", file, line, err, _cudaGetErrorEnum(err));
			exit( EXIT_FAILURE );
		}
	}
#endif

struct GpuTimer
{
    cudaEvent_t start;
    cudaEvent_t stop;
    int n_iter;

    GpuTimer(int n = 100)
    {
        cudaEventCreate(&start);
        cudaEventCreate(&stop);
        n_iter = n;
    }

    ~GpuTimer()
    {
        cudaEventDestroy(start);
        cudaEventDestroy(stop);
    }

    void Start()
    {
        cudaEventRecord(start, 0);
    }

    void Stop()
    {
        cudaEventRecord(stop, 0);
    }

    float Elapsed()
    {
        float elapsed;
        cudaEventSynchronize(stop);
        cudaEventElapsedTime(&elapsed, start, stop);
        return elapsed;
    }
};


inline void assertAvailableMemory(void){
    // Stat the state of graphical memory
    size_t free, total;
    CUDA_CHECK(cudaMemGetInfo(&free, &total));
    //CUDA_CHECK(cudaDeviceSynchronize());
    fprintf(stdout,"\n\tAvailable VRAM : %g Mo/ %g Mo(total)\n\n", free / 1e6, total / 1e6);

}


__device__ double atomicAdd(double* address, double val)
{
    unsigned long long int* address_as_ull =
                                          (unsigned long long int*)address;
    unsigned long long int old = *address_as_ull, assumed;
    do {
        assumed = old;
        old = atomicCAS(address_as_ull, assumed, 
                        __double_as_longlong(val + 
                        __longlong_as_double(assumed)));
    } while (assumed != old);
    return __longlong_as_double(old);
}


template<typename T>
__global__ void print_dev(T *x, int size){
    
    for (int i = 0; i < size; i++){
        printf("[%d] = %g\n", i, x[i]);
    }
    
}


#endif
