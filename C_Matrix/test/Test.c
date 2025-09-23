#include <unistd.h>

#include "Matrix.h"

int run_tests() {

    int A_rows, A_cols, B_rows, B_cols;
    A_rows = 1000; A_cols = 1000; B_rows = 1000; B_cols = 1000;


    struct Matrix A;
    struct Matrix B;
    struct Matrix result;
    init_matrix_r(&A, A_rows, A_cols);
    init_matrix_r(&B, B_rows, B_cols);
    init_matrix(&result, A_rows, B_cols);
    // printf("Matrix A: \n");
    // print_matrix(&A);
    // printf("\nMatrix B: \n");
    // print_matrix(&B);

    clock_t begin, end;
    double time_spent;

    // --- 1st Matrix Multiplication Function ---
    begin = clock();
    matrix_multiply_1(&result, &A, &B);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    printf("Here is the Matrix Multiplication result:\n");
    // print_matrix(&result);
    printf("                          This function call took %.9f ms\n", time_spent);
    // --------------------------------


    // --- 2nd Matrix Multiplication Function ---
    struct Matrix result_2;
    init_matrix(&result_2, A_rows, B_cols);
    begin = clock();
    matrix_multiply_2(&result_2, &A, &B);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    // printf("2nd matrix multiplication result :\n");
    // print_matrix(&result_2);
    if (cmp_matrix(&result, &result_2) == 1) printf("MM1 and MM2 are the same! This function call took %.9f ms\n", time_spent);
    else printf("MM1 and MM2 are NOT the same!!!!!!!!!! :(\n");
    // --------------------------------


    // --- 3rd Matrix Multiplication Function ---
    struct Matrix result_3;
    init_matrix(&result_3, A_rows, B_cols);
    begin = clock();
    matrix_multiply_3(&result_3, &A, &B);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    // printf("3rd matrix multiplication result :\n");
    // print_matrix(&result_3);
    if (cmp_matrix(&result, &result_3) == 1) printf("MM1 and MM3 are the same! This function call took %.9f ms\n", time_spent);
    else printf("MM1 and MM3 are NOT the same!!!!!!!!!! :(\n");
    // --------------------------------


    // --- 4th Matrix Multiplication Function ---
    struct Matrix result_4;
    init_matrix(&result_4, A_rows, B_cols);
    begin = clock();
    matrix_multiply_4(&result_4, &A, &B);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    // printf("4th matrix multiplication result :\n");
    // print_matrix(&result_4);
    if (cmp_matrix(&result, &result_4) == 1) printf("MM1 and MM4 are the same! This function call took %.9f ms\n", time_spent);
    else printf("MM1 and MM4 are NOT the same!!!!!!!!!! :(\n");
    // --------------------------------


    // --- 5th Matrix Multiplication Function ---
    struct Matrix result_5;
    init_matrix(&result_5, A_rows, B_cols);
    begin = clock();
    matrix_multiply_5(&result_5, &A, &B);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    // printf("5th matrix multiplication result :\n");
    // print_matrix(&result_5);
    if (cmp_matrix(&result, &result_5) == 1) printf("MM1 and MM5 are the same! This function call took %.9f ms\n", time_spent);
    else printf("MM1 and MM5 are NOT the same!!!!!!!!!! :(\n");
    // --------------------------------


    // --- 6th Matrix Multiplication Function ---
    struct Matrix result_6;
    init_matrix(&result_6, A_rows, B_cols);
    begin = clock();
    matrix_multiply_6(&result_6, &A, &B);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    // printf("6th matrix multiplication result :\n");
    // print_matrix(&result_6);
    if (cmp_matrix(&result, &result_6) == 1) printf("MM1 and MM6 are the same! This function call took %.9f ms\n", time_spent);
    else printf("MM1 and MM6 are NOT the same!!!!!!!!!! :(\n");
    // --------------------------------

    // --- 7th Matrix Multiplication Function ---
    struct Matrix result_7;
    init_matrix(&result_7, A_rows, B_cols);
    begin = clock();
    matrix_multiply_7(&result_7, &A, &B);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    // printf("6th matrix multiplication result :\n");
    // print_matrix(&result_6);
    if (cmp_matrix(&result, &result_7) == 1) printf("MM1 and Block Implementation are the same! This function call took %.9f ms\n", time_spent);
    else printf("MM1 and MM6 are NOT the same!!!!!!!!!! :(\n");
    // --------------------------------

    printf("\n----------------------\n Tests complete! :) \n----------------------\n");

    return 0;
}