
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include<stdlib.h>
#include <omp.h>
#include<iostream>
#define MAX_HISTORGRAM_NUMBER 10000
#define ARRAY_SIZE 102400000

#define CHUNK_SIZE 100
#define THREAD_COUNT 8
#define BLOCK_COUNT 128000
#define SCALER 20
cudaError_t histogramWithCuda(int *a, unsigned long long int *c);

__global__ void histogramKernelSingle(unsigned long long int *c, int *a)
{
	unsigned long long int worker =  blockIdx.x*blockDim.x + threadIdx.x;
	unsigned long long int start = worker * CHUNK_SIZE;
	unsigned long long int end = start + CHUNK_SIZE;
	for (int ex = 0; ex < SCALER; ex++)
		for (long long int i = start; i < end; i++)
		{
			if (i < ARRAY_SIZE)
				atomicAdd(&c[a[i]], 1);
			else
			{

				break;
			}
		}

}
int main()
{
		int* a = (int*)malloc(sizeof(int)*ARRAY_SIZE);
		unsigned long long int* c = (unsigned long long int*)malloc(sizeof(unsigned long long int)*MAX_HISTORGRAM_NUMBER);
		for (unsigned long long i = 0; i < ARRAY_SIZE;i++)
			a[i] = rand() % MAX_HISTORGRAM_NUMBER;
		for (unsigned long long i = 0; i < MAX_HISTORGRAM_NUMBER; i++)
			c[i] = 0;

    // Add vectors in parallel.
		double start_time = omp_get_wtime();
		cudaError_t cudaStatus=histogramWithCuda(a,c);
		double end_time = omp_get_wtime();
		std::cout << end_time - start_time;
   // = 
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "addWithCuda failed!");
        return 1;
    }

    
    // cudaDeviceReset must be called before exiting in order for profiling and
    // tracing tools such as Nsight and Visual Profiler to show complete traces.
    cudaStatus = cudaDeviceReset();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaDeviceReset failed!");
        return 1;
    }
	unsigned long long int R = 0;
	for (int i = 0; i < MAX_HISTORGRAM_NUMBER; i++)
	{
		R += c[i];
//		printf("%d	", c[i]);
	}
	printf("\nCORRECT:%ld	", R/(SCALER));
    return 0;
}

// Helper function for using CUDA to add vectors in parallel.
cudaError_t histogramWithCuda(int *a, unsigned long long int *c)
{
    int *dev_a = 0;
	unsigned long long int *dev_c = 0;
    cudaError_t cudaStatus;

    // Choose which GPU to run on, change this on a multi-GPU system.
    cudaStatus = cudaSetDevice(0);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaSetDevice failed!  Do you have a CUDA-capable GPU installed?");
        goto Error;
    }

    // Allocate GPU buffers for three vectors (two input, one output)    .
    cudaStatus = cudaMalloc((void**)&dev_c, MAX_HISTORGRAM_NUMBER * sizeof(unsigned long long int));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

    cudaStatus = cudaMalloc((void**)&dev_a, ARRAY_SIZE * sizeof(int));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }


    // Copy input vectors from host memory to GPU buffers.
    cudaStatus = cudaMemcpy(dev_a, a, ARRAY_SIZE * sizeof(int), cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }
    // Launch a kernel on the GPU with one thread for each element.
	//// BLOCK CALCULATOR HERE
	

	////BLOCK CALCULATOR HERE

	//dim3 blockSize(2000,1,1);
		histogramKernelSingle << <BLOCK_COUNT, THREAD_COUNT>> > (dev_c, dev_a);
    // Check for any errors launching the kernel
    cudaStatus = cudaGetLastError();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "addKernel launch failed: %s\n", cudaGetErrorString(cudaStatus));
        goto Error;
    }
    
    // cudaDeviceSynchronize waits for the kernel to finish, and returns
    // any errors encountered during the launch.
    cudaStatus = cudaDeviceSynchronize();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching addKernel!\n", cudaStatus);
        goto Error;
    }

    // Copy output vector from GPU buffer to host memory.
    cudaStatus = cudaMemcpy(c, dev_c, MAX_HISTORGRAM_NUMBER * sizeof(unsigned long long int), cudaMemcpyDeviceToHost);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }
	
Error:
    cudaFree(dev_c);
    cudaFree(dev_a);
    return cudaStatus;
}
