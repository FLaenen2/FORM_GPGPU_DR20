CU_APPS = cufft1D  heat_kernel cufft2D
C_APPS=

all: ${C_APPS} ${CU_APPS}

%: %.cu
	nvcc -I/usr/local/cuda/samples/common/inc -ccbin=gcc -lcufft -O2 -arch=sm_20 -o $@ $<
%: %.c
	gcc -O2 -std=c99 -o $@ $<
clean:
	rm -f ${CU_APPS} ${C_APPS}
