CU_APPS = gemv inversion
C_APPS = simpleCUBLAS batchCUBLAS
DEBUG = -g -G
all: ${C_APPS} ${CU_APPS}

%: %.cu
	nvcc $(DEBUG) -ccbin=gcc -I/usr/local/cuda/samples/common/inc/ -lcublas -O2 -arch=sm_20 -lcurand -o $@ $<
%: %.cpp
	gcc -O2 -I/usr/local/cuda/samples/common/inc/ -I/usr/local/cuda/include/ -L/usr/local/cuda/lib -lcudart -lcublas -o $@ $<
clean:
	rm -f ${CU_APPS} ${C_APPS}
