__global__ void add(double *a, double *b, const float c, const int size){

    int i = threadIdx.x + blockIdx.x * blockDim.x;
    if (i < size){
        a[i] += b[i] * c;
    }
    
}