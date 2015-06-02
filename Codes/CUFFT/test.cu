#include <thrust/device_vector.h>
#include <iostream>
#include "../COMMON/commons.cuh"
using namespace std;
int main(int argc, char **argv){

    thrust::device_vector<float> v(10, 2);
    ifstream inFile;
    inFile.open("./outputHeat", ios::in);
    istream_iterator<float> intvecRead ( inFile );
    thrust::copy(intvecRead, std::istream_iterator<float>(), std::ostream_iterator<float>(std::cout, " "));
    CUDA_CHECK(cudaDeviceSynchronize());
    inFile.close();
return 0;
}
