#include "Test.h"
#include "avx.h"

#include <immintrin.h>
#include <stdio.h>
#include <unistd.h>


int run_tests() {

    clock_t begin, end;
    long double time_spent;

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

    printf("Row size: %d\nCol size: %d\n", size, size);

    // --- 1st Matrix Multiplication Function ---
    begin = clock();
    matrix_multiply_1(&result, &A, &B);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    // printf("Here is the Matrix Multiplication result:\n");
    // print_matrix(&result);
    printf("The standard Matrix Multiplication took %.6Lf s\n", time_spent);
    // --------------------------------


    // --- 2nd Matrix Multiplication Function - avx512 intrinsics ---
    transpose(&B);
    // DEFINE_PRE_AVX(struct Matrix*)
    begin = clock();
    avx_matrix_multiply(&result_2, &A, &B);
    // PRE_AVX(&result_2, &A, &B);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    // printf("Here is the avx512 result:\n");
    // print_matrix(&result);
    printf("The avx512 instrinsic function took %.6Lf s\n", time_spent);
    if (cmp_matrix(&result, &result_2) == 1) {printf("Yay the matrix is correct!\n");}
    transpose(&B); // Transpose B back
    // --------------------------------
    
    
    // --- 3rd Matrix Multiplication Function - restricted pointer avx512 intrinsics ---
    transpose(&B);
    begin = clock();
    // transpose(&B); // Includes the transpose to be fair with the avx function
    // restricted_avx_matrix_multiply(&result_3, &A, &B);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    // printf("Here is the cache-friendly-transposition result:\n");
    // print_matrix(&result);
    // printf("The restricted pointer avx512 intrinsic function took %.6Lf s\n", time_spent);
    if (cmp_matrix(&result, &result_3) == 1) {printf("Yay the matrix is correct!\n");}
    transpose(&B); // Transpose B back
    // --------------------------------

    // --- 4th Matrix Multiplication Function - cache-friendly-transposition ---
    transpose(&B);
    begin = clock();
    // transpose(&B); // Includes the transpose to be fair with the avx function
    // matrix_multiply_with_transposed_B(&result_4, &A, &B);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    // printf("Here is the cache-friendly-transposition result:\n");
    // print_matrix(&result);
    // printf("The cache-friendly transposition function took %.6Lf s\n", time_spent);
    if (cmp_matrix(&result, &result_4) == 1) {printf("Yay the matrix is correct!\n");}
    transpose(&B); // Transpose B back
    // --------------------------------


    // --- 5th Matrix Multiplication Function - Preprocessor function avx512 intrinsics ---
    transpose(&B);
    DEFINE_PRE_AVX(struct Matrix*)
    begin = clock();
    // avx_matrix_multiply(&result_2, &A, &B);
    // PRE_AVX(&result_5, &A, &B);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    // printf("Here is the avx512 result:\n");
    // print_matrix(&result);
    // printf("The preprocessor avx512 instrinsic function took %.6Lf s\n", time_spent);
    if (cmp_matrix(&result, &result_5) == 1) {printf("Yay the matrix is correct!\n");}
    transpose(&B); // Transpose B back
    // --------------------------------


    // --- 6th Matrix Multiplication Function - B&OH Blocked Solution ---
    // transpose(&B);
    begin = clock();
    bijk(&result_6, &A, &B, A.cols, A.cols/2);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    printf("The B&OH Blocked Solution function took %.6Lf s\n", time_spent);
    if (cmp_matrix(&result, &result_6) == 1) {printf("Yay the matrix is correct!\n");}
    // transpose(&B); // Transpose B back
    // --------------------------------


    // --- 7th Matrix Multiplication Function - Blocked AVX ---
    transpose(&B);
    begin = clock();
    blocked_avx(&result_7, &A, &B, A.cols, A.cols/2);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    printf("The Blocked AVX function took %.6Lf s\n", time_spent);
    if (cmp_matrix(&result, &result_7) == 1) {printf("Yay the matrix is correct!\n");}
    transpose(&B); // Transpose B back
    // --------------------------------

        // --- 8th Matrix Multiplication Function - Unrolled Blocked AVX ---
    transpose(&B);
    begin = clock();
    unroll_blocked_avx(&result_8, &A, &B, A.cols, A.cols/2);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    printf("The Unrolled Blocked AVX function took %.6Lf s\n", time_spent);
    if (cmp_matrix(&result, &result_8) == 1) {printf("Yay the matrix is correct!\n");}
    transpose(&B); // Transpose B back
    // --------------------------------
    

    return 0;
}