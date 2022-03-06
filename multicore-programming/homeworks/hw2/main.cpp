#define _CRT_SECURE_NO_WARNINGS

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <omp.h>

#define NUM_THREADS 8
#define ITERATIONS 3
#define CHUNK_SIZE 64

typedef struct {
    int *A, *B, *C;
    int n, m, p;
} DataSet;

void fillDataSet(DataSet *dataSet);

void printDataSet(DataSet dataSet);

void closeDataSet(DataSet dataSet);

void multiply_1d(DataSet dataSet); //1 Dimension
void multiply_2d(DataSet dataSet); //2 Dimension

int main(int argc, char *argv[]) {
#ifndef _OPENMP
    fprintf( stderr, "OpenMP is not supported – sorry!\n" );
    exit( 0 );
#endif

    DataSet dataSet;
    if (argc < 4) {
        printf("[-] Invalid No. of arguments.\n");
        printf("[-] Try -> <n> <m> <p>\n");
        printf(">>> ");
        scanf("%d %d %d", &dataSet.n, &dataSet.m, &dataSet.p);
    } else {
        dataSet.n = atoi(argv[1]);
        dataSet.m = atoi(argv[2]);
        dataSet.p = atoi(argv[3]);
    }
    fillDataSet(&dataSet);
//    multiply_1d(dataSet);
    multiply_2d(dataSet);
//    printDataSet(dataSet);
    closeDataSet(dataSet);
//    system("PAUSE");
    return EXIT_SUCCESS;
}

void fillDataSet(DataSet *dataSet) {
    int i, j;

    dataSet->A = (int *) malloc(sizeof(int) * dataSet->n * dataSet->m);
    dataSet->B = (int *) malloc(sizeof(int) * dataSet->m * dataSet->p);
    dataSet->C = (int *) malloc(sizeof(int) * dataSet->n * dataSet->p);

    srand(time(NULL));

    for (i = 0; i < dataSet->n; i++) {
        for (j = 0; j < dataSet->m; j++) {
            dataSet->A[i * dataSet->m + j] = rand() % 100;
        }
    }

    for (i = 0; i < dataSet->m; i++) {
        for (j = 0; j < dataSet->p; j++) {
            dataSet->B[i * dataSet->p + j] = rand() % 100;
        }
    }
}

void printDataSet(DataSet dataSet) {
    int i, j;

    printf("[-] Matrix A\n");
    for (i = 0; i < dataSet.n; i++) {
        for (j = 0; j < dataSet.m; j++) {
            printf("%-4d", dataSet.A[i * dataSet.m + j]);
        }
        putchar('\n');
    }

    printf("[-] Matrix B\n");
    for (i = 0; i < dataSet.m; i++) {
        for (j = 0; j < dataSet.p; j++) {
            printf("%-4d", dataSet.B[i * dataSet.p + j]);
        }
        putchar('\n');
    }

    printf("[-] Matrix C\n");
    for (i = 0; i < dataSet.n; i++) {
        for (j = 0; j < dataSet.p; j++) {
            printf("%-8d", dataSet.C[i * dataSet.p + j]);
        }
        putchar('\n');
    }
}

void closeDataSet(DataSet dataSet) {
    free(dataSet.A);
    free(dataSet.B);
    free(dataSet.C);
}

void multiply_1d(DataSet dataSet) {
    omp_set_num_threads(8);
    double average_time = 0;
    for (int w = 0; w < ITERATIONS; ++w) {
        double start = omp_get_wtime();
//#pragma omp parallel for schedule(static, CHUNK_SIZE)
#pragma omp parallel for
        for (int i = 0; i < dataSet.n; i++) {
            for (int j = 0; j < dataSet.p; j++) {
                int sum = 0;
                for (int k = 0; k < dataSet.m; k++) {
                    sum += dataSet.A[i * dataSet.m + k] * dataSet.B[k * dataSet.p + j];
                }
                dataSet.C[i * dataSet.p + j] = sum;
            }
        }
        double end = omp_get_wtime();
        average_time += end - start;
        printf_s("time in iteration %d : %f\n", w, end - start);
    }
    printf_s("average time : %f", average_time / ITERATIONS);
}

void multiply_2d(DataSet dataSet) {
    omp_set_nested(1);
    omp_set_num_threads(NUM_THREADS);
    int level_1;
    int level_2;
    switch (NUM_THREADS) {
        case 1:
            level_1 = 1;
            level_2 = 1;
            break;
        case 2:
            level_1 = 1;
            level_2 = 2;
            break;
        case 4:
            level_1 = 2;
            level_2 = 2;
            break;
        case 8:
            level_1 = 4;
            level_2 = 2;
            break;
        default:
            level_1 = 1;
            level_2 = 1;
            break;
    }
    double average_time = 0;
    for (int w = 0; w < ITERATIONS; ++w) {
        double start = omp_get_wtime();
//#pragma omp parallel for schedule(static, CHUNK_SIZE)
#pragma omp parallel for num_threads(level_1)
        for (int i = 0; i < dataSet.n; i++) {
#pragma omp parallel for num_threads(level_2)
            for (int j = 0; j < dataSet.p; j++) {
                int sum = 0;
                for (int k = 0; k < dataSet.m; k++) {
                    sum += dataSet.A[i * dataSet.m + k] * dataSet.B[k * dataSet.p + j];
                }
                dataSet.C[i * dataSet.p + j] = sum;
            }
        }
        double end = omp_get_wtime();
        average_time += end - start;
        printf_s("time in iteration %d : %f\n", w, end - start);
    }
    printf_s("average time : %f", average_time / ITERATIONS);
}