#include <stdlib.h>  
#include <time.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <thrust/device_vector.h>
#define N 100

extern void drawPoints(int, char **, int, int);

int n = N;


template<typename T>
struct Rand{
	T operator()(){ return static_cast<T>(2.*rand() / RAND_MAX - 1)};
};

int main(int argc, char** argv){

	float *x, *y;
    srand(time(NULL));
	host_vector<float> x(100), y(100);
	generate(x.begin(), x.end(), Rand<float>());
	generate(y.begin(), y.end(), Rand<float>());
	float *d_x = raw_poiinter_cast(x.data());
	for (int it = 0; it < 50; it++){
//	printf("it %d\n", it);
	for (int i = 0; i < N; i++){
	    x[i] = (float)2.*rand()/RAND_MAX-1;
	    y[i] = (float)2.*rand()/RAND_MAX-1;
	}
	if (!(it % 10)){
	    printf("displaying points it %d\n", it);
	    drawPoints_gpu(argc, argv, it, 1);
	    sleep(1);
	}
    }
    return 0;
}
