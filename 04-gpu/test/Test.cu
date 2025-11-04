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
// #include <immintrin.h>
#include <stdio.h>
#include <unistd.h>

#define POWER 11

int run_tests() {
    // Set up benchmark time variables
    // clock_t begin, end;
    // long double time_spent;
    cudaEvent_t start, stop;
    float ms = 0.0;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    // Set our problem size (Default 2^POWER)
    int N = 1 << POWER;
    size_t bytes = N * N * sizeof(bytes);

    // Allocate some memory for our inputs/outputs
    double *a, *b, *c, *d;
    cudaMallocManaged(&a, bytes);
    cudaMallocManaged(&b, bytes);
    cudaMallocManaged(&c, bytes);
    cudaMallocManaged(&d, bytes);

    // Initialize our data
    init_matrix(a, N);
    init_matrix(b, N);

    // /* Benchmark 1: Standard Matrix Multiplication (Sequential Baseline) */
    // printf("Running sequential baseline ...\n");
    // begin = clock();
    // standard_multiply(a, b, c, N);
    // end = clock();
    // time_spent = end - begin;
    // printf("MM1 (Sequential Baseline):                %.6Lf s\n", time_spent/CLOCKS_PER_SEC);

    // Initialize our CTA and Grid dimensions
    int THREADS = 2000;
    int BLOCKS = (N + THREADS - 1) / THREADS;

    printf("Thread configuration: %d threads\n", THREADS);


    // /* Benchmark 2: MM2 (Previous best matrix multiply) */
    // begin = clock();
    // // Call the kernel
    // gpu_multiply<<<BLOCKS, THREADS>>>(a, b, d, N);
    // cudaDeviceSynchronize();
    // end = clock();
    // time_spent = end - begin;
    // if (cmp_matrix(c, d, N) == 1) {
    //     printf("MM2 (Basic GPU matrix multiply):               %.6Lf s\n", time_spent);
    // }


     /* Benchmark 3: MM2 (Basic GPU matrix multiply) */
    cudaEventRecord(start);
    // Call the kernel
    gpu_multiply<<<BLOCKS, THREADS>>>(a, b, d, N);
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    cudaEventElapsedTime(&ms, start, stop);
    printf("MM3 (Basic GPU matrix multiply):               %.6f s\n", ms/1000);
    // if (verify(c, d, N) == 1) {
    //     printf("MM3 (Basic GPU matrix multiply):               %.6f ms\n", ms);
    // }
    // else return 1;


    printf("\n");
    printf("===========================================\n");
    printf("GPU Benchmark suite completed successfully.\n");
    printf("===========================================\n");

    return 0;
}