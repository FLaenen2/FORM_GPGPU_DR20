CU_APPS = hello_world arrays_sum_1D

all: ${C_APPS} ${CU_APPS}

%: %.cu
	nvcc -I/usr/local/cuda/samples/common/inc -ccbin=gcc -lcublas -O2 -arch=sm_20 -lcurand -o $@ $<
clean:
	rm -f ${CU_APPS} ${C_APPS}
