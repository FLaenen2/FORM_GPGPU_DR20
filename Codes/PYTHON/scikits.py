import pycuda.gpuarray as gpuarray
import scikits.cuda  as sc
import numpy as np

x = gpuarray.to_gpu(np.arange(10))
y = gpuarray.to_gpu(np.arange(10))
z = sc.linalg.multiply(x, y)
print(z)

