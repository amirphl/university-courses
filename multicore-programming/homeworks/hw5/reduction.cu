/*
* In his exalted name
*
* Reduction - Sequential Code
* Written by Ahmad Siavashi (siavashi@aut.ac.ir)
* Date: June, 2018
* Language: C++11
*/
#include <cstdlib>
#include <vector>
#include <chrono>
#include <iostream>>
#include <cmath>
#include <numeric>

// N = 2^27
#define N pow(2, 27)

using namespace std;

__global__ void reduce0(int *g_idata, int *g_odata) {
	extern __shared__ int sdata[];
	// each thread loads one element from global to shared mem
	unsigned int tid = threadIdx.x;
	unsigned int i = blockIdx.x*blockDim.x + threadIdx.x;
	sdata[tid] = g_idata[i];
	__syncthreads();
	// do reduction in shared mem
	for(unsigned int s=1; s < blockDim.x; s *= 2) {
		if (tid % (2*s) == 0) {
			sdata[tid] += sdata[tid + s];
		}
		__syncthreads();
	}
	// write result for this block to global mem
	if (tid == 0) g_odata[blockIdx.x] = sdata[0];
}

int main(int argc, char *argv[]) {
	// initialize a vector of size N with 1
	vector<int> v(N, 1);
	// capture start time
	auto start_time = chrono::high_resolution_clock::now();
	// reduction
	auto sum = accumulate(begin(v), end(v), 0);
	// capture end time
	auto end_time = chrono::high_resolution_clock::now();
	// elapsed time in milliseconds
	auto duration = chrono::duration_cast<chrono::microseconds>(end_time - start_time);
	// print sum and elapsed time
	cout << "[-] Sum: " << sum << endl;
	cout << "[-] Duration: " << duration.count() << "ms" << endl;
	return EXIT_SUCCESS;
}
