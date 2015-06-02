% WARNING : gpuArray in Matlab needs the Parallel Computing Toolbox
clear all;

% Get number of devices
n_devices = gpuDeviceCount();
% Set the current device and get infos at the same time
g = gpuDevice(1);
% Reset previously allocated memory
reset(g);
% Display any property of the device
fprintf('Available memory on device : %d Mo\n', g.AvailableMemory() / 1e6);


N = 100000;
% Construct a gpuArray
d_x = ones(1, N, 'gpuArray');

% You can also build a gpuArray passing a host container as argument
r1 = rand(1, N);
d_r1 = gpuArray(r1);
r2 = rand(1, N);
d_r2 = gpuArray(r2);

% Compute a sum on host
tic
h_sum = r1 + r2;
toc

% Compute a sum on device. tic and toc are not correct to measure time on
% gpu, use gputimeit instead.

d_sum = d_r1 + d_r2;
f = @() (d_r1 + d_r2);
t = gputimeit(f)

% Check equality. 
fprintf('Error between sums = %g\n', sum(abs(h_sum - d_sum)))

% Use gather to collect the result to Matlab workspace
h_sum = gather(d_sum);

% Available functions : arrayfun, bsxfun... see help

% Use of custom kernel : example with add.cu. Compile with 
!/usr/local/cuda/bin/nvcc -ptx add.cu
% -> add.ptx
% Create a CUDAkernel object with the following :
kern = parallel.gpu.CUDAKernel('add.ptx','add.cu');
kern.ThreadBlockSize = 128;
kern.GridSize = ceil(N/128);
d_sum2 = feval(kern, d_r1, d_r2, 1, N);
fprintf('Error between result of feval and h_sum = %g\n', sum(abs(d_r1 - h_sum)));


% SPOILER : Perform a fast convolution

a = complex(randn(4096,100), randn(4096,100));   % Data input
b = randn(16,1);                                % Filter input
c = fastConvolution_v2(a,b);                    % Calculate output
ctime = timeit(@()fastConvolution_v2(a,b));     % Measure CPU time
disp(['Execution time fast_convol on CPU = ', num2str(ctime)]);

ga = gpuArray(a);                               % Move data to GPU
gb = gpuArray(b);                               % Move filter to GPU
gc = fastConvolution_v2(ga, gb);                % Calculate on GPU
gtime = gputimeit(@()fastConvolution_v2(ga,gb));% Measure GPU time
gerr = max(max(abs(gather(gc)-c)));             % Calculate error
disp(['Execution time fast_convol on GPU = ', num2str(gtime)]);
disp(['Maximum absolute error = ', num2str(gerr)]);
