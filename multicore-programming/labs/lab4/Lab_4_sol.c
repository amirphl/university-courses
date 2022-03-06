/*
*				In His Exalted Name
*	Title:	Prefix Sum Sequential Code
*	Author: Ahmad Siavashi, Email: siavashi@aut.ac.ir
*	Date:	29/04/2018
*/

// Let it be.
#define _CRT_SECURE_NO_WARNINGS

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <omp.h>
#include <math.h>

void omp_check();
void fill_array(int *a, int n);
void prefix_sum(int *a, int n);
void update_sum(int *a, int n, int val);
void print_array(int *a, int n);
/** first solution **/
void par_prefix_sum_1(int *a, int n);
/** Hillis and Steele Solution **/
void par_prefix_sum_2(int *a, int n);
/** Blelloch Solution **/
void par_prefix_sum_3(int *a, int n);

int main(int argc, char *argv[]) {
	// Check for correct compilation settings
	omp_check();
	// Input N
	int n = 0;
	double start_time;
	printf("[-] Please enter N: ");
	scanf("%uld\n", &n);
	int * a = (int *)malloc(n * sizeof *a);
	
	fill_array(a, n);
	start_time = omp_get_wtime();
	prefix_sum(a, n);
	printf("Elapsed Time Serial: %f\n", omp_get_wtime() - start_time);

	fill_array(a, n);
	start_time = omp_get_wtime();
	par_prefix_sum_1(a, n);
	printf("Elapsed Time Parallel 1: %f\n", omp_get_wtime() - start_time);

	fill_array(a, n);
	start_time = omp_get_wtime();
	par_prefix_sum_2(a, n);
	printf("Elapsed Time Parallel 2: %f\n", omp_get_wtime() - start_time);	

	fill_array(a, n);
	start_time = omp_get_wtime();
	par_prefix_sum_3(a, n);
	printf("Elapsed Time Parallel 3: %f\n", omp_get_wtime() - start_time);

	free(a);
	system("pause");
	return EXIT_SUCCESS;
}

void par_prefix_sum_1(int *a, int n) {
	int i,size;
	int* start;
#pragma omp parallel private(start,size,i) 
	{
		int num_threads = omp_get_num_threads();
		int id = omp_get_thread_num();
		int val = 0;
		size = n / num_threads;
		
		start = a + id*size;
		//printf("I am thread %d, start: %d\n", id, *start);

		if ( id == num_threads - 1)
			size += n % num_threads;
		//printf("I am thread %d, size: %d\n", id, size);
		prefix_sum(start, size);
		
#pragma omp barrier
		if (id != 0){
			for (i = 0; i < id; i++)
				val += *(start - 1 - i*(n/num_threads));
		}
#pragma omp barrier
		//printf("I am thread %d, val: %d\n", id, val);
		if (id != 0){
			update_sum(start, size, val);
		}
	}
}

void par_prefix_sum_2(int *a, int n) {
	int i, j;
	int * t = (int *)calloc(n, sizeof(int));
	for (j = 0; j < ceil(log2((float)n)); j++) {
#pragma omp parallel private(i)
		{
#pragma omp for
			for (i = 1 << j; i < n; i++)
				t[i] = a[i] + a[i - (1 << j)];
#pragma omp for
			for (i = 1 << j; i < n; i++)
				a[i] = t[i];
		}
	}
	free(t);
}

void par_prefix_sum_3(int *a, int n) {
     for (int i = 1; i < n; i <<= 1)
#pragma omp parallel for schedule(static, 16)
         for (int j = 0; j < n; j += 2 * i)
             a[2 * i + j - 1] = a[2 * i + j - 1] + a[i + j - 1];

     a[n - 1] = 0;

     for (int i = n / 2; i > 0; i >>= 1) {
#pragma omp parallel for schedule(static, 16)
         for (int j = 0; j < n; j += 2 * i) {
             int temp = a[i + j - 1];
             a[i + j - 1] = a[2 * i + j - 1];
             a[2 * i + j - 1] = temp + a[2 * i + j - 1];
         }
     }
}

void prefix_sum(int *a, int n) {
	int i;
	for (i = 1; i < n; ++i) {
		a[i] = a[i] + a[i - 1];
	}
}

void update_sum(int *a, int n, int val) {
	int i;
	for (i = 0; i < n; ++i) {
		a[i] = a[i] + val;
	}
}

void print_array(int *a, int n) {
	int i;
	printf("[-] array: ");
	for (i = 0; i < n; ++i) {
		printf("%d, ", a[i]);
	}
	printf("\b\b  \n");
}

void fill_array(int *a, int n) {
	int i;
	for (i = 0; i < n; ++i) {
		a[i] = i + 1;
	}
}

void omp_check() {
	printf("------------ Info -------------\n");
#ifdef _DEBUG
	printf("[!] Configuration: Debug.\n");
#pragma message ("Change configuration to Release for a fast execution.")
#else
	printf("[-] Configuration: Release.\n");
#endif // _DEBUG
#ifdef _M_X64
	printf("[-] Platform: x64\n");
#elif _M_IX86 
	printf("[-] Platform: x86\n");
#pragma message ("Change platform to x64 for more memory.")
#endif // _M_IX86 
#ifdef _OPENMP
	printf("[-] OpenMP is on.\n");
	printf("[-] OpenMP version: %d\n", _OPENMP);
#else
	printf("[!] OpenMP is off.\n");
	printf("[#] Enable OpenMP.\n");
#endif // _OPENMP
	printf("[-] Maximum threads: %d\n", omp_get_max_threads());
	printf("[-] Nested Parallelism: %s\n", omp_get_nested() ? "On" : "Off");
#pragma message("Enable nested parallelism if you wish to have parallel region within parallel region.")
	printf("===============================\n");
}
