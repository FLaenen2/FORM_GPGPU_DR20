#include <thrust/device_vector.h>
#include <thrust/sequence.h>
#include "../COMMON/commons.cuh"
#include <stdio.h>

struct Sq{
    
    __device__ __host__ float operator()(const float& a){
	return a*a;
    }

};

int main(int argc, char **argv){

    // Create a device_vector of float (single precision) elements, with 100 elements
    thrust::device_vector<float> v1(20);
    
    // Fill it with a sequence starting from 0 with step 2
    thrust::sequence(v1.begin(), v1.end(), 0, 2);
    printf("Sequence generated\n");

    // Use a in-place unary transformation algorithm already defined in thrust
    // Syntax is transform( beginning_of_object_to_transform, beginning_of_object_to_transform,
    // beginning_of_where_to_put_the_result, operation_to_use )
    //thrust::transform(v1.begin(), v1.end(), v1.begin(), thrust::negate<float>());
    thrust::transform(v1.begin(), v1.end(), v1.begin(), Sq());
    printf("Sequence transformed\n");
    
    // Print the result
    print_dev<<<1,1>>>(thrust::raw_pointer_cast(v1.data()), static_cast<int>(v1.size()));
    printf("Sequence printed\n");
   
     // Check for errors
    CUDA_CHECK_ERROR();
    
    // Synchronize to be sure to finish operations before program exits
    SYNCGPU();

    return 0;

}
