#include <stdio.h>
//void wrapper(void){}
void wrapper();
int main(int argc, char **argv){
    float *ptr;
   // cudaMalloc(&ptr, sizeof(float));
    
    wrapper();
    return 0;
}