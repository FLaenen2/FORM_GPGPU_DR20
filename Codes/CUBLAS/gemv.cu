#include <stdio.h>
#include <cublas_v2.h>
#include "../COMMON/common.h"

// Computes the product alpha A x + beta y = y
// A is a matrix of size M x N, x is  a vector of size N, y is a vector of size M, and alpha and beta are scalars

#define N 500
// N is number of columns
#define M 600
// M is number of rows

int main(int argc, char **argv)
{
    cublasHandle_t handle;
    //cublasStatus_t status;
    float *d_x, *d_A, *d_y;
    
    // Make place on CPU memory for matrix and vector. 
    float *h_x = new float[N]; 
    float *h_y = new float[M]; 
    float *h_A = new float[M*N];

    // Initialize cublas to perform operations
    //CHECK_CUBLAS(cublasCreate_v2(&handle));

    CHECK_CUBLAS(cublasCreate_v2(&handle));

    // The long way to check for error
/*	if (status != CUBLAS_STATUS_SUCCESS)
    {
        fprintf(stderr, "!!!! CUBLAS initialization error\n");
        return EXIT_FAILURE;
    }*/

    // Create vector and matrix on host side
	for (int j = 0; j < N; j++){
	    h_x[j] = 1;
	    for (int i = 0; i < M; i++){
		h_A[j*M + i] = i;
	    }
    }

    // Allocate memory on device for the vector and the matrix
    //CHECK(cudaMalloc(&d_x, N * sizeof(float)));
    CHECK(cudaMalloc(&d_x, N * sizeof(float)));
    CHECK(cudaMalloc(&d_y, M * sizeof(float)));
    CHECK(cudaMemset(d_y, 0, M * sizeof(float)));
    CHECK(cudaMalloc(&d_A, M * N * sizeof(float)));

    // Copy the host vector to device vector. Use macro for error checking.
	CHECK_CUBLAS(cublasSetVector(N, sizeof(h_A[0]), h_x, 1, d_x, 1));
    // Copy the host matrix to device matrix. M is the leading dimension in column major format ( = number of rows).
    CHECK_CUBLAS(cublasSetMatrix(M, N, sizeof(h_A[0]), h_A, M, d_A, M));
    
    // Note : the following is equivalent
    //CHECK_CUBLAS(cublasSetVector(M * N, sizeof(h_A[0]), h_A, 1, d_A, 1));

    float alpha = 1;
    float beta = 0;
	
	// Perform the matrix-vector multiplication
    CHECK_CUBLAS(cublasSgemv(handle, CUBLAS_OP_N, M, N, &alpha, d_A, M, d_x, 1, &beta, d_y, 1));

	// Get the resulting vector
    CHECK_CUBLAS(cublasGetVector(M, sizeof(h_y[0]), d_y, 1, h_y, 1));

    for (int i = 0; i < M; i+=max(1,N/100)){
    	printf("[%d] %g\n", i, h_y[i]);
    }

    // Release cublas handle
    CHECK_CUBLAS(cublasDestroy(handle));

}
