#include <stdlib.h>  
#include <time.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#define N 100

extern void drawPoints2D(float *, float *, char *, int);
float *x, *y;

int n = N;

int main(int argc, char** argv){

    srand(time(NULL));
    x = (float *) malloc(N*sizeof(float));
    y = (float *) malloc(N*sizeof(float));
    for (int it = 0; it < 50; it++){
//	printf("it %d\n", it);
	for (int i = 0; i < N; i++){
	    x[i] = (float)2.*rand()/RAND_MAX-1;
	    y[i] = (float)2.*rand()/RAND_MAX-1;
	}
	if (!(it % 10)){
	    printf("displaying points it %d\n", it);
		
    char title[50];
    sprintf(title, "Points it %d", it);
	    drawPoints2D(x, y, title.c_str(), 1);
	    sleep(1);
	}
    }
    return 0;
}
