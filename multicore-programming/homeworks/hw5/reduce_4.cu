#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include<stdlib.h>
#include <omp.h>
#include<iostream>
#include <cstdlib>
#include <vector>
#include <chrono>
#include <cmath>
#include <numeric>

// N = 2^27
#define N pow(2, 27)

#define THREAD_COUNT 256
#define BLOCK_COUNT 262144

using namespace std;

__global__ void reduce4(int *g_idata, int *g_odata) {
	__shared__ int sdata[THREAD_COUNT];
	// each thread loads one element from global to shared mem
	// perform first level of reduction,
	// reading from global memory, writing to shared memory
	unsigned int tid = threadIdx.x;
	unsigned int i = blockIdx.x*(blockDim.x*2) + threadIdx.x;
	sdata[tid] = g_idata[i] + g_idata[i+blockDim.x];
	__syncthreads();
	// do reduction in shared mem
	for (unsigned int s=blockDim.x/2; s>32; s>>=1) {
		if (tid < s) {
			sdata[tid] += sdata[tid + s];
		}
		__syncthreads();
	}
	if (tid < 32)
	{
		sdata[tid] += sdata[tid + 32];
		sdata[tid] += sdata[tid + 16];
		sdata[tid] += sdata[tid + 8];
		sdata[tid] += sdata[tid + 4];
		sdata[tid] += sdata[tid + 2];
		sdata[tid] += sdata[tid + 1];
	}
	// write result for this block to global mem
	if (tid == 0) {
		g_odata[blockIdx.x] = sdata[0];
		//printf("%d\n" , g_odata[blockIdx.x]);
	}
}


int main()
{
		cudaSetDevice(0);
		int* a_0 = (int*)malloc(N * sizeof(int));
		int* b_0 = (int*)malloc(BLOCK_COUNT * sizeof(int));
		int *dev_a_0 = 0;
		int *dev_b_0 = 0;
		
		int my_sum = 0;
		for (unsigned long long i = 0; i < N ;i++){
			a_0[i] = (int)rand() % 10;
			my_sum += a_0[i];
		}
		for (unsigned long long i = 0; i < BLOCK_COUNT ;i++){
			b_0[i] = 0;
		}
		
		cout<<"total sum in a: "<<my_sum<<endl;
		
		cudaError_t cudaStatus;

		double start_time = omp_get_wtime();

		cudaStatus = cudaMalloc((void**)&dev_a_0, N * sizeof(int));
		
		if (cudaStatus != cudaSuccess) {
			fprintf(stderr, "cudaMalloc dev_a failed!");
			cudaFree(dev_a_0);
			free(a_0);
			free(b_0);
			return 1;
		}
		
		cudaStatus = cudaMalloc((void**)&dev_b_0, BLOCK_COUNT * sizeof(int));
		
		if (cudaStatus != cudaSuccess) {
			fprintf(stderr, "cudaMalloc dev_a failed!");
			cudaFree(dev_a_0);
			cudaFree(dev_b_0);
			free(a_0);
			free(b_0);
			return 1;
		}
			
		cudaMemcpy(dev_a_0, a_0, N * sizeof(int), cudaMemcpyHostToDevice);
		
		double t1 = omp_get_wtime();
		reduce4 << <BLOCK_COUNT, THREAD_COUNT>> > (dev_a_0, dev_b_0);
		cudaDeviceSynchronize();
		double t2 = omp_get_wtime();
		std::cout <<"computational time: "<<t2 - t1<<endl;
		
		cudaMemcpy(b_0, dev_b_0, BLOCK_COUNT * sizeof(int), cudaMemcpyDeviceToHost);
		
		double end_time = omp_get_wtime();
		std::cout <<"time: "<<end_time - start_time<<endl;
		
		my_sum = 0;
		for (unsigned long long i = 0; i < BLOCK_COUNT ;i++){
			my_sum += b_0[i];
		}
		
		cout<<"total sum in a (computed in GPU): "<<my_sum<<endl;
		
		cudaFree(dev_a_0);
		cudaFree(dev_b_0);
		free(a_0);
		free(b_0);
		
		cudaStatus = cudaDeviceReset();
		if (cudaStatus != cudaSuccess) {
			fprintf(stderr, "cudaDeviceReset failed!");
			return 1;
		}
		
		return 0;
}