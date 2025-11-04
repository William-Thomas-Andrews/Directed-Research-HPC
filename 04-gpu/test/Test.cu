/**
 * CUDA GPU Parallel Matrix Multiplication Test Suite
 *
 * This test harness benchmarks CUDA parallel matrix multiplication
 * implementations, evaluating scalability and performance characteristics
 * across various parallelization strategies and thread counts on a GPU.
 */

#include "Test.h"
#include "cuda.h"

#include <omp.h>
#include <immintrin.h>
#include <stdio.h>
#include <unistd.h>


int run_tests() {
    // Set our problem size (Default 2^11 = 2048)
    int N = 1 << 11;
    size_t bytes = N * N * sizeof(bytes);

    // Allocate some memory for our inputs/outputs
    int *a, *b, *c;
    cudaMallocManaged(&a, bytes);
    cudaMallocManaged(&b, bytes);
    cudaMallocManaged(&c, bytes);

    // Initialize our data
    init_matrix(a, N);
    init_matrix(b, N);

    // Initialize our CTA and Grid dimensions
    int THREADS = 2048;
    int BLOCKS = (N + THREADS - 1) / THREADS;

    gpu_multi
}