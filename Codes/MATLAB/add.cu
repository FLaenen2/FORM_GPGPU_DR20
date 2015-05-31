__global__ void add(double *a, double *b, float c, int size){

    int i = threadIdx.x + blockIdx.x * blockDim.x;
    if (i < size){
        a[i] += b[i] * c;
    }
    
}