APP = example
CC=g++
    all:    ${APP}
%: %.cu
	nvcc -m64 -arch=sm_20 -I/usr/local/cuda/samples/common/inc/ -ccbin $(CC) $(FILE) -o $@ $< 
clean : 
	rm $(EXE)
    
    
