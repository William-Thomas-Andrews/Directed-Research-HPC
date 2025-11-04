/**
 * Matrix Multiplication Benchmark Suite - Main Entry Point
 *
 * This program executes a comprehensive suite of matrix multiplication
 * algorithm benchmarks to evaluate performance characteristics across
 * different implementation strategies.
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "Test.h"

int main() {
    if (run_tests() != 0) {
        fprintf(stderr, "Error: Benchmark suite execution failed\n");
        exit(1);
    }
    return 0;
}