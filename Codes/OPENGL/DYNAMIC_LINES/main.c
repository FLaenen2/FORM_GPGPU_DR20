#include <stdlib.h>  
#include <time.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#define N 100

extern void drawPoints(int, char **, int, int);
float *x, *y;

int n = N;

int main(int argc, char** argv){

    srand(time(NULL));
    x = (float *) malloc(N*sizeof(float));
    y = (float *) malloc(N*sizeof(float));
    for (int i = 0; i < N; i++){
	x[i] = (float)i/N - 1 + eps;
	y[i] = sin(2.*M_PI*x[i]) + eps;
    }
    for (int it = 0; it < 50; it++){
	    x[i] = (float)2.*rand()/RAND_MAX-1;
	    y[i] += (float) rand() / 10 ./RAND_MAX;
	}
	if (!(it % 10)){
	    printf("displaying points it %d\n", it);
	    drawLines(argc, argv, it, 1);
	    sleep(1);
	}
    }
    return 0;
}
