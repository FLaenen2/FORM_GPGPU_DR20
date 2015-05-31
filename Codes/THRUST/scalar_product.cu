#include <thrust/device_vector.h>
#include <thrust/sequence.h>
 #include <thrust/inner_product.h>
#include "../COMMON/commons.cuh"
#include <stdio.h>

#define N 10000

int main(int argc, char **argv){

    // Create two device_vector of float (single precision) elements, with N elements
    thrust::device_vector<float> v1(N);
    thrust::device_vector<float> v2(N);
    
    // Fill it with a sequence starting from 1 with step 2
    thrust::sequence(v1.begin(), v1.end(), 1, 2);
    thrust::fill(v2.begin(), v2.end(), 1);

    // Compute the dot product of the two vectors
    float result = thrust::inner_product(v1.begin(), v1.end(), v2.begin(), 0);
    
    // Get the same result by using a reduction 
    float reduced = thrust::reduce(v1.begin(), v1.end(),  0, thrust::plus<float>());

    // Print the result
    printf("Values : from inner product %g, form reduction %g\n", result, reduced);    

    return 0;

}
