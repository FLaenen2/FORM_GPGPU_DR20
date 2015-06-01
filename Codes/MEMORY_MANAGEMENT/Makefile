CU_APPS = memory_management pinMemTransfer
C_APPS=

all: ${C_APPS} ${CU_APPS}

%: %.cu
	nvcc -ccbin=gcc -o $@ $<
%: %.c
	gcc -O2 -std=c99 -o $@ $<
clean:
	rm -f ${CU_APPS} ${C_APPS}
