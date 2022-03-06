#include <iostream>
#include <stdlib.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

void fillVector(int * v, size_t n);
void addVector(int * a, int *b, int *c, size_t n);
void printVector(int * v, size_t n);
cudaError_t addWithCuda(int *c, const int *a, const int *b, unsigned int size, int multiplier);
cudaError_t showIds();
__global__ void addKernel(int *c, const int *a, const int *b, int multiplier);
__global__ void addKernel_2(int *c, const int *a, const int *b, int multiplier);
__global__ void kernel_3(int *a,unsigned int *b,unsigned *c,unsigned int *d);

int main()
{	
	int multiplier = 100 * 1024 / 40; // 40 blocks for 5 SM
	int vectorSize = 100 * 1024 * 1024;
	
	int *a = (int *)malloc(vectorSize * sizeof(int));
	int *b = (int *)malloc(vectorSize * sizeof(int));
	int *c = (int *)malloc(vectorSize * sizeof(int));
	
	fillVector(a, vectorSize);
	fillVector(b, vectorSize);

	cudaEvent_t start;
	cudaEventCreate(&start);
	cudaEventRecord(start, NULL);

	addWithCuda(c, a, b, vectorSize, multiplier);
	//showIds();

	cudaEvent_t stop;
	cudaEventCreate(&stop);
	cudaEventRecord(stop, NULL);
	cudaEventSynchronize(stop);
	
	float msecTotal = 0.0f;
	cudaEventElapsedTime(&msecTotal, start, stop);
	printf ("time is %f miliseconds\n", msecTotal);
	//printVector(c, vectorSize);
	return EXIT_SUCCESS;
}

cudaError_t addWithCuda(int *c, const int *a, const int *b, unsigned int size, int multiplier)
{
	int *dev_a = 0;
	int *dev_b = 0;
	int *dev_c = 0;
	
	cudaError_t cudaStatus;
	cudaStatus = cudaSetDevice(0);
	if (cudaStatus != cudaSuccess) {
		printf("cudaSetDevice failed! Do you have a CUDA-capable GPU installed?");
	}
	
	cudaStatus = cudaMalloc((void**)&dev_c, size * sizeof(int));
	if (cudaStatus != cudaSuccess) {
		printf("cudaMalloc failed!");
	}
	cudaStatus = cudaMalloc((void**)&dev_a, size * sizeof(int));
	if (cudaStatus != cudaSuccess) {
		printf("cudaMalloc failed!");
	}
	cudaStatus = cudaMalloc((void**)&dev_b, size * sizeof(int));
	if (cudaStatus != cudaSuccess) {
		printf("cudaMalloc failed!");
	}

	cudaStatus = cudaMemcpy(dev_a, a, size * sizeof(int), cudaMemcpyHostToDevice);
	if (cudaStatus != cudaSuccess) {
		printf("cudaMemcpy failed!");
	}
	cudaStatus = cudaMemcpy(dev_b, b, size * sizeof(int), cudaMemcpyHostToDevice);
	if (cudaStatus != cudaSuccess) {
		printf("cudaMemcpy failed!");
	}
	
	cudaEvent_t start;
	cudaEventCreate(&start);
	cudaEventRecord(start, NULL);
	
	//addKernel <<< 1, 1024 >>>(dev_c, dev_a, dev_b);
	addKernel_2 <<< 40, 1024 >>>(dev_c, dev_a, dev_b,multiplier);
	
	cudaEvent_t stop;
	cudaEventCreate(&stop);
	cudaEventRecord(stop, NULL);
	cudaEventSynchronize(stop);
	
	float msecTotal = 0.0f;
	cudaEventElapsedTime(&msecTotal, start, stop);
	printf ("time excluding arrays transmission is %f miliseconds\n", msecTotal);
	
	cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) {
		printf("addKernel launch failed: %s\n", cudaGetErrorString(cudaStatus));
	}
	
	cudaStatus = cudaDeviceSynchronize();
	if (cudaStatus != cudaSuccess) {
		printf("cudaDeviceSynchronize returned error code %d after launchin addKernel!\n", cudaStatus);
	}
	
	cudaStatus = cudaMemcpy(c, dev_c, size * sizeof(int), cudaMemcpyDeviceToHost);
	if (cudaStatus != cudaSuccess) {
		printf("cudaMemcpy failed!");
	}
	
	cudaFree(dev_c);
	cudaFree(dev_a);
	cudaFree(dev_b);
	return cudaStatus;
}

cudaError_t showIds(){
	
	int size = 2 * 64;
	
	int *dev_a = 0;
	unsigned int *dev_b = 0;
	unsigned *dev_c = 0;
	unsigned int *dev_d = 0;
	
	int *a = (int *)malloc(size * sizeof(int));
	unsigned int *b = (unsigned int *)malloc(size * sizeof(unsigned int));
	unsigned *c = (unsigned *)malloc(size * sizeof(unsigned));
	unsigned int *d = (unsigned int *)malloc(size * sizeof(unsigned int));;
	
	
	cudaError_t cudaStatus;
	cudaStatus = cudaSetDevice(0);
	if (cudaStatus != cudaSuccess) {
		printf("cudaSetDevice failed! Do you have a CUDA-capable GPU installed?");
	}
	
	cudaStatus = cudaMalloc((void**)&dev_a, size * sizeof(long int));
	if (cudaStatus != cudaSuccess) {
		printf("cudaMalloc failed!");
	}
	cudaStatus = cudaMalloc((void**)&dev_b, size * sizeof(unsigned int));
	if (cudaStatus != cudaSuccess) {
		printf("cudaMalloc failed!");
	}
	cudaStatus = cudaMalloc((void**)&dev_c, size * sizeof(unsigned));
	if (cudaStatus != cudaSuccess) {
		printf("cudaMalloc failed!");
	}
	cudaStatus = cudaMalloc((void**)&dev_d, size * sizeof(uint3));
	if (cudaStatus != cudaSuccess) {
		printf("cudaMalloc failed!");
	}
	
	kernel_3 <<< 2, 64 >>>(dev_a, dev_b, dev_c, dev_d);
	
	cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) {
		printf("addKernel launch failed: %s\n", cudaGetErrorString(cudaStatus));
	}
	
	cudaStatus = cudaDeviceSynchronize();
	if (cudaStatus != cudaSuccess) {
		printf("cudaDeviceSynchronize returned error code %d after launchin addKernel!\n", cudaStatus);
	}
	
	cudaStatus = cudaMemcpy(a, dev_a, size * sizeof(int), cudaMemcpyDeviceToHost);
	if (cudaStatus != cudaSuccess) {
		printf("cudaMemcpy failed!");
	}

	cudaStatus = cudaMemcpy(b, dev_b, size * sizeof(int), cudaMemcpyDeviceToHost);
	if (cudaStatus != cudaSuccess) {
		printf("cudaMemcpy failed!");
	}
	
	cudaStatus = cudaMemcpy(c, dev_c, size * sizeof(int), cudaMemcpyDeviceToHost);
	if (cudaStatus != cudaSuccess) {
		printf("cudaMemcpy failed!");
	}
	
	cudaStatus = cudaMemcpy(d, dev_d, size * sizeof(int), cudaMemcpyDeviceToHost);
	if (cudaStatus != cudaSuccess) {
		printf("cudaMemcpy failed!");
	}
	
	for(int i = 0; i < size; i++){
		printf("Worker: %d -SMid: %d -Blockid: %d -Warpid: %d -Threadid: %d\n",i,a[i],b[i],c[i],d[i]);
	}
	
	cudaFree(dev_a);
	cudaFree(dev_b);
	cudaFree(dev_c);
	cudaFree(dev_d);
	
	free(a);
	free(b);
	free(c);
	free(d);
	
	return cudaStatus;
}

__global__ void addKernel(int *c, const int *a, const int *b)
{
	int i = threadIdx.x;
	c[i] = a[i] + b[i];
}

__global__ void addKernel_2(int *c, const int *a, const int *b, int multiplier)
{
	int thread_id = threadIdx.x + blockIdx.x;
	
	for(int j = thread_id * multiplier ; j < (thread_id + 1)* multiplier ; j++){
		c[j] = a[j] + b[j];
	}
}

//arrays a, b, c, d respectivly contain SMId, BlockId, WarpId and ThreadId
__global__ void kernel_3(int *a,unsigned int *b,unsigned *c,unsigned int *d)
{
	int t_id = (int) (threadIdx.x + blockIdx.x * blockDim.x);
	unsigned w_id; 
    asm volatile ("mov.u32 %0, %warpid;" : "=r"(w_id));
	long int smid;
	asm volatile("mov.u32 %0, %%smid;" : "=r"(smid));
	a[t_id] = smid;
	b[t_id] = blockIdx.x;
	c[t_id] = w_id;
	d[t_id] = threadIdx.x;
}

// Fills a vector with data
void fillVector(int * v, size_t n) {
	int i;
	for (i = 0; i < n; i++) {
		v[i] = i;
	}
}

// Adds two vectors
void addVector(int * a, int *b, int *c, size_t n) {
	int i;
	for (i = 0; i < n; i++) {
		c[i] = a[i] + b[i];
	}
}

// Prints a vector to the stdout.
void printVector(int * v, size_t n) {
	int i;
	printf("[-] Vector elements: ");
	for (i = 0; i < n; i++) {
		printf("%d, ", v[i]);
	}
	printf("\b\b  \n");
}
