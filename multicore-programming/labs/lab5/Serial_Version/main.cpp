#define _CRT_SECURE_NO_WARNINGS

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <omp.h>

// Fills a vector with data
void fillVector(int *v, size_t n) {
    int i;
    for (i = 0; i < n; i++) {
        v[i] = i;
    }
}

// Adds two vectors
void addVector(int *a, int *b, int *c, size_t n) {
    int i;
    for (i = 0; i < n; i++) {
        c[i] = a[i] + b[i];
    }
}

// Prints a vector to the stdout.
void printVector(int *v, size_t n) {
    int i;
    printf("[-] Vector elements: ");
    for (i = 0; i < n; i++) {
        printf("%d, ", v[i]);
    }
    printf("\b\b  \n");
}


int main() {
#ifndef _OPENMP
    fprintf(stderr, "OpenMP is not supported – sorry!\n");
    exit(0);
#endif
    int multiplier = 1024*100;
    int vectorSize = multiplier * 1024;

    int *a = (int *) malloc(vectorSize * sizeof(int));
    int *b = (int *) malloc(vectorSize * sizeof(int));
    int *c = (int *) malloc(vectorSize * sizeof(int));

    fillVector(a, vectorSize);
    fillVector(b, vectorSize);

    double start = omp_get_wtime();

    addVector(a, b, c, vectorSize);

    double end = omp_get_wtime();
    printf_s("time: \n%f", end - start);

//    printVector(c, vectorSize);
    return 0;
}