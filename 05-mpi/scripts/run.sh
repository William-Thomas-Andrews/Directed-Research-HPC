#!/bin/bash

# Default to 4 processes if not specified
NUM_PROCS=${1:-4}

cd ../build
mpirun -np $NUM_PROCS ./bin/mpi_matmul
cd ../scripts
