#define _CRT_SECURE_NO_WARNINGS

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <omp.h>

#define NUM_THREADS 16
#define ITERATIONS 10
#define CHUNK_SIZE 128

typedef struct {
    int *A, *B, *C;
    int n, m;
} DataSet;

void fillDataSet(DataSet *dataSet);

void printDataSet(DataSet dataSet);

void closeDataSet(DataSet dataSet);

void add(DataSet dataSet);

void add_column_by_column(DataSet dataSet);

void add_block_by_block(DataSet dataSet);

void add_collapse(DataSet dataSet);

void report_num_threads(int level);

int main(int argc, char *argv[]) {
    DataSet dataSet;
    if (argc < 3) {
        printf("[-] Invalid No. of arguments.\n");
        printf("[-] Try -> <n> <m> \n");
        printf(">>> ");
        scanf("%d %d", &dataSet.n, &dataSet.m);
    } else {
        dataSet.n = atoi(argv[1]);
        dataSet.m = atoi(argv[2]);
    }
    fillDataSet(&dataSet);
    add_collapse(dataSet);
//	printDataSet(dataSet);
    closeDataSet(dataSet);
//    system("PAUSE");
    return EXIT_SUCCESS;
}

void fillDataSet(DataSet *dataSet) {
    int i, j;

    dataSet->A = (int *) malloc(sizeof(int) * dataSet->n * dataSet->m);
    dataSet->B = (int *) malloc(sizeof(int) * dataSet->n * dataSet->m);
    dataSet->C = (int *) malloc(sizeof(int) * dataSet->n * dataSet->m);

    srand(static_cast<unsigned int>(time(nullptr)));

    for (i = 0; i < dataSet->n; i++) {
        for (j = 0; j < dataSet->m; j++) {
            dataSet->A[i * dataSet->m + j] = rand() % 100;
            dataSet->B[i * dataSet->m + j] = rand() % 100;
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
    for (i = 0; i < dataSet.n; i++) {
        for (j = 0; j < dataSet.m; j++) {
            printf("%-4d", dataSet.B[i * dataSet.m + j]);
        }
        putchar('\n');
    }

    printf("[-] Matrix C\n");
    for (i = 0; i < dataSet.n; i++) {
        for (j = 0; j < dataSet.m; j++) {
            printf("%-8d", dataSet.C[i * dataSet.m + j]);
        }
        putchar('\n');
    }
}

void closeDataSet(DataSet dataSet) {
    free(dataSet.A);
    free(dataSet.B);
    free(dataSet.C);
}

void add(DataSet dataSet) { // row by row
    omp_set_num_threads(NUM_THREADS);
    double average_time = 0;
    for (int k = 0; k < ITERATIONS; ++k) {
        double start = omp_get_wtime();
#pragma omp parallel for schedule(static, CHUNK_SIZE)
        for (int i = 0; i < dataSet.n; i++) {
            for (int j = 0; j < dataSet.m; j++) {
                dataSet.C[i * dataSet.m + j] = dataSet.A[i * dataSet.m + j] + dataSet.B[i * dataSet.m + j];
            }
        }
        double end = omp_get_wtime();
        average_time += end - start;
        printf_s("time in iteration %d : %f\n", k, end - start);
    }
    printf_s("average time : %f", average_time / ITERATIONS);
}

void add_column_by_column(DataSet dataSet) {
    omp_set_num_threads(NUM_THREADS);
    double average_time = 0;
    for (int k = 0; k < ITERATIONS; ++k) {
        double start = omp_get_wtime();
#pragma omp parallel for schedule(static, CHUNK_SIZE)
        for (int j = 0; j < dataSet.m; j++) {
            for (int i = 0; i < dataSet.n; i++) {
                dataSet.C[i * dataSet.m + j] = dataSet.A[i * dataSet.m + j] + dataSet.B[i * dataSet.m + j];
            }
        }
        double end = omp_get_wtime();
        average_time += end - start;
        printf_s("time in iteration %d : %f\n", k, end - start);
    }
    printf_s("average time : %f", average_time / ITERATIONS);
}

void add_block_by_block(DataSet dataSet) {
    omp_set_nested(1);
    omp_set_num_threads(NUM_THREADS);
    int level_1;
    int level_2;
    switch (NUM_THREADS) {
        case 1:
            level_1 = 1;
            level_2 = 1;
            break;
        case 4:
            level_1 = 2;
            level_2 = 2;
            break;
        case 8:
            level_1 = 4;
            level_2 = 2;
            break;
        case 16:
            level_1 = 4;
            level_2 = 4;
            break;
        default:
            level_1 = 1;
            level_2 = 1;
            break;
    }
    double average_time = 0;
    for (int k = 0; k < ITERATIONS; ++k) {
        double start = omp_get_wtime();
#pragma omp parallel for schedule(static, CHUNK_SIZE) num_threads(level_1)
        for (int i = 0; i < dataSet.n; i++) {
#pragma omp parallel for schedule(static, CHUNK_SIZE) num_threads(level_2)
            for (int j = 0; j < dataSet.m; j++) {
                dataSet.C[i * dataSet.m + j] = dataSet.A[i * dataSet.m + j] + dataSet.B[i * dataSet.m + j];
            }
        }
        double end = omp_get_wtime();
        average_time += end - start;
        printf_s("time in iteration %d : %f\n", k, end - start);
    }
    printf_s("average time : %f", average_time / ITERATIONS);
}

void report_num_threads(int level) {
#pragma omp single
    {
        printf("Level %d: number of threads in the team - %d\n",
               level, omp_get_num_threads());
    }
}

void add_collapse(DataSet dataSet) {
    omp_set_num_threads(NUM_THREADS);
    double start = omp_get_wtime();
#pragma omp parallel for collapse(2) schedule(static, CHUNK_SIZE)
    for (int i = 0; i < dataSet.n; i++) {
        for (int j = 0; j < dataSet.m; j++) {
            dataSet.C[i * dataSet.m + j] =
                    dataSet.A[i * dataSet.m + j] + dataSet.B[i * dataSet.m + j];
        }
    }
    double end = omp_get_wtime();
    printf_s("time : %f \n", end - start);
}