//
// Created by amirphl on 11/2/18.
//

#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>

int sum = 0;

void *runner(void *param);

int main(int argc, char *argv[]) {
    pid_t pid;
    pthread_t tid;
    pthread_attr_t attr;

    pid = fork();
    if (pid == 0) {
        pthread_attr_init(&attr);
        pthread_create(&tid, &attr, runner, NULL);
        pthread_join(tid, NULL);
        printf("CHILD : value = %d\n", sum);
    } else if (pid > 0) {
        wait(NULL);
        printf("PARENT : value = %d\n", sum);
    }
}

void *runner(void *param) {
    sum = 5;

    pthread_exit(0);
}

//{
//    pthread_t workers[10];
//
//    for(int i = 0 ; i < 10 ; i++)
//        pthread_join(workers[i] , NULL);
//}