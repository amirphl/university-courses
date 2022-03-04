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
    for (int i = 0; i < 4; ++i) {
        fork();
    }
    printf("1 ");
    return 0;
}
