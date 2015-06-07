#include <stdlib.h>  
#include <time.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <math.h>

#define N 100

extern void drawLines2D(float *, float *, int, char *, int);


int main(int argc, char** argv){
    float *x, *y;
    srand(time(NULL));
    x = (float *) malloc(N*sizeof(float));
    y = (float *) malloc(N*sizeof(float));
    for (int i = 0; i < N; i++){
	x[i] = 2.* (float)i/N - 1;
	y[i] = sin(2.*M_PI*x[i]);
    }
    for (int it = 0; it < 100; it++){
	for (int i = 0; i < N; i++){
	    y[i] += ((float) rand() / 50. /RAND_MAX) - 0.01;
	}
	if (!(it % 10)){
	    printf("displaying lines it %d\n", it);
	    char title[50];
	    sprintf(title, "Points it %d", it);
	    printf("displaying points it %d\n", it);
	    drawLines2D(x, y, N, title, 0);
	    sleep(1);
	}
    }
    return 0;
}
