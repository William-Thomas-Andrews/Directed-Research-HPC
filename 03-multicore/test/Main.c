/**
 * Multicore Parallel Matrix Multiplication Benchmark Suite - Main Entry Point
 *
 * This program executes a comprehensive suite of OpenMP-based parallel matrix
 * multiplication benchmarks to evaluate scalability, parallel efficiency, and
 * performance characteristics across different thread counts and parallelization
 * strategies.
 */

#include "Test.h"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main() {
    if (run_tests() != 0) {
        fprintf(stderr, "Error: Benchmark suite execution failed\n");
        exit(1);
    }
    return 0;
}