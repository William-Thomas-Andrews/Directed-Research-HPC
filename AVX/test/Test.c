#include "Test.h"
#include "avx.h"

#include <immintrin.h>
#include <stdio.h>
#include <unistd.h>


int run_tests() {

    clock_t begin, end;
    long double time_spent;

    int A_rows, A_cols, B_rows, B_cols;
    A_rows = 2048; A_cols = 2048; B_rows = 2048; B_cols = 2048;

    struct Matrix A; init_matrix_r(&A, A_rows, A_cols); sleep(2);
    struct Matrix B; init_matrix_r(&B, B_rows, B_cols);
    struct Matrix result; init_matrix(&result, A_rows, B_cols);
    struct Matrix result_2; init_matrix(&result_2, A_rows, B_cols);
    struct Matrix result_3; init_matrix(&result_3, A_rows, B_cols);


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
    begin = clock();
    avx_matrix_multiply(&result_2, &A, &B);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    // printf("Here is the avx512 result:\n");
    // print_matrix(&result);
    printf("The avx512 instrinsics took %.6Lf s\n", time_spent);
    if (cmp_matrix(&result, &result_2) == 1) {printf("Yay the matrix is correct!\n");}
    transpose(&B); // Transpose B back
    // --------------------------------
    
    
    // --- 3rd Matrix Multiplication Function - cache-friendly-transposition ---
    begin = clock();
    transpose(&B); // Includes the transpose to be fair with the avx function
    matrix_multiply_with_transposed_B(&result_3, &A, &B);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    // printf("Here is the cache-friendly-transposition result:\n");
    // print_matrix(&result);
    printf("The cache-friendly transposition function took %.6Lf s\n", time_spent);
    if (cmp_matrix(&result, &result_3) == 1) {printf("Yay the matrix is correct!\n");}
    transpose(&B); // Transpose B back
    // --------------------------------
    

    return 0;
}