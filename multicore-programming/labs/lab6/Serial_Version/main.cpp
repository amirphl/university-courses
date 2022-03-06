#define _CRT_SECURE_NO_WARNINGS

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <omp.h>
#include <math.h>

// Prints a vector to the stdout.
void printVector(const float *C, int n) {
    int i, j;
    for (i = 0; i < n; ++i) {
        for (j = 0; j < n; ++j) {
            printf_s("%f ", C[i * n + j]);
        }
        printf_s("\n");
    }
    printf("\b\b  \n");
}

void maatrixMul(float *C, const float *A, const float *B, int n);

void constantInit(float *data, int size, float val) {
    for (int i = 0; i < size; ++i) {
        data[i] = val;
    }
}


int main() {
#ifndef _OPENMP
    fprintf(stderr, "OpenMP is not supported – sorry!\n");
    exit(0);
#endif
    int vectorSize = 4096 * 4096;

    auto *a = (float *) malloc(vectorSize * sizeof(float));
    auto *b = (float *) malloc(vectorSize * sizeof(float));
    auto *c = (float *) malloc(vectorSize * sizeof(float));

    // Initialize host memory
    const float valB = 0.01f;
    constantInit(a, vectorSize, 1.0f);
    constantInit(b, vectorSize, valB);

    double start = omp_get_wtime();

    maatrixMul(c, a, b, static_cast<int>(sqrt(vectorSize)));

    double end = omp_get_wtime();
    printf_s("time: \n%f", end - start);

    free(a);
    free(b);
    free(c);

//    printVector(c, vectorSize);
    return 0;
}

void maatrixMul(float *C, const float *A, const float *B, int n) {
    int i, j, k;

    for (i = 0; i < n; ++i) {
        for (j = 0; j < n; ++j) {
            float sum = 0.0f;
            for (k = 0; k < n; ++k) {
                sum += A[i * n + k] * B[k * n + j];
            }
            C[i * n + j] = sum;
        }
    }

//    printVector(A, n);
//    printVector(B, n);
//    printVector(C, n);
}