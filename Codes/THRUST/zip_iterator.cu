#include <thrust/iterator/zip_iterator.h>
#include <thrust/device_vector.h>
#include <thrust/tuple.h>
#include <stdio.h>
#include <typeinfo>
#include <iostream> 
#include <string>


struct binary_op{

    template<typename Tuple>
    __host__ __device__ int operator ()(const Tuple& in1, const Tuple& in2){
	return thrust::get<1>(in1) + thrust::get<0>(in1) + thrust::get<2>(in1) + thrust::get<2>(in2) + thrust::get<0>(in2) + thrust::get<1>(in2); 
    }   
};

int main(int argc, char **argv){

    // initialize vectors
    thrust::device_vector<int> A(3);
    thrust::device_vector<int> B(3);
    thrust::device_vector<int> C(3);
    A[0] = 10; A[1] = 20;  A[2] = 30;
    B[0] = 1; B[1] = 2; B[2] = 3;
    C[0] = 1;  C[1] = 1;  C[2] = 1;

    // create iterators 
    typedef thrust::device_vector<int>::iterator   IntIterator;
    typedef thrust::tuple<IntIterator, IntIterator, IntIterator> IteratorTuple;
    typedef thrust::zip_iterator<IteratorTuple> ZipIterator;
    ZipIterator first = thrust::make_zip_iterator(thrust::make_tuple(A.begin(), B.begin(), C.begin()));
    ZipIterator last  = thrust::make_zip_iterator(thrust::make_tuple(A.end(),   B.end(), C.end()));

    // Reduction 
    typedef thrust::tuple<int, int, int> IntTup;
    IntTup init = thrust::make_tuple(0 , 0, 0);
    IntTup result = thrust::reduce(first, last, init, binary_op()); 
    printf("result <1> : %d <2> : %d <3> : %d\n", thrust::get<0>(result), thrust::get<1>(result), thrust::get<2>(result));

    return 0;
}

