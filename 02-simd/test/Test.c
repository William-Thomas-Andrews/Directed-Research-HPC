/**
 * SIMD-Optimized Matrix Multiplication Test Suite
 *
 * This test harness benchmarks AVX-512 SIMD implementations of matrix
 * multiplication, comparing vectorized operations against baseline
 * implementations and evaluating various optimization techniques.
 */

#include "Test.h"
#include "avx.h"

#include <immintrin.h>
#include <stdio.h>
#include <unistd.h>

#define SIZE 2048

int run_tests() {
    clock_t begin, end;
    long double time_spent;

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

    printf("Executing SIMD matrix multiplication benchmark: %d x %d\n", SIZE, SIZE);

    /* Benchmark 1: Standard Matrix Multiplication (Baseline) */
    begin = clock();
    matrix_multiply_1(&result, &A, &B);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    printf("MM1 (Standard):                           %.6Lf s\n", time_spent);

    /* Benchmark 2: AVX-512 Intrinsics */
    transpose(&B);
    begin = clock();
    avx_matrix_multiply(&result_2, &A, &B);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    printf("MM2 (AVX-512 Intrinsics):                 %.6Lf s\n", time_spent);
    if (cmp_matrix(&result, &result_2) == 1) {
        printf("     Correctness verified.\n");
    }
    transpose(&B);

    /* Benchmark 6: Bryant & O'Hallaron Blocked Algorithm */
    begin = clock();
    bijk(&result_6, &A, &B, A.cols, A.cols/2);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    printf("MM6 (Blocked BIJK):                       %.6Lf s\n", time_spent);
    if (cmp_matrix(&result, &result_6) == 1) {
        printf("     Correctness verified.\n");
    }

    /* Benchmark 7: Blocked AVX Implementation */
    transpose(&B);
    begin = clock();
    blocked_avx(&result_7, &A, &B, A.cols, A.cols/2);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    printf("MM7 (Blocked AVX):                        %.6Lf s\n", time_spent);
    if (cmp_matrix(&result, &result_7) == 1) {
        printf("     Correctness verified.\n");
    }
    transpose(&B);

    /* Benchmark 8: Loop-Unrolled Blocked AVX */
    transpose(&B);
    begin = clock();
    unroll_blocked_avx(&result_8, &A, &B, A.cols, A.cols/2);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    printf("MM8 (Unrolled Blocked AVX):               %.6Lf s\n", time_spent);
    if (cmp_matrix(&result, &result_8) == 1) {
        printf("     Correctness verified.\n");
    }
    transpose(&B);

    printf("\n");
    printf("========================================\n");
    printf("Benchmark suite completed successfully.\n");
    printf("========================================\n");
    

    return 0;
}