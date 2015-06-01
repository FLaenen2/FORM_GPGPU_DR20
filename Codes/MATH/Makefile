CU_APPS = floating-point-accuracy floating-point-perf intrinsic-standard-comp\
    nbody
C_APPS=

all: ${C_APPS} ${CU_APPS}

%: %.cu
	nvcc -ccbin=gcc -Xcompiler -fopenmp -O2 -arch=sm_20 -o $@ $<
%: %.c
	gcc -O2 -std=c99 -o $@ $<
clean:
	rm -f ${CU_APPS} ${C_APPS}
