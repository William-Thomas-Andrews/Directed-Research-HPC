/**
 * CUDA GPU Parallel Matrix Multiplication Test Suite
 *
 * This test harness benchmarks CUDA parallel matrix multiplication
 * implementations, evaluating scalability and performance characteristics
 * across various parallelization strategies and thread counts on a GPU.
 * 
 * Much Credit: https://siboehm.com/articles/22/CUDA-MMM
 */

#include "Test.h"
#include "cuda.cuh"

#include <omp.h>
// #include <immintrin.h>
#include <stdio.h>
#include <unistd.h>

#define POWER 14
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
    size_t bytes = N * N * sizeof(double);

    // Initialize our CTA and Grid dimensions
    // This is the max in our 2d block (matrix) case as 32x32 = 1024 which is the max thread number for this machine
    const int threads = 32;
    int blocks = (N + threads - 1) / threads;
    printf("Matrix size: %d x %d (%zu MB)\n", N, N, bytes / (1024 * 1024));
    printf("Thread configuration: %d threads per block\n", threads);
    printf("Block configuration: %d blocks\n", (N + threads - 1) / threads);



    // Set our kernel launch parameters
    dim3 THREADS(threads, threads);
    dim3 BLOCKS(blocks, blocks);

    // Allocate host memory for initialization
    // double *h_a = (double*)malloc(bytes);
    // double *h_b = (double*)malloc(bytes);

    // Initialize our data on host
    // init_matrix(h_a, N);
    // init_matrix(h_b, N);

    // Allocate device memory for our inputs/outputs
    double *a, *b, *res_1, *res_2, *res_3, *res_4, *res_5, *res_6, *res_7;
    cudaMallocManaged(&a, bytes);
    cudaMallocManaged(&b, bytes);
    cudaMallocManaged(&res_1, bytes);
    cudaMallocManaged(&res_2, bytes);
    cudaMallocManaged(&res_3, bytes);
    cudaMallocManaged(&res_4, bytes);
    cudaMallocManaged(&res_5, bytes);
    cudaMallocManaged(&res_6, bytes);
    cudaMallocManaged(&res_7, bytes);

    // Allocate float arrays for single-precision cuBLAS comparison
    size_t bytes_float = N * N * sizeof(float);
    float *a_float, *b_float, *res_8, *res_9;
    cudaMallocManaged(&a_float, bytes_float);
    cudaMallocManaged(&b_float, bytes_float);
    cudaMallocManaged(&res_8, bytes_float);
    cudaMallocManaged(&res_9, bytes_float);

    init_matrix(a, N);
    init_matrix(b, N);

    // Initialize float matrices (convert from double)
    for (int i = 0; i < N * N; i++) {
        a_float[i] = (float)a[i];
        b_float[i] = (float)b[i];
    }

    // Initialize cuBLAS handle
    cublasHandle_t handle;
    cublasCreate(&handle);

    // Transfer data to device once before all benchmarks
    // cudaMemcpy(a, h_a, bytes, cudaMemcpyHostToDevice);
    // cudaMemcpy(b, h_b, bytes, cudaMemcpyHostToDevice);

    // Initialize all result matrices to zero
    // cudaMemset(res_1, 0, bytes);
    // cudaMemset(res_2, 0, bytes);
    // cudaMemset(res_3, 0, bytes);
    // cudaMemset(res_4, 0, bytes);
    // cudaMemset(res_5, 0, bytes);

    // Warmup kernel to initialize GPU and compile kernels
    // gpu_multiply<<<BLOCKS, THREADS>>>(a, b, res_1, N);
    // cudaDeviceSynchronize();

    // Prefetch unified memory to GPU device for cuBLAS
    int device = 0;
    cudaGetDevice(&device);
    cudaMemPrefetchAsync(a, bytes, device, 0);
    cudaMemPrefetchAsync(b, bytes, device, 0);
    cudaMemPrefetchAsync(res_7, bytes, device, 0);
    cudaMemPrefetchAsync(a_float, bytes_float, device, 0);
    cudaMemPrefetchAsync(b_float, bytes_float, device, 0);
    cudaMemPrefetchAsync(res_8, bytes_float, device, 0);
    cudaMemPrefetchAsync(res_9, bytes_float, device, 0);
    cudaDeviceSynchronize();

    // Warmup cuBLAS (important: cuBLAS performs JIT compilation on first call)
    multiply_cublas(handle, a, b, res_7, N, N, N);
    multiply_cublas_float(handle, a_float, b_float, res_8, N, N, N);
    cudaDeviceSynchronize();

    // /* Benchmark 1: Standard Matrix Multiplication (Sequential Baseline) */
    // printf("Running sequential baseline ...\n");
    // begin = clock();
    // standard_multiply(a, b, c, N);
    // end = clock();
    // time_spent = end - begin;
    // printf("MM1 (Sequential Baseline):                %.6Lf s\n", time_spent/CLOCKS_PER_SEC);



    /* Benchmark 2: MM2 (Transposed multiply) */
    begin = clock();
    // standard_transposed_multiply(a, b, res_1, N);
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
    printf("MM3 (Basic GPU matrix multiply):           %.6f s\n", ms/1000);
    // if (verify(res_1, res_2, N) == 1) {
    //     printf("MM3 (Basic GPU matrix multiply):           %.6f s\n", ms/1000);
    // } else return 1;

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
    printf("MM4 (Shared Memory Cache-Blocking GPU matrix multiply):           %.6f s\n", ms/1000);
    // if (verify(res_1, res_3, N) == 1) {
    //     printf("MM4 (Shared Memory Cache-Blocking GPU matrix multiply):           %.6f s\n", ms/1000);
    // } else return 1;

    // Configure for blocktiling kernel
    const int threads_bt = (128 * 128) / (8 * 8);   // = 256 threads (1D)
    const int blocks_bt = (N + 128 - 1) / 128;      // Number of 128x128 tiles per dimension
    dim3 BLOCKS_BT(blocks_bt, blocks_bt);           // 2D grid of blocks
    dim3 THREADS_BT(threads_bt);                    // 1D block of 256 threads

    /* Benchmark 5: MM5 (Blocktiling GPU matrix multiply) */
    cudaEventRecord(start);
    // Call the kernel
    multiply_blocktiling<128, 128, 8, 8, 8><<<BLOCKS_BT, THREADS_BT>>>(N, N, N, a, b, res_4);
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    err = cudaGetLastError();
    if (err != cudaSuccess) {
        printf("CUDA Error: %s\n", cudaGetErrorString(err));
        return 1;
    }
    cudaEventElapsedTime(&ms, start, stop);
    printf("MM5 (Blocktiling GPU matrix multiply):           %.6f s\n", ms/1000);
    // if (verify(res_1, res_4, N) == 1) {
    //     printf("MM5 (Blocktiling GPU matrix multiply):           %.6f s\n", ms/1000);
    // } else return 1;

    /* Benchmark 6: MM6 (Vectorized GPU matrix multiply) */
    cudaEventRecord(start);
    // Call the kernel
    multiply_vectorize<128, 128, 8, 8, 8><<<BLOCKS_BT, THREADS_BT>>>(N, N, N, a, b, res_5);
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    err = cudaGetLastError();
    if (err != cudaSuccess) {
        printf("CUDA Error: %s\n", cudaGetErrorString(err));
        return 1;
    }
    cudaEventElapsedTime(&ms, start, stop);
    printf("MM6 (Vectorized GPU matrix multiply):           %.6f s\n", ms/1000);
    // if (verify(res_1, res_5, N) == 1) {
    //     printf("MM6 (Vectorized GPU matrix multiply):           %.6f s\n", ms/1000);
    // } else return 1;

    /* Benchmark 7: MM7 (Autotuned GPU matrix multiply) */
    cudaEventRecord(start);
    // Call the kernel
    multiply_autotuned<128, 128, 8, 8, 8><<<BLOCKS_BT, THREADS_BT>>>(N, N, N, a, b, res_6);
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    err = cudaGetLastError();
    if (err != cudaSuccess) {
        printf("CUDA Error: %s\n", cudaGetErrorString(err));
        return 1;
    }
    cudaEventElapsedTime(&ms, start, stop);
    printf("MM7 (Autotuned GPU matrix multiply):           %.6f s\n", ms/1000);
    // if (verify(res_1, res_6, N) == 1) {
    //     printf("MM7 (Autotuned GPU matrix multiply):           %.6f s\n", ms/1000);
    // } else return 1;

    /* Benchmark 8: MM8 (cuBLAS GPU matrix multiply - double precision) */
    cudaEventRecord(start);
    // Call cuBLAS DGEMM
    multiply_cublas(handle, a, b, res_7, N, N, N);
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    err = cudaGetLastError();
    if (err != cudaSuccess) {
        printf("CUDA Error: %s\n", cudaGetErrorString(err));
        return 1;
    }
    cudaEventElapsedTime(&ms, start, stop);
    printf("MM8 (cuBLAS double-precision):                 %.6f s\n", ms/1000);
    // if (verify(res_1, res_7, N) == 1) {
    //     printf("MM8 (cuBLAS double-precision):                 %.6f s\n", ms/1000);
    // } else return 1;

    /* Benchmark 9: MM9 (cuBLAS GPU matrix multiply - single precision) */
    cudaEventRecord(start);
    // Call cuBLAS SGEMM
    multiply_cublas_float(handle, a_float, b_float, res_8, N, N, N);
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    err = cudaGetLastError();
    if (err != cudaSuccess) {
        printf("CUDA Error: %s\n", cudaGetErrorString(err));
        return 1;
    }
    cudaEventElapsedTime(&ms, start, stop);
    printf("MM9 (cuBLAS single-precision):                 %.6f s\n", ms/1000);



     /* Benchmark 10: MM10 (Basic float GPU matrix multiply) */
    cudaEventRecord(start);
    // Call the kernel
    gpu_multiply_float<<<BLOCKS, THREADS>>>(a_float, b_float, res_9, N);
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    err = cudaGetLastError();
    if (err != cudaSuccess) {
        printf("CUDA Error: %s\n", cudaGetErrorString(err));
        return 1;
    }
    cudaEventElapsedTime(&ms, start, stop);
    printf("MM10 (Basic float GPU matrix multiply):           %.6f s\n", ms/1000);
    // if (verify(res_1, res_9, N) == 1) {
    //     printf("MM10 (Basic float GPU matrix multiply):           %.6f s\n", ms/1000);
    // } else return 1;


    printf("\n");
    printf("===========================================\n");
    printf("GPU Benchmark suite completed successfully.\n");
    printf("===========================================\n");

    // Clean up cuBLAS handle
    cublasDestroy(handle);

    // // Clean up device memory
    // cudaFree(a);
    // cudaFree(b);
    // cudaFree(res_1);
    // cudaFree(res_2);
    // cudaFree(res_3);
    // cudaFree(res_4);
    // cudaFree(res_5);

    // // Clean up host memory
    // // free(h_a);
    // // free(h_b);

    // // Clean up CUDA events
    // cudaEventDestroy(start);
    // cudaEventDestroy(stop);

    return 0;
}