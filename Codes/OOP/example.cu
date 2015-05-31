#include "../COMMON/commons.cuh"
#include <stdio.h>

#define N 100

class GpuClass{

	public:
		// Variables
		int arr[N];
		GpuClass(void){
			for (int i = 0; i < N; i++){
				arr[i] = i;
			}
		}
	
		// Methods
	//	__global__ void sayHello(void){ printf("hello from global function from class !\n");} // this is forbidden
		__device__  int printNumb(int i){return arr[i];}
		
};

__global__ void testClass(GpuClass obj){
	printf("Returned value : %d\n", obj.printNumb(21));
}

int main(int argc, char **argv)
{

	GpuClass myObj;
	myObj.printNumb(2); // this is forbidden if method not declared __host__
//	myObj.sayHello<<<1,1>>>();
	testClass<<<1, 1>>>(myObj);
	SYNCGPU();
	return 0;
}
