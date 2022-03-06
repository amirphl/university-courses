
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include<stdlib.h>
#include <omp.h>
#include<iostream>
#define MAX_HISTORGRAM_NUMBER 10000
#define ARRAY_SIZE 81920000
#define tike 25600000


#define CHUNK_SIZE 1000
#define THREAD_COUNT 1024
#define BLOCK_COUNT 200
#define SCALER 20

__global__ void histogramKernelSingle(unsigned long long int *c, int *a)
{
	unsigned long long int worker =  blockIdx.x*blockDim.x + threadIdx.x;
	unsigned long long int start = worker * CHUNK_SIZE;
	unsigned long long int end = start + CHUNK_SIZE;
	for (int ex = 0; ex < SCALER; ex++)
		for (long long int i = start; i < end; i++)
		{
			if (i < ARRAY_SIZE / 4)
				atomicAdd(&c[a[i]], 1);
			else
				break;
		}

}


int main()
{
		cudaSetDevice(0);
		//int* a_0 = (int*)malloc(sizeof(int)*ARRAY_SIZE/4);
		//int* a_1 = (int*)malloc(sizeof(int)*ARRAY_SIZE/4);
		//int* a_2 = (int*)malloc(sizeof(int)*ARRAY_SIZE/4);
		//int* a_3 = (int*)malloc(sizeof(int)*ARRAY_SIZE/4);
		int* a_0;
		int* a_1;
		int* a_2;
		int* a_3;
		
		
		cudaMallocHost((void**)&a_0, ARRAY_SIZE * sizeof(int) / 4);
		cudaMallocHost((void**)&a_1, ARRAY_SIZE * sizeof(int) / 4);
		cudaMallocHost((void**)&a_2, ARRAY_SIZE * sizeof(int) / 4);
		cudaMallocHost((void**)&a_3, ARRAY_SIZE * sizeof(int) / 4);
		
		
		int* b = (int*)malloc(sizeof(int)*ARRAY_SIZE/4);
		
		
		unsigned long long int *c_0 = (unsigned long long int*)malloc(MAX_HISTORGRAM_NUMBER * sizeof(unsigned long long int));
		unsigned long long int *c_1 = (unsigned long long int*)malloc(MAX_HISTORGRAM_NUMBER * sizeof(unsigned long long int));
		unsigned long long int *c_2 = (unsigned long long int*)malloc(MAX_HISTORGRAM_NUMBER * sizeof(unsigned long long int));
		unsigned long long int *c_3 = (unsigned long long int*)malloc(MAX_HISTORGRAM_NUMBER * sizeof(unsigned long long int));
		
		
		int *dev_a_0 = 0;
		int *dev_a_1 = 0;
		int *dev_a_2 = 0;
		int *dev_a_3 = 0;
		
		unsigned long long int *dev_c_0 = 0;
		unsigned long long int *dev_c_1 = 0;
		unsigned long long int *dev_c_2 = 0;
		unsigned long long int *dev_c_3 = 0;
		
		
		for (unsigned long long i = 0; i < ARRAY_SIZE/4 ;i++){
			//a_0[i] = rand() % MAX_HISTORGRAM_NUMBER;
			//a_1[i] = rand() % MAX_HISTORGRAM_NUMBER;
			//a_2[i] = rand() % MAX_HISTORGRAM_NUMBER;
			//a_3[i] = rand() % MAX_HISTORGRAM_NUMBER;
			b[i] = rand() % MAX_HISTORGRAM_NUMBER;
		}
		
		
		memcpy(a_0, b, ARRAY_SIZE * sizeof(int) / 4);
		memcpy(a_1, b, ARRAY_SIZE * sizeof(int) / 4);
		memcpy(a_2, b, ARRAY_SIZE * sizeof(int) / 4);
		memcpy(a_3, b, ARRAY_SIZE * sizeof(int) / 4);
		
		
		memset(c_0, 0, MAX_HISTORGRAM_NUMBER * sizeof(unsigned long long int));
		memset(c_1, 0, MAX_HISTORGRAM_NUMBER * sizeof(unsigned long long int));
		memset(c_2, 0, MAX_HISTORGRAM_NUMBER * sizeof(unsigned long long int));
		memset(c_3, 0, MAX_HISTORGRAM_NUMBER * sizeof(unsigned long long int));
		
		
		cudaError_t cudaStatus;

    
		double start_time = omp_get_wtime();

		
		cudaStatus = cudaMalloc((void**)&dev_a_0, ARRAY_SIZE * sizeof(int) / 4);
		cudaStatus = cudaMalloc((void**)&dev_a_1, ARRAY_SIZE * sizeof(int) / 4);
		cudaStatus = cudaMalloc((void**)&dev_a_2, ARRAY_SIZE * sizeof(int) / 4);
		cudaStatus = cudaMalloc((void**)&dev_a_3, ARRAY_SIZE * sizeof(int) / 4);
		if (cudaStatus != cudaSuccess) {
			fprintf(stderr, "cudaMalloc dev_a failed!");
			cudaFree(dev_a_0);
			cudaFree(dev_a_1);
			cudaFree(dev_a_2);
			cudaFree(dev_a_3);
			cudaFreeHost(a_0);
			cudaFreeHost(a_1);
			cudaFreeHost(a_2);
			cudaFreeHost(a_3);
			free(c_0);
			free(c_1);
			free(c_2);
			free(c_3);
			free(b);
			return 1;
		}
			
			
		cudaStatus = cudaMalloc((void**)&dev_c_0, MAX_HISTORGRAM_NUMBER * sizeof(unsigned long long int));
		cudaStatus = cudaMalloc((void**)&dev_c_1, MAX_HISTORGRAM_NUMBER * sizeof(unsigned long long int));
		cudaStatus = cudaMalloc((void**)&dev_c_2, MAX_HISTORGRAM_NUMBER * sizeof(unsigned long long int));
		cudaStatus = cudaMalloc((void**)&dev_c_3, MAX_HISTORGRAM_NUMBER * sizeof(unsigned long long int));
		if (cudaStatus != cudaSuccess) {
			fprintf(stderr, "cudaMalloc dev_c failed!");
			cudaFree(dev_c_0);
			cudaFree(dev_c_1);
			cudaFree(dev_c_2);
			cudaFree(dev_c_3);
			cudaFreeHost(a_0);
			cudaFreeHost(a_1);
			cudaFreeHost(a_2);
			cudaFreeHost(a_3);
			free(c_0);
			free(c_1);
			free(c_2);
			free(c_3);
			free(b);
			return 1;
		}
		
		
		cudaStream_t stream_0;
		cudaStream_t stream_1;
		cudaStream_t stream_2;
		cudaStream_t stream_3;
		cudaStreamCreate(&stream_0);
		cudaStreamCreate(&stream_1);
		cudaStreamCreate(&stream_2);
		cudaStreamCreate(&stream_3);
		
			
		cudaMemcpyAsync(dev_a_0, a_0, ARRAY_SIZE * sizeof(int) / 4, cudaMemcpyHostToDevice, stream_0);
		cudaMemcpyAsync(dev_c_0, c_0, MAX_HISTORGRAM_NUMBER * sizeof(unsigned long long int), cudaMemcpyHostToDevice, stream_0);
		histogramKernelSingle << <BLOCK_COUNT, THREAD_COUNT, 0, stream_0>> > (dev_c_0, dev_a_0);
		
		cudaMemcpyAsync(dev_a_1, a_1, ARRAY_SIZE * sizeof(int) / 4, cudaMemcpyHostToDevice, stream_1);
		cudaMemcpyAsync(dev_c_1, c_1, MAX_HISTORGRAM_NUMBER * sizeof(unsigned long long int), cudaMemcpyHostToDevice, stream_1);
		histogramKernelSingle << <BLOCK_COUNT, THREAD_COUNT, 0, stream_1>> > (dev_c_1, dev_a_1);
		
		cudaMemcpyAsync(dev_a_2, a_2, ARRAY_SIZE * sizeof(int) / 4, cudaMemcpyHostToDevice, stream_2);
		cudaMemcpyAsync(dev_c_2, c_2, MAX_HISTORGRAM_NUMBER * sizeof(unsigned long long int), cudaMemcpyHostToDevice, stream_2);
		histogramKernelSingle << <BLOCK_COUNT, THREAD_COUNT, 0, stream_2>> > (dev_c_2, dev_a_2);
		
		cudaMemcpyAsync(dev_a_3, a_3, ARRAY_SIZE * sizeof(int) / 4, cudaMemcpyHostToDevice, stream_3);
		cudaMemcpyAsync(dev_c_3, c_3, MAX_HISTORGRAM_NUMBER * sizeof(unsigned long long int), cudaMemcpyHostToDevice, stream_3);
		histogramKernelSingle << <BLOCK_COUNT, THREAD_COUNT, 0, stream_3>> > (dev_c_3, dev_a_3);
		
		cudaMemcpyAsync(c_0, dev_c_0, MAX_HISTORGRAM_NUMBER * sizeof(unsigned long long int), cudaMemcpyDeviceToHost, stream_0);
		cudaMemcpyAsync(c_1, dev_c_1, MAX_HISTORGRAM_NUMBER * sizeof(unsigned long long int), cudaMemcpyDeviceToHost, stream_1);
		cudaMemcpyAsync(c_2, dev_c_2, MAX_HISTORGRAM_NUMBER * sizeof(unsigned long long int), cudaMemcpyDeviceToHost, stream_2);
		cudaMemcpyAsync(c_3, dev_c_3, MAX_HISTORGRAM_NUMBER * sizeof(unsigned long long int), cudaMemcpyDeviceToHost, stream_3);
		
		
		cudaStreamSynchronize(stream_0);
		cudaStreamSynchronize(stream_1);
		cudaStreamSynchronize(stream_2);
		cudaStreamSynchronize(stream_3);
		
		
		cudaStreamDestroy(stream_0);
		cudaStreamDestroy(stream_1);
		cudaStreamDestroy(stream_2);
		cudaStreamDestroy(stream_3);
		
		
		cudaDeviceSynchronize();
		
		
		double end_time = omp_get_wtime();
		std::cout << end_time - start_time;

		cudaFree(dev_a_0);
		cudaFree(dev_a_1);
		cudaFree(dev_a_2);
		cudaFree(dev_a_3);
		cudaFree(dev_c_0);
		cudaFree(dev_c_1);
		cudaFree(dev_c_2);
		cudaFree(dev_c_3);
		cudaFreeHost(a_0);
		cudaFreeHost(a_1);
		cudaFreeHost(a_2);
		cudaFreeHost(a_3);
		
	
		cudaStatus = cudaDeviceReset();
		if (cudaStatus != cudaSuccess) {
			fprintf(stderr, "cudaDeviceReset failed!");
			return 1;
		}
		
		unsigned long long int R = 0;
		
		for (int i = 0; i < MAX_HISTORGRAM_NUMBER; i++){
			R += c_0[i] + c_1[i] + c_2[i] + c_3[i];
		}
		
		printf("\n%lld		%d		%d", R/(SCALER) , ARRAY_SIZE, ARRAY_SIZE == R/(SCALER));
		
		free(c_0);
		free(c_1);
		free(c_2);
		free(c_3);
		free(b);
		
		printf("\nCHUNK_SIZE: %d\nTHREAD_COUNT: %d\nBLOCK_COUNT: %d\n" , CHUNK_SIZE, THREAD_COUNT,BLOCK_COUNT);
		return 0;
}