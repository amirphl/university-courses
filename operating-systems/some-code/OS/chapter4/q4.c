//
// Created by amirphl on 11/2/18.
//

#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>

int main(int argc, char *argv[]) {
    pid_t pid;
    int level = 0;
    printf("I am in level 0 so level = %d\n", level);
    pid = fork();
    if (pid > 0) {
        level++;
        printf("I am in level 1 so level = %d\n", level);
    }
    pid_t pid_1 = fork();
    if (pid_1 > 0) {
        level++;
        if (pid == 0)
            printf("I am in level 1 so level = %d\n", level);
        else
            printf("I am in level 2 so level = %d\n", level);
    }
    pid_t pid_2 = fork();
    if (pid_2 > 0) {
        level++;
        if (pid == 0 && pid_1 == 0)
            printf("I am in level 1 so level = %d\n", level);
        else if (pid == 0 && pid_1 > 0)
            printf("I am in level 2 so level = %d\n", level);
        else if (pid > 0 && pid_1 == 0)
            printf("I am in level 2 so level = %d\n", level);
        else if (pid > 0 && pid_1 > 0)
            printf("I am in level 3 so level = %d\n", level);
    }
    if (pid > 0)
        wait(NULL);
    return 0;
}
