/*
*        In His Exalted Name
*  Title:  Prefix Sum Sequential Code
*  Author: Ahmad Siavashi, Email: siavashi@aut.ac.ir
 *  with addition of Mahdi Safari and Amir M Pirhosseinloo, Email: amirphl@aut.ac.ir
*  Date:  29/04/2018
*/

// Let it be.
#define _CRT_SECURE_NO_WARNINGS

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <omp.h>
#include <math.h>

void omp_check();

void fill_array(int *a, size_t n);

void prefix_sum_serial(int *a, size_t n);

void print_array(int *a, size_t n);

void prefix_sum_method_1(int *a, size_t n);

void test(int *a, size_t n);

void prefix_sum_method_2(int *a, size_t n);

void prefix_sum_method_3(int *a, size_t n);


int main(int argc, char *argv[]) {
    // Check for correct compilation settings
    omp_check();
    // Input N
    size_t n = 0;
    printf("[-] Please enter N: ");
    scanf("%uld\n", &n);
    // Allocate memory for array
    int *a = (int *) malloc(n * sizeof a);
    // Fill array with numbers 1..n
    fill_array(a, n);
    // Print array
    //print_array(a, n);
    // Compute prefix sum
    prefix_sum_method_3(a, n);
//    prefix_sum_method_2(a, n);
    //prefix_sum_method_1(a, n);
    //test(a, n);
    // Print array
    print_array(a, n);
    // Free allocated memory
    free(a);
//    system("pause");
    return EXIT_SUCCESS;
}

void test(int *a, size_t n) {
    for (int i = 1; i < n; i <<= 1) {
        print_array(a, n);
        for (int j = 0; j < n; j += 2 * i)
            a[2 * i + j - 1] = a[2 * i + j - 1] + a[i + j - 1];
    }
}

void prefix_sum_serial(int *a, size_t n) {
    double start = omp_get_wtime();
    int i;
    for (i = 1; i < n; ++i) {
        a[i] = a[i] + a[i - 1];
    }
    double end = omp_get_wtime();
    printf("%f\n", end - start);
}

void print_array(int *a, size_t n) {
    int i;
    printf("[-] array: ");
    for (i = 0; i < n; ++i) {
        printf("%d, ", a[i]);
    }
    printf("\b\b  \n");
}

void prefix_sum_method_1(int *a, size_t n) {
    int threads;
    omp_set_num_threads(4);
    double start = omp_get_wtime();
#pragma omp parallel
    {
        threads = omp_get_num_threads();
        int id = omp_get_thread_num();
        for (int i = id * n / threads + 1; i < (id + 1) * n / threads; i++) {
            a[i] = a[i] + a[i - 1];
        }
    }
    printf("time is : %f \n", omp_get_wtime() - start);
    for (int i = 1; i < threads; i++) {
        int set = a[i * n / threads - 1];
#pragma omp parallel for
        for (int j = i * n / threads; j < (i + 1) * n / threads; j++) {
            a[j] = a[j] + set;
        }
    }
    printf("time is : %f", omp_get_wtime() - start);
}

//This method works well where n is a power of 2
void prefix_sum_method_2(int *a, size_t n) {
    int *b = new int[n];
    omp_set_num_threads(4);
    int iter = (int) ceil(log2(n));
    int i = 0;
    int *temp;
    double start = omp_get_wtime();
#pragma omp parallel
    {
        int threads = omp_get_num_threads();
        while (i < iter) {
            int id = omp_get_thread_num();
            int constant = (int) pow(2, i);
            for (int j = constant + id * (n - constant) / threads;
                 j < constant + (id + 1) * (n - constant) / threads; j++) {
                b[j] = a[j] + a[j - constant];
            }

#pragma omp barrier
#pragma omp for
            for (int j = 0; j < constant; ++j) {
                b[j] = a[j];
            }


//#pragma omp single
//            for (int j = 0; j < n; ++j) {
//                printf_s("%d , ", b[j]);
//            }
//#pragma omp single
//            printf_s("\n");
#pragma omp single
            i++;
#pragma omp single
            temp = a;
#pragma omp single
            a = b;
#pragma omp single
            b = temp;
        }
    }
    printf("time is : %f\n", omp_get_wtime() - start);
}

void prefix_sum_method_3(int *a, size_t n) {
    omp_set_num_threads(4);
    double start = omp_get_wtime();
    for (int i = 1; i < n; i <<= 1)
#pragma omp parallel for
            for (int j = 0; j < n; j += 2 * i)
                a[2 * i + j - 1] = a[2 * i + j - 1] + a[i + j - 1];

    a[n - 1] = 0;

    for (int i = n / 2; i > 0; i >>= 1) {
#pragma omp parallel for
        for (int j = 0; j < n; j += 2 * i) {
            int temp = a[i + j - 1];
            a[i + j - 1] = a[2 * i + j - 1];
            a[2 * i + j - 1] = temp + a[2 * i + j - 1];
        }
    }
    printf("time is : %f\n", omp_get_wtime() - start);
}

void fill_array(int *a, size_t n) {
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