// System includes
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <cstdlib>

// CUDA runtime
#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <cuda.h>

// C: array which contains result of compuation of histogram
// A: input array
__global__ void histo_kernel(int *A, int a_length, int *C, int c_length){
	__shared__ int* block_local_histo;
	if(threadIdx.x == 0){
		block_local_histo = (int *)malloc(c_length * sizeof(int));
	}
	__syncthreads();
	if(threadIdx.x < c_length) block_local_histo[threadIdx.x] = 0;
	__syncthreads();
	//printf("bug");
	int i = threadIdx.x + blockIdx.x * blockDim.x;	
	int stride = blockDim.x * gridDim.x;
    while (i < a_length) {
        atomicAdd(&(block_local_histo[A[i]]),1);
        i += stride;
    }
	__syncthreads();
	if (threadIdx.x < c_length) {
		atomicAdd(&(C[threadIdx.x]), block_local_histo[threadIdx.x] );
	}
}


void constantInit(int *data, int size, int range)
{
	for (int i = 0; i < size; ++i)
	{
		data[i] = rand() % range;
	}
}

void print(int* h_C, int c_length, int* h_A, int a_length){

	for(int i = 0; i < c_length; i++){
		printf("%d, ", h_C[i]);
	}
	printf("\n");
	for(int i = 0; i < a_length; i++){
		printf("%d, ", h_A[i]);
	}
}

/**
* Run a simple test of histogram calculation using CUDA
*/
int histogram_calc(int argc, char **argv, int n, int range)
{	
	// Allocate host memory for array A
	unsigned int size_A = n;
	unsigned int mem_size_A = sizeof(int)* size_A;
	int *h_A = (int *)malloc(mem_size_A);
	
	// Initialize host memory
	constantInit(h_A, size_A, range);
	
	// Allocate device memory
	int *d_A, *d_C;

	// Allocate host matrix C
	unsigned int mem_size_C = range * sizeof(int);
	int *h_C = (int *)malloc(mem_size_C);

	if (h_C == NULL)
	{
		fprintf(stderr, "Failed to allocate host matrix C!\n");
		exit(EXIT_FAILURE);
	}

	cudaError_t error;

	error = cudaMalloc((void **)&d_A, mem_size_A);

	if (error != cudaSuccess)
	{
		printf("cudaMalloc d_A returned error %s (code %d), line(%d)\n", cudaGetErrorString(error), error, __LINE__);
		exit(EXIT_FAILURE);
	}

	error = cudaMalloc((void **)&d_C, mem_size_C);
	
	if (error != cudaSuccess)
	{
		printf("cudaMalloc d_C returned error %s (code %d), line(%d)\n", cudaGetErrorString(error), error, __LINE__);
		exit(EXIT_FAILURE);
	}

	// copy host memory to device
	error = cudaMemcpy(d_A, h_A, mem_size_A, cudaMemcpyHostToDevice);

	if (error != cudaSuccess)
	{
		printf("cudaMemcpy (d_A,h_A) returned error %s (code %d), line(%d)\n", cudaGetErrorString(error), error, __LINE__);
		exit(EXIT_FAILURE);
	}

	// Setup execution parameters
	dim3 DimGrid(1,1,1);
	dim3 DimBlock(1024,1,1);
	
	// Create and start timer
	printf("Computing result using CUDA Kernel...\n");

	// Allocate CUDA events that we'll use for timing
	cudaEvent_t start;
	error = cudaEventCreate(&start);

	if (error != cudaSuccess)
	{
		fprintf(stderr, "Failed to create start event (error code %s)!\n", cudaGetErrorString(error));
		exit(EXIT_FAILURE);
	}

	cudaEvent_t stop;
	error = cudaEventCreate(&stop);

	if (error != cudaSuccess)
	{
		fprintf(stderr, "Failed to create stop event (error code %s)!\n", cudaGetErrorString(error));
		exit(EXIT_FAILURE);
	}

	// Record the start event
	error = cudaEventRecord(start, NULL);

	if (error != cudaSuccess)
	{
		fprintf(stderr, "Failed to record start event (error code %s)!\n", cudaGetErrorString(error));
		exit(EXIT_FAILURE);
	}

	// Execute the kernel
	
	histo_kernel <<< DimGrid, DimBlock>>> (d_A, n, d_C, range);
	
	error = cudaGetLastError();
	if (error != cudaSuccess)
	{
		fprintf(stderr, "Failed to launch kernel!\n", cudaGetErrorString(error));
		exit(EXIT_FAILURE);
	}

	// Record the stop event
	error = cudaEventRecord(stop, NULL);

	if (error != cudaSuccess)
	{
		fprintf(stderr, "Failed to record stop event (error code %s)!\n", cudaGetErrorString(error));
		exit(EXIT_FAILURE);
	}

	// Wait for the stop event to complete
	error = cudaEventSynchronize(stop);

	if (error != cudaSuccess)
	{
		fprintf(stderr, "Failed to synchronize on the stop event (error code %s)!\n", cudaGetErrorString(error));
		exit(EXIT_FAILURE);
	}

	float msecTotal = 0.0f;
	error = cudaEventElapsedTime(&msecTotal, start, stop);

	printf("Elapsed time in msec = %f\n", msecTotal);

	if (error != cudaSuccess)
	{
		fprintf(stderr, "Failed to get time elapsed between events (error code %s)!\n", cudaGetErrorString(error));
		exit(EXIT_FAILURE);
	}

	// Copy result from device to host
	error = cudaMemcpy(h_C, d_C, mem_size_C, cudaMemcpyDeviceToHost);

	if (error != cudaSuccess)
	{
		printf("cudaMemcpy (h_C,d_C) returned error %s (code %d), line(%d)\n", cudaGetErrorString(error), error, __LINE__);
		exit(EXIT_FAILURE);
	}
	
	//print(h_C, range, h_A, n);
	

	// Clean up memory
	free(h_A);
	free(h_C);
	cudaFree(d_A);
	cudaFree(d_C);

	return EXIT_SUCCESS;

}


/**
* Program main
*/
int main(int argc, char **argv)
{
	printf("[Histogram Calculation Using CUDA] - Starting...\n");

	// By default, we use device 0
	int devID = 0;
	cudaSetDevice(devID);

	cudaError_t error;
	cudaDeviceProp deviceProp;
	error = cudaGetDevice(&devID);

	if (error != cudaSuccess)
	{
		printf("cudaGetDevice returned error %s (code %d), line(%d)\n", cudaGetErrorString(error), error, __LINE__);
	}

	error = cudaGetDeviceProperties(&deviceProp, devID);

	if (deviceProp.computeMode == cudaComputeModeProhibited)
	{
		fprintf(stderr, "Error: device is running in <Compute Mode Prohibited>, no threads can use ::cudaSetDevice().\n");
		exit(EXIT_SUCCESS);
	}

	if (error != cudaSuccess)
	{
		printf("cudaGetDeviceProperties returned error %s (code %d), line(%d)\n", cudaGetErrorString(error), error, __LINE__);
	}
	else
	{
		printf("GPU Device %d: \"%s\" with compute capability %d.%d\n\n", devID, deviceProp.name, deviceProp.major, deviceProp.minor);
	}

	// Size of input array
	int input_array_length = 1000000;
	// Size of input array
	int range = 5000;
	
	int result = histogram_calc(argc, argv, input_array_length, range);
	exit(result);
}
