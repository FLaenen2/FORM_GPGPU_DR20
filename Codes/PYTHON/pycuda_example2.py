import pycuda.driver as cuda
import pycuda.autoinit
from pycuda.compiler import SourceModule
import numpy as np

# Create a host array
a = np.random.randn(4,4).astype(np.float32)

# Allocate memory on device
a_gpu = cuda.mem_alloc(a.nbytes)

# Copy data from host to device
cuda.memcpy_htod(a_gpu, a)

# Write a kernel
mod = SourceModule("""
  __global__ void doublify(float *a)
  {
    int idx = threadIdx.x + threadIdx.y*4;
    a[idx] *= 2;
  }
  """)

# Retrieve the function in python
func = mod.get_function("doublify")
# Execute it
func(a_gpu, block=(4,4,1))

# Note : shortcut 
# Instead of manually allocating and copying 
# InOut tells the cpu to copy a to device before launching func than retrieve it after func is finished
#func(cuda.InOut(a), block=(4, 4, 1))

# Fetch the data from the GPU
a_doubled = numpy.empty_like(a)
cuda.memcpy_dtoh(a_doubled, a_gpu)

# Print result
print(a_doubled)
print(a)
