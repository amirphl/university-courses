#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>

int main1() {

    pid_t pid = getpid();

    if (fork() && fork()) {
        fork();
    }

    if (fork() || fork()) {
        fork();
    }

    printf("Hello\n");
    if(getpid() == pid)
        sleep(5);
    return 0;
}