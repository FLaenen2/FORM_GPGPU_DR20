CU_APPS = rand_kernel poisson

all: ${C_APPS} ${CU_APPS}

%: %.cu
	nvcc -I/usr/local/cuda/samples/common/inc -lcurand -O2 -arch=sm_20 -o $@ $<
clean:
	rm -f ${CU_APPS} ${C_APPS}
