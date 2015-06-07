CU_APPS= reduceInteger readSegment writeSegment simpleMathAoS simpleMathSoA sumMatrix\
    readSegmentUnroll
C_APPS=

all: ${C_APPS} ${CU_APPS}

%: %.cu
	#nvcc -O3 -I../COMMON/ -Xptxas -dlcm=ca -arch=sm_20 -o $@ $<
	nvcc -O2 -I/usr/local/cuda/samples/common/inc -I../COMMON/ -arch=sm_30 -o $@ $<
%: %.c
	gcc -O2 -std=c99 -o $@ $<
clean:
	rm -f ${CU_APPS} ${C_APPS}
