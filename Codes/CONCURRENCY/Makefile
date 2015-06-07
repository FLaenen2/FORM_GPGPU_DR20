CU_APPS = simpleHyperqDepth simpleHyperqBreadth simpleConcurrency 

all: ${C_APPS} ${CU_APPS}

%: %.cu
	nvcc -O2 -arch=sm_20 -o $@ $<
clean:
	rm -f ${CU_APPS} ${C_APPS}
