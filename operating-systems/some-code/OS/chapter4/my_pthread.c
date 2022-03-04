//
// Created by amirphl on 11/2/18.
//

#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

int sum;

void *runner(void *param);

int main(int argc, char *argv[]) {
    pthread_t tid;
    pthread_attr_t attr;
    char u = 6;
    char *c = &u;


    pthread_attr_init(&attr);
    pthread_create(&tid, &attr, runner, c);
    pthread_join(tid, NULL);

    printf("sum = %d\n", sum);
}

void *runner(void *param) {
    int upper = atoi(param);
    sum = 0;

    for (int j = 0; j <= upper; ++j) {
        sum += j;
    }
    pthread_exit(0);
}

//{
//    pthread_t workers[10];
//
//    for(int i = 0 ; i < 10 ; i++)
//        pthread_join(workers[i] , NULL);
//}