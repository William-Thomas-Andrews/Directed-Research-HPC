/**
 * SIMD Matrix Multiplication Benchmark Suite - Main Entry Point
 *
 * This program executes a comprehensive suite of AVX-512 SIMD matrix
 * multiplication benchmarks to evaluate performance characteristics of
 * vectorized implementations and various SIMD optimization techniques.
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