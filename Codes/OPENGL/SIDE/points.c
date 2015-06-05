#include <stdlib.h>  
#include <time.h>
#include <stdio.h>

#define N 100

float *x, *y;

int n = N;

int main(int argc, char** argv){

    srand(time(NULL));
    x = malloc(N*sizeof(float));
    y = malloc(N*sizeof(float));
    for (int it = 0; it < 100; it++){
	printf("it %d\n", it);
	for (int i = 0; i < N; i++){
	    x[i] = (float)2.*rand()/RAND_MAX-1;
	    y[i] = (float)2.*rand()/RAND_MAX-1;
	}
	if (!(it % 10)){
	    printf("displaying points it %d\n", it);
	    drawPoints(argc, argv, it);
	    sleep(2);
	}
    }
    return 0;
}
