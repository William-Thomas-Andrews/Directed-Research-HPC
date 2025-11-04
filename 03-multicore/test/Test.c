/**
 * Multicore Parallel Matrix Multiplication Test Suite
 *
 * This test harness benchmarks OpenMP-based parallel matrix multiplication
 * implementations, evaluating scalability and performance characteristics
 * across various parallelization strategies and thread counts.
 */

#include "Test.h"
#include "../src/multicore.h"

#include <omp.h>
#include <immintrin.h>
#include <stdio.h>
#include <unistd.h>

#define SIZE 1024
#define NUM_THREADS 64

int run_tests() {
    double begin, end;
    long double time_spent;

    omp_set_num_threads(NUM_THREADS);
    printf("Thread configuration: %d threads\n", omp_get_max_threads());

    int A_rows, A_cols, B_rows, B_cols;
    A_rows = SIZE;
    A_cols = SIZE;
    B_rows = SIZE;
    B_cols = SIZE;

    struct Matrix A;
    init_matrix_r(&A, A_rows, A_cols);
    sleep(2);
    struct Matrix B;
    init_matrix_r(&B, B_rows, B_cols);
    struct Matrix result;
    init_matrix(&result, A_rows, B_cols);
    struct Matrix result_2;
    init_matrix(&result_2, A_rows, B_cols);
    struct Matrix result_3;
    init_matrix(&result_3, A_rows, B_cols);
    struct Matrix result_4;
    init_matrix(&result_4, A_rows, B_cols);
    struct Matrix result_5;
    init_matrix(&result_5, A_rows, B_cols);
    struct Matrix result_6;
    init_matrix(&result_6, A_rows, B_cols);
    struct Matrix result_7;
    init_matrix(&result_7, A_rows, B_cols);
    struct Matrix result_8;
    init_matrix(&result_8, A_rows, B_cols);
    struct Matrix result_9;
    init_matrix(&result_9, A_rows, B_cols);

    printf("Matrix dimensions: %d x %d\n", SIZE, SIZE);

    /* Benchmark 1: Standard Matrix Multiplication (Sequential Baseline) */
    begin = omp_get_wtime();
    matrix_multiply_1(&result, &A, &B);
    end = omp_get_wtime();
    time_spent = end - begin;
    printf("MM1 (Sequential Baseline):                %.6Lf s\n", time_spent);

    /* Benchmark 2: OpenMP Parallel Implementation */
    begin = omp_get_wtime();
    par_multiply_1(&result_2, &A, &B);
    end = omp_get_wtime();
    time_spent = end - begin;
    if (cmp_matrix(&result, &result_2) == 1) {
        printf("MM2 (OpenMP Parallel):                    %.6Lf s\n", time_spent);
    }

    /* Benchmark 3: Unrolled Blocked AVX (Sequential) */
    transpose(&B);
    begin = omp_get_wtime();
    unroll_blocked_avx(&result_3, &A, &B, A.cols, A.cols/2);
    end = omp_get_wtime();
    time_spent = end - begin;
    if (cmp_matrix(&result, &result_3) == 1) {
        printf("MM3 (AVX Blocked Sequential):             %.6Lf s\n", time_spent);
    }
    transpose(&B);

    /* Benchmark 4: Parallel Unrolled Blocked AVX */
    transpose(&B);
    begin = omp_get_wtime();
    par_unroll_blocked_avx(&result_4, &A, &B, A.cols, A.cols/2);
    end = omp_get_wtime();
    time_spent = end - begin;
    if (cmp_matrix(&result, &result_4) == 1) {
        printf("MM4 (Parallel AVX Blocked):               %.6Lf s\n", time_spent);
    }
    transpose(&B);

    /* Benchmark 5: OpenMP Parallel Variant 2 */
    begin = omp_get_wtime();
    par_multiply_2(&result_5, &A, &B);
    end = omp_get_wtime();
    time_spent = end - begin;
    if (cmp_matrix(&result, &result_5) == 1) {
        printf("MM5 (Parallel Variant 2):                 %.6Lf s\n", time_spent);
    }

    /* Benchmark 6: Hybrid Parallel Strategy */
    transpose(&B);
    begin = omp_get_wtime();
    par_multiply_3(&result_6, &A, &B);
    end = omp_get_wtime();
    time_spent = end - begin;
    if (cmp_matrix(&result, &result_6) == 1) {
        printf("MM6 (Hybrid Parallel):                    %.6Lf s\n", time_spent);
    }
    transpose(&B);

    /* Benchmark 7: Optimized Parallel Implementation */
    transpose(&B);
    begin = omp_get_wtime();
    par_multiply_4(&result_7, &A, &B);
    end = omp_get_wtime();
    time_spent = end - begin;
    if (cmp_matrix(&result, &result_7) == 1) {
        printf("MM7 (Optimized Parallel):                 %.6Lf s\n", time_spent);
    }
    transpose(&B);

    /* Benchmark 8: Advanced Parallel Strategy */
    transpose(&B);
    begin = omp_get_wtime();
    par_multiply_5(&result_8, &A, &B);
    end = omp_get_wtime();
    time_spent = end - begin;
    if (cmp_matrix(&result, &result_8) == 1) {
        printf("MM8 (Hardware-Specialized Parallel):      %.6Lf s\n", time_spent);
    }
    transpose(&B);

    /* Benchmark 9: High-Performance Parallel Configuration */
    transpose(&B);
    begin = omp_get_wtime();
    par_multiply_6(&result_9, &A, &B);
    end = omp_get_wtime();
    time_spent = end - begin;
    if (cmp_matrix(&result, &result_9) == 1) {
        printf("MM9 (Hardware-Specialized Parallel):      %.6Lf s\n", time_spent);
    }
    transpose(&B);

    printf("\n");
    printf("========================================\n");
    printf("Benchmark suite completed successfully.\n");
    printf("========================================\n");

    return 0;
}