#include "Test.h"
// #include "avx.h"
#include "../src/multicore.h"

#include <omp.h>


#include <immintrin.h>
#include <stdio.h>
#include <unistd.h>


int run_tests() {
    double begin, end;
    long double time_spent;

    omp_set_num_threads(64);
    printf("Using %d threads\n", omp_get_max_threads());

    // Note: clock() measures the total CPU time across ALL threads, 
    // not the actual elapsed wall-clock time. When OpenMP spawns 16 threads!!!!
    // Takeway: use omp_get_wtime() instead

    int A_rows, A_cols, B_rows, B_cols, size = 2048;
    A_rows = size; A_cols = size; B_rows = size; B_cols = size;

    struct Matrix A; init_matrix_r(&A, A_rows, A_cols); sleep(2);
    struct Matrix B; init_matrix_r(&B, B_rows, B_cols);
    struct Matrix result; init_matrix(&result, A_rows, B_cols);
    struct Matrix result_2; init_matrix(&result_2, A_rows, B_cols);
    struct Matrix result_3; init_matrix(&result_3, A_rows, B_cols);
    struct Matrix result_4; init_matrix(&result_4, A_rows, B_cols);
    struct Matrix result_5; init_matrix(&result_5, A_rows, B_cols);
    struct Matrix result_6; init_matrix(&result_6, A_rows, B_cols);
    struct Matrix result_7; init_matrix(&result_7, A_rows, B_cols);
    struct Matrix result_8; init_matrix(&result_8, A_rows, B_cols);
    struct Matrix result_9; init_matrix(&result_9, A_rows, B_cols);

    printf("Row size: %d\nCol size: %d\n", size, size);

    // --- 1: Matrix Multiplication Function ---
    begin = omp_get_wtime();
    matrix_multiply_1(&result, &A, &B);
    end = omp_get_wtime();
    time_spent = end - begin;
    // printf("Here is the Matrix Multiplication result:\n");
    // print_matrix(&result);
    printf("The standard Matrix Multiplication took %.6Lf s\n", time_spent);
    // --------------------------------

    // --- 2: OpenMP parallel multiply ---
    begin = omp_get_wtime();
    par_multiply_1(&result_2, &A, &B);
    end = omp_get_wtime();
    time_spent = end - begin;
    // printf("Here is the Matrix Multiplication result:\n");
    // print_matrix(&result);
    // printf("The OpenMP parallel took %.6Lf s\n", time_spent);
    if (cmp_matrix(&result, &result_2) == 1) printf("M1 and OpenMP parallel 1 are the same! This function call took %.6Lf s\n", time_spent);
    // --------------------------------

    // // --- 3: AVX blocked unrolled ---
    transpose(&B);
    begin = omp_get_wtime();
    unroll_blocked_avx(&result_3, &A, &B, A.cols, A.cols/2);
    end = omp_get_wtime();
    time_spent = end - begin;
    // printf("Here is the Matrix Multiplication result:\n");
    // print_matrix(&result);
    // printf("The OpenMP parallel took %.6Lf s\n", time_spent);
    if (cmp_matrix(&result, &result_3) == 1) printf("M1 and AVX blocked are the same! This function call took %.6Lf s\n", time_spent);
    transpose(&B);
    // --------------------------------


    // --- 4: Parallel AVX blocked unrolled ---
    transpose(&B);
    begin = omp_get_wtime();
    par_unroll_blocked_avx(&result_4, &A, &B, A.cols, A.cols/2);
    end = omp_get_wtime();
    time_spent = end - begin;
    // printf("Here is the Matrix Multiplication result:\n");
    // print_matrix(&result);
    // printf("The OpenMP parallel took %.6Lf s\n", time_spent);
    if (cmp_matrix(&result, &result_4) == 1) printf("M1 and Parallel AVX blocked are the same! This function call took %.6Lf s\n", time_spent);
    transpose(&B);
    // --------------------------------


    // --- 5: OpenMP parallel multiply 2 ---
    begin = omp_get_wtime();
    par_multiply_2(&result_5, &A, &B);
    end = omp_get_wtime();
    time_spent = end - begin;
    // printf("Here is the Matrix Multiplication result:\n");
    // print_matrix(&result);
    // printf("The OpenMP parallel took %.6Lf s\n", time_spent);
    if (cmp_matrix(&result, &result_5) == 1) printf("M1 and Parallel multiply 2 are the same! This function call took %.6Lf s\n", time_spent);
    // --------------------------------

    // // --- 6: Special par_multiply combo ---
    transpose(&B);
    begin = omp_get_wtime();
    par_multiply_3(&result_6, &A, &B);
    end = omp_get_wtime();
    time_spent = end - begin;
    // printf("Here is the Matrix Multiplication result:\n");
    // print_matrix(&result);
    // printf("The OpenMP parallel took %.6Lf s\n", time_spent);
    if (cmp_matrix(&result, &result_6) == 1) printf("M1 and combo par multiply are the same! This function call took %.6Lf s\n", time_spent);
    transpose(&B);
    // --------------------------------


    // Fastest
    // // --- 7: Fast par_multiply combo ---
    transpose(&B);
    begin = omp_get_wtime();
    par_multiply_4(&result_7, &A, &B);
    end = omp_get_wtime();
    time_spent = end - begin;
    // printf("Here is the Matrix Multiplication result:\n");
    // print_matrix(&result);
    // printf("The OpenMP parallel took %.6Lf s\n", time_spent);
    if (cmp_matrix(&result, &result_7) == 1) printf("M1 and Fast par multiply are the same! This function call took %.6Lf s\n", time_spent);
    transpose(&B);
    // --------------------------------

    // // --- 7: Fast par_multiply combo 2 ---
    transpose(&B);
    begin = omp_get_wtime();
    par_multiply_5(&result_8, &A, &B);
    end = omp_get_wtime();
    time_spent = end - begin;
    // printf("Here is the Matrix Multiplication result:\n");
    // print_matrix(&result);
    // printf("The OpenMP parallel took %.6Lf s\n", time_spent);
    if (cmp_matrix(&result, &result_8) == 1) printf("M1 and Fast par multiply 2 are the same! This function call took %.6Lf s\n", time_spent);
    transpose(&B);
    // --------------------------------


        // // --- 8: Fast par_multiply combo 3 ---
    transpose(&B);
    begin = omp_get_wtime();
    par_multiply_6(&result_9, &A, &B);
    end = omp_get_wtime();
    time_spent = end - begin;
    // printf("Here is the Matrix Multiplication result:\n");
    // print_matrix(&result);
    // printf("The OpenMP parallel took %.6Lf s\n", time_spent);
    if (cmp_matrix(&result, &result_9) == 1) printf("M1 and Fast par multiply 3 are the same! This function call took %.6Lf s\n", time_spent);
    transpose(&B);
    // --------------------------------



    return 0;
}