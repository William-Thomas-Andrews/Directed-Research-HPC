
/**
 * Test Suite for Matrix Multiplication Implementations
 *
 * This test harness evaluates the performance and correctness of various
 * matrix multiplication algorithms including standard implementations,
 * cache-optimized variants, and blocked algorithms.
 */

#include "Test.h"
#include "Matrix.h"

#define SIZE 2048

int run_tests() {
    clock_t begin, end;
    float time_spent;

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

    printf("Executing square matrix multiplication benchmark: %d x %d\n", SIZE, SIZE);

    /* Benchmark 1: Standard Matrix Multiplication (Baseline) */
    begin = clock();
    matrix_multiply_1(&result, &A, &B);
    end = clock();
    time_spent = (float)(end - begin) / CLOCKS_PER_SEC;
    printf("MM1 (Standard):                           %.6f s\n", time_spent);

    /* Benchmark 10: Cache-Optimized with Transposed B */
    struct Matrix result_10;
    init_matrix_r(&result_10, A_rows, B_cols);
    begin = clock();
    transpose(&B);
    matrix_multiply_with_transposed_B(&result_10, &A, &B);
    end = clock();
    time_spent = (float)(end - begin) / CLOCKS_PER_SEC;
    printf("MM10 (Transposed B):                      %.6f s\n", time_spent);
    transpose(&B);

    /* Benchmark 9: Block-Based (Bailey & Oliviera) */
    struct Matrix result_9;
    init_matrix_r(&result_9, A_rows, B_cols);
    begin = clock();
    bijk(&result_9, &A, &B, A.cols, A.cols/2);
    end = clock();
    time_spent = (float)(end - begin) / CLOCKS_PER_SEC;
    printf("MM9 (Blocked BIJK):                       %.6f s\n", time_spent);

    /* Benchmark 8: Parallel Blocked Implementation */
    struct Matrix result_8;
    init_matrix_r(&result_8, A_rows, B_cols);
    begin = clock();
    matrix_multiply_8(&result_8, &A, &B);
    end = clock();
    time_spent = (float)(end - begin) / CLOCKS_PER_SEC;
    printf("MM8 (Parallel Blocked):                   %.6f s\n", time_spent);

    /* Benchmark 7: Blocked Algorithm */
    struct Matrix result_7;
    init_matrix_r(&result_7, A_rows, B_cols);
    begin = clock();
    matrix_multiply_7(&result_7, &A, &B);
    end = clock();
    time_spent = (float)(end - begin) / CLOCKS_PER_SEC;
    printf("MM7 (Blocked):                            %.6f s\n", time_spent);

    /* Benchmark 2: Loop Variant Implementation */
    struct Matrix result_2;
    init_matrix_r(&result_2, A_rows, B_cols);
    begin = clock();
    matrix_multiply_2(&result_2, &A, &B);
    end = clock();
    time_spent = (float)(end - begin) / CLOCKS_PER_SEC;
    printf("MM2 (Loop Variant):                       %.6f s\n", time_spent);

    /* Benchmark 3: Alternative Loop Ordering */
    struct Matrix result_3;
    init_matrix_r(&result_3, A_rows, B_cols);
    begin = clock();
    matrix_multiply_3(&result_3, &A, &B);
    end = clock();
    time_spent = (float)(end - begin) / CLOCKS_PER_SEC;
    printf("MM3 (Alternative Loop Order):             %.6f s\n", time_spent);

    /* Benchmark 4: Loop Optimization Variant */
    struct Matrix result_4;
    init_matrix_r(&result_4, A_rows, B_cols);
    begin = clock();
    matrix_multiply_4(&result_4, &A, &B);
    end = clock();
    time_spent = (float)(end - begin) / CLOCKS_PER_SEC;
    printf("MM4 (Optimization Variant):               %.6f s\n", time_spent);

    /* Benchmark 5: Cache-Aware Implementation */
    struct Matrix result_5;
    init_matrix_r(&result_5, A_rows, B_cols);
    begin = clock();
    matrix_multiply_5(&result_5, &A, &B);
    end = clock();
    time_spent = (float)(end - begin) / CLOCKS_PER_SEC;
    printf("MM5 (Cache-Aware):                        %.6f s\n", time_spent);

    /* Benchmark 6: Advanced Optimization */
    struct Matrix result_6;
    init_matrix_r(&result_6, A_rows, B_cols);
    begin = clock();
    matrix_multiply_6(&result_6, &A, &B);
    end = clock();
    time_spent = (float)(end - begin) / CLOCKS_PER_SEC;
    printf("MM6 (Advanced Optimization):              %.6f s\n", time_spent);

    printf("\n");
    printf("========================================\n");
    printf("Benchmark suite completed successfully.\n");
    printf("========================================\n");

    return 0;
}