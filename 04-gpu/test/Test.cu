/**
 * CUDA GPU Parallel Matrix Multiplication Test Suite
 *
 * This test harness benchmarks CUDA parallel matrix multiplication
 * implementations, evaluating scalability and performance characteristics
 * across various parallelization strategies and thread counts on a GPU.
 */

#include "Test.h"
#include "cuda.cuh"

#include <omp.h>
// #include <immintrin.h>
#include <stdio.h>
#include <unistd.h>

#define POWER 11
#define SIZE pow(2, POWER)

int run_tests() {

    // Set up benchmark time variables
    clock_t begin, end;
    long double time_spent;
    cudaEvent_t start, stop;
    float ms = 0.0;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    // Set our problem size (Default 2^POWER)
    int N = 1 << POWER;
    size_t bytes = N * N * sizeof(bytes);

    // Initialize our CTA and Grid dimensions
    // This is the max in our 2d block (matrix) case as 32x32 = 1024 which is the max thread number for this machine
    int threads = 32; 
    int blocks = (N + threads - 1) / threads;
    printf("Thread configuration: %d threads per block\n", threads);
    printf("Block configuration: %d blocks\n", (N + threads - 1) / threads);

    // Set our kernel launch parameters
    dim3 THREADS(threads, threads);
    dim3 BLOCKS(blocks, blocks);

    // Allocate some memory for our inputs/outputs
    double *a, *b, *res_1, *res_2, *res_3, res_4;
    cudaMallocManaged(&a, bytes);
    cudaMallocManaged(&b, bytes);
    cudaMallocManaged(&res_1, bytes);
    cudaMallocManaged(&res_2, bytes);
    cudaMallocManaged(&res_3, bytes);

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



    /* Benchmark 2: MM2 (Transposed multiply) */
    begin = clock();
    standard_transposed_multiply(a, b, res_1, N);
    end = clock();
    time_spent = end - begin;
    // if (verify(c, d, N) == 1) {
    printf("MM2 (Transposed multiply):               %.6Lf s\n", time_spent / CLOCKS_PER_SEC);
    // }


     /* Benchmark 3: MM3 (Basic GPU matrix multiply) */
    cudaEventRecord(start);
    // Call the kernel
    gpu_multiply<<<BLOCKS, THREADS>>>(a, b, res_2, N);
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    cudaError_t err = cudaGetLastError();
    if (err != cudaSuccess) {
        printf("CUDA Error: %s\n", cudaGetErrorString(err));
        return 1;
    }
    cudaEventElapsedTime(&ms, start, stop);
    if (verify(res_1, res_2, N) == 1) {
        printf("MM3 (Basic GPU matrix multiply):           %.6f s\n", ms/1000);
    } else return 1;

    /* Benchmark 4: MM4 (Shared Memory Cache-Blocking GPU matrix multiply) */
    cudaEventRecord(start);
    // Call the kernel
    multiply_shared_mem_block<32><<<BLOCKS, THREADS>>>(a, b, res_3, N, N, N);
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    err = cudaGetLastError();
    if (err != cudaSuccess) {
        printf("CUDA Error: %s\n", cudaGetErrorString(err));
        return 1;
    }
    cudaEventElapsedTime(&ms, start, stop);
    if (verify(res_1, res_3, N) == 1) {
        printf("MM4 (Shared Memory Cache-Blocking GPU matrix multiply):           %.6f s\n", ms/1000);
    } else return 1;

    

    printf("\n");
    printf("===========================================\n");
    printf("GPU Benchmark suite completed successfully.\n");
    printf("===========================================\n");

    return 0;
}