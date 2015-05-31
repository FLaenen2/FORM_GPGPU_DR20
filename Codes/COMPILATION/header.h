
#ifndef __HEADER_H
#define __HEADER_H

#include <stdio.h>
#if defined(__NVCC__)

void say_hello(void){
    printf("hello\n");
}

#endif

__global__ void kernel(void);

#endif
