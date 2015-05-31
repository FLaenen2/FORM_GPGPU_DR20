#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
//#include <thrust/sort.h>
//#include <thrust/copy.h>
//#include <thrust/sequence.h>
//#include <thrust/random.h>
//#include <thrust/random/normal_distribution.h>

#include <algorithm>
#include <time.h>
//#include <limits.h>
#include "../COMMON/commons.cuh"
#include <stdio.h>

#define N 1000
using namespace thrust;

/*template<typename T>
struct Rands{
	
	Rands<T>(void){
		rng = default_random_engine(clock()); 
		dist = normal_distribution<float>(0, 1);
	};
	default_random_engine rng;
	normal_distribution<float> dist;
	__host__ __device__ T operator()(T &a){
		return dist(rng);
	};

};*/


int main(int argc, char **argv){
	
//	thrust::default_random_engine rng(clock());
	//thrust::normal_distribution<float> dist1(0, 1);
	//thrust::normal_distribution<float> dist2(0, 2);
	// Declare device vectors and initialize elements with 0
	//host_vector<float> h_v1(N, 0);
//	host_vector<float> h_v2(N);
//	for (int i = 0; i < h_v1.size(); i++){
	//	h_v1[i] = dist1(rng);
//		h_v2[i] = dist2(rng);
//	}

	device_vector<float> d_v1(10); 
	//device_vector<float> d_v2(N); 
	//thrust::copy(h_v1.begin(), h_v2.end(), d_v1.begin());
//	d_v1 = h_v1;
//	d_v2 = h_v2;
//	float res = thrust::reduce(d_v1.begin(), d_v1.end(), 0, thrust::plus<float>());
//	printf("Mean 1 : %g\n", res);
//	thrust::sort(d_v1.begin(), d_v1.end());
//	bool is_sorted = thrust::is_sorted(d_v1.begin(), d_v1.end()); 
//	printf("is d_v1 sorted : %d", is_sorted);


//	Rands<float> op(); 
//	transform(d_v1.begin(), d_v1.end(), d_v1.begin(), op);
//	print_dev<<<1, 1>>>(thrust::raw_pointer_cast(d_v1.data()), 100);
	CUDA_CHECK(cudaDeviceSynchronize());
	//CUDA_CHECK(cudaDeviceReset());
	return 0;

}
