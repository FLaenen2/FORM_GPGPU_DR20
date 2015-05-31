#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include <thrust/transform_reduce.h>
#include <thrust/functional.h>
#include "../COMMON/commons.cuh"
#include <stdio.h>
#include <thrust/random/normal_distribution.h>
#include <thrust/random/linear_congruential_engine.h>
#include <thrust/count.h>
#include <thrust/remove.h>
#include <thrust/sort.h>

#define N 1000000

template<typename T>
  struct square_value
  {
    __host__ __device__ T operator()(const T &x) const
    {
      return x * x;
    }
  };
  
template<typename T>
struct is_gt
  {
  	float th;
  	is_gt(float _th) : th(_th) {};
    __host__ __device__
    bool operator()(const T x)
    {
      return abs(x) > th;
    }
  };
  
int main(int argc, char **argv){

    // Create a device_vector with a given number of elements and value
    thrust::host_vector<float> h1(N, 0.);
    thrust::host_vector<float> h2(N, 0.);
    
    // Create a generator
    thrust::minstd_rand rng(clock());
	thrust::random::normal_distribution<float> dist1(0, 1);
	thrust::random::normal_distribution<float> dist2(0, 2);
	
	// Fill host vector
	for (int i = 0; i < N; i++){
		h1[i] = dist1(rng);
		h2[i] = dist2(rng);
	}
	
	// Copy to device
	thrust::device_vector<float> v1(h1);
	thrust::device_vector<float> v2(h2);
	//print_dev<<<1,1>>>((v1.data()).get(), 100);
	
	float mean1 = thrust::reduce(v1.begin(), v1.end()) / N;
	float var1 = thrust::transform_reduce(v1.begin(), v1.end(), square_value<float>(), 0.f, thrust::plus<float>()) / N;
	float mean2 = thrust::reduce(v2.begin(), v2.end()) / N;
	float var2 = thrust::transform_reduce(v2.begin(), v2.end(), square_value<float>(), 0.f, thrust::plus<float>()) / N;

	printf("Mean1 : %g\nVariance1 : %g\n", mean1, var1);
	printf("Mean2 : %g\nVariance2 : %g\n", mean2, var2);
	
	float threshold = 1.;
	int result = thrust::count_if(v1.begin(), v1.end(), is_gt<float>(threshold));
	v1.erase(thrust::remove_if(v1.begin(), v1.end(), is_gt<float>(threshold)), v1.end());
	printf("Fraction of elements whose absolute value is greater than %g : %g\nFraction of original size after erase : %g\n", threshold , (float)result / N, (float)v1.size() / N);

	// SORTING
	bool is_sorted = thrust::is_sorted(v1.begin(), v1.end());
	printf("Is sorted ? %d\n", is_sorted);	
	thrust::sort(v1.begin(), v1.end());
	is_sorted = thrust::is_sorted(v1.begin(), v1.end());
	printf("Is sorted ? %d\n", is_sorted);
    
    SYNCGPU();
    return 0;
    
}