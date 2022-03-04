#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdlib.h>

int main1() {

    pid_t pid;
    pid = fork();
    int status;

    if (pid < 0) {
        fprintf(stderr, "Fork Failed.");
        return 1;
    } else if (pid == 0) {
        execlp("/bin/ls", "ls -la", NULL);
        exit(1356);
    } else {
        wait(&status);
        printf("%i \n", status);
        printf("Child completed.\n");
    }

    //    int i = 0;
//
//    printf("A    %d\n", getpid());
//
//    if (fork() || fork()) {
//        printf("B    %d\n", getpid());
//        fork();
//        printf("C    %d\n", getpid());
//    }
//
//    printf("D    %d\n", getpid());
//

    return 0;
}