CU_APPS =  zip_iterator algorithms1 thrust_copy scalar_product transform random_gen radixSortThrust device_ptrs

all: ${C_APPS} ${CU_APPS}

%: %.cu
	nvcc -I/usr/local/cuda/samples/common/inc/ -ccbin=gcc -O2 -arch=sm_20 -o $@ $<
clean:
	rm -f ${CU_APPS} ${C_APPS}
