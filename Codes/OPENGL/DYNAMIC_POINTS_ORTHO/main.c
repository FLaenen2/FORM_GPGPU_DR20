#include <stdlib.h>  
#include <time.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#define N 100

extern void drawPoints2D(float *, float *, int, char *, int);


int main(int argc, char** argv){

    float *x, *y;
    srand(time(NULL));
    x = (float *) malloc(N*sizeof(float));
    y = (float *) malloc(N*sizeof(float));
    for (int it = 0; it < 50; it++){
//	printf("it %d\n", it);
	for (int i = 0; i < N; i++){
	    x[i] = (float)20.*rand()/RAND_MAX; // now points are between 0 and 20 and will fit in the default coordinates system [-1 1 ; -1 1] -> need an orthographic projection
	    y[i] = (float)20.*rand()/RAND_MAX;
	}
	if (!(it % 10)){
	    printf("displaying points it %d\n", it);
	    char title[50];
	    sprintf(title, "Points it %d", it);
	    drawPoints2D(x, y, N, title, 1);
	    sleep(1);
	}
    }
    return 0;
}
