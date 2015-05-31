#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include "../COMMON/commons.cuh"
#include <stdio.h>
#include <vector>

int main(int argc, char **argv){

    // Create a device_vector with a given number of elements and value
    thrust::device_vector<float> v1(10000, 3.);
    
    // Create a device_vector from a host vector
    thrust::host_vector<float> h2(10000, 3.);
    thrust::device_vector<float> v2 = h2;
    
    // Create a device_vector from a stl vector
	std::vector<float> stvec(100, 1);
	thrust::device_vector<float> v3(stvec);
	
	// Or copy explicitly
	thrust::device_vector<float> v4(100, 0);
	thrust::copy(stvec.begin(), stvec.end() , v4.begin());   
    
    // Use a thrust algorithm on the vectors
    float sum = thrust::reduce(v4.begin(), v4.end());
    printf("Sum %g\n", sum);
    
    // You can use a thrust::device_ptr in algorithms
    thrust::device_ptr<float> v4_dptr = v4.data();
    sum = thrust::reduce(v4_dptr, v4_dptr + 100);
    printf("Sum %g\n", sum);
        
    // You can convert thrust vectors from a device_ptr raw pointers to use in kernels
    float *raw_ptr = thrust::raw_pointer_cast(v4_dptr);
    // ... or this way
    float *raw_ptr2 = v4_dptr.get();
	print_dev<<<1,1>>>(raw_ptr2, 100);
    
    // You can convert raw pointers to device_ptr to use in algorithms
    thrust::device_ptr<float> v5_dptr(raw_ptr);
    sum = thrust::reduce(v5_dptr, v5_dptr + 100);
    printf("Sum %g\n", sum);

    
    SYNCGPU();
    return 0;
    
}