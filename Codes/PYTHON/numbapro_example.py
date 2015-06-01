import numpy as np
from timeit import default_timer as timer
from numbapro import vectorize

@vectorize(["float32(float32, float32)"], target="gpu")
def VectorAdd_GPU(a, b):
    return a + b

def VectorAdd(a, b):
    return a + b

def VectorAdd_naive(a, b):
	N = 32000000
	c = np.ones(N, dtype=np.float32)
	for i in range(a.size):
		c[i] = a[i] + b[i]
	return c

def main():

    N = 3200000

    A = np.ones(N, dtype=np.float32);
    B = np.ones(N, dtype=np.float32);
    C = np.ones(N, dtype=np.float32);

    start = timer()
    C = VectorAdd_naive(A, B);
    vectoradd_time = timer() - start
    print("C[:5] = " + str(C[5:]))
    print("C[-5:] = " + str(C[-5:]))
    print("VectorAdd_naive took %f seconds" % vectoradd_time)

    start = timer()
    C = VectorAdd(A, B);
    vectoradd_time = timer() - start
    print("C[:5] = " + str(C[5:]))
    print("C[-5:] = " + str(C[-5:]))
    print("VectorAdd took %f seconds" % vectoradd_time)
    
    start = timer()
    C = VectorAdd_GPU(A, B);
    vectoradd_time = timer() - start
    print("C[:5] = " + str(C[5:]))
    print("C[-5:] = " + str(C[-5:]))
    print("VectorAdd_GPU took %f seconds" % vectoradd_time)

if __name__ == '__main__' :
    main()
