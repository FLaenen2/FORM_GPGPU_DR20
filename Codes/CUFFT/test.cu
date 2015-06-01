#include <thrust/device_vector.h>
#include <iostream>
#include "../COMMON/commons.cuh"
using namespace std;
int main(int argc, char **argv){

    thrust::device_vector<float> v(10, 2);
    ofstream outFile;
    outFile.open("./output", ios::out);
    thrust::copy(v.begin(), v.end(), std::ostream_iterator<float>(outFile, " "));
    CUDA_CHECK(cudaDeviceSynchronize());
    outFile.close();
return 0;
}
