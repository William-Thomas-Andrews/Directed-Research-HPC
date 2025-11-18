#include <iostream>
#include <memory>
#include <random>
#include <unistd.h>
#include <sys/types.h> 



#include "mpi.h"

int main(int argc, char *argv[]) {
    // Initialize MPI
    MPI_Init(&argc, &argv);
    // printf("Process: %d\n", getpid());

    // 


    MPI_Finalize();
}