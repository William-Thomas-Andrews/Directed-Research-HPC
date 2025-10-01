

#include "Test.h"
#include "Matrix.h"


int run_tests() {

    int A_rows, A_cols, B_rows, B_cols;
    A_rows = 2048; A_cols = 2048; B_rows = 2048; B_cols = 2048;


    
    struct Matrix A;
    struct Matrix B;
    struct Matrix result;
    init_matrix_r(&A, A_rows, A_cols);
    sleep(3);
    init_matrix_r(&B, B_rows, B_cols);
    init_matrix(&result, A_rows, B_cols);
    // printf("Matrix A: \n");
    // print_matrix(&A);
    // printf("\nMatrix B: \n");
    // print_matrix(&B);

    clock_t begin, end;
    double time_spent;


    // --- Transpose test ---
    // struct Matrix T;
    // init_matrix_r(&T, 5, 3);
    // // init_matrix(&T_result, T.cols, T.rows);
    // print_matrix(&T);
    // begin = clock();
    // transpose(&T);
    // end = clock();
    // time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    // print_matrix(&T);
    // printf("Transpose time took: %.6f s\n", time_spent);
    // --------------------------------


    // --- 1st Matrix Multiplication Function ---
    begin = clock();
    matrix_multiply_1(&result, &A, &B);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    printf("Here is the Matrix Multiplication result:\n");
    // print_matrix(&result);
    printf("                          This function call took %.6f s\n", time_spent);
    // --------------------------------

    // --- 10th Matrix Multiplication Function - Inteligent Transposes ---
    struct Matrix result_10;
    init_matrix_r(&result_10, A_rows, B_cols);
    
    begin = clock();
    transpose(&B);
    matrix_multiply_with_transposed_B(&result_10, &A, &B);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    // printf("10th matrix multiplication result :\n");
    // print_matrix(&result_10);
    printf("MM10 took %.6f s\n", time_spent);
    if (cmp_matrix(&result, &result_10) == 1) printf("MM1 and transposed matrix multiply Solution are the same! This function call took %.6f s\n", time_spent);
    // print_matrix(&result_10);
    // printf("\n");
    // print_matrix(&result);
    // else printf("MM1 and transposed matrix multiply Solution are NOT the same!!!!!!!!!! :(\n");
    // ------------------------------------------

    transpose(&B);
    // --- 9th Matrix Multiplication Function ---
    struct Matrix result_9;
    init_matrix_r(&result_9, A_rows, B_cols);
    begin = clock();
    bijk(&result_9, &A, &B, A.cols, A.cols/2);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    // printf("6th matrix multiplication result :\n");
    // print_matrix(&result_6);
    printf("MM9 took %.6f s\n", time_spent);
    // if (cmp_matrix(&result, &result_9) == 1) printf("MM1 and B&OH Solution are the same! This function call took %.6f s\n", time_spent);
    // else printf("MM1 and B&OH Solution are NOT the same!!!!!!!!!! :(\n");

    // ------------------------------------------

    // --- 8th Matrix Multiplication Function ---
    struct Matrix result_8;
    init_matrix_r(&result_8, A_rows, B_cols);
    begin = clock();
    matrix_multiply_8(&result_8, &A, &B);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    // printf("6th matrix multiplication result :\n");
    // print_matrix(&result_6);
    printf("MM8 took %.6f s\n", time_spent);
    // if (cmp_matrix(&result, &result_8) == 1) printf("MM1 and MM8 (parallel blocked) Solution are the same! This function call took %.6f s\n", time_spent);
    // else printf("MM1 and MM8 (parallel blocked) Solution are NOT the same!!!!!!!!!! :(\n");

    // ------------------------------------------


    // --- 7th Matrix Multiplication Function ---
    struct Matrix result_7;
    init_matrix_r(&result_7, A_rows, B_cols);
    begin = clock();
    matrix_multiply_7(&result_7, &A, &B);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    // printf("6th matrix multiplication result :\n");
    // print_matrix(&result_6);
    printf("MM7 took %.6f s\n", time_spent);
    // if (cmp_matrix(&result, &result_7) == 1) printf("MM1 and Block Implementation are the same! This function call took %.6f s\n", time_spent);
    // else printf("MM1 and Block Implementation are NOT the same!!!!!!!!!! :(\n");
    // --------------------------------


    // --- 2nd Matrix Multiplication Function ---
    struct Matrix result_2;
    init_matrix_r(&result_2, A_rows, B_cols);
    begin = clock();
    matrix_multiply_2(&result_2, &A, &B);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    // printf("2nd matrix multiplication result :\n");
    // print_matrix(&result_2);
    printf("MM2 took %.6f s\n", time_spent);
    // if (cmp_matrix(&result, &result_2) == 1) printf("MM1 and MM2 are the same! This function call took %.6f s\n", time_spent);
    // else printf("MM1 and MM2 are NOT the same!!!!!!!!!! :(\n");
    // --------------------------------


    // --- 3rd Matrix Multiplication Function ---
    struct Matrix result_3;
    init_matrix_r(&result_3, A_rows, B_cols);
    begin = clock();
    matrix_multiply_3(&result_3, &A, &B);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    // printf("3rd matrix multiplication result :\n");
    // print_matrix(&result_3);
    printf("MM3 took %.6f s\n", time_spent);
    // if (cmp_matrix(&result, &result_3) == 1) printf("MM1 and MM3 are the same! This function call took %.6f s\n", time_spent);
    // else printf("MM1 and MM3 are NOT the same!!!!!!!!!! :(\n");
    // --------------------------------


    // --- 4th Matrix Multiplication Function ---
    struct Matrix result_4;
    init_matrix_r(&result_4, A_rows, B_cols);
    begin = clock();
    matrix_multiply_4(&result_4, &A, &B);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    // printf("4th matrix multiplication result :\n");
    // print_matrix(&result_4);
    printf("MM4 took %.6f s\n", time_spent);
    // if (cmp_matrix(&result, &result_4) == 1) printf("MM1 and MM4 are the same! This function call took %.6f s\n", time_spent);
    // else printf("MM1 and MM4 are NOT the same!!!!!!!!!! :(\n");
    // --------------------------------


    // --- 5th Matrix Multiplication Function ---
    struct Matrix result_5;
    init_matrix_r(&result_5, A_rows, B_cols);
    begin = clock();
    matrix_multiply_5(&result_5, &A, &B);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    // printf("5th matrix multiplication result :\n");
    // print_matrix(&result_5);
    printf("MM5 took %.6f s\n", time_spent);
    // if (cmp_matrix(&result, &result_5) == 1) printf("MM1 and MM5 are the same! This function call took %.6f s\n", time_spent);
    // else printf("MM1 and MM5 are NOT the same!!!!!!!!!! :(\n");
    // --------------------------------


    // --- 6th Matrix Multiplication Function ---
    struct Matrix result_6;
    init_matrix_r(&result_6, A_rows, B_cols);
    begin = clock();
    matrix_multiply_6(&result_6, &A, &B);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    // printf("6th matrix multiplication result :\n");
    // print_matrix(&result_6);
    printf("MM6 took %.6f s\n", time_spent);
    // if (cmp_matrix(&result, &result_6) == 1) printf("MM1 and MM6 are the same! This function call took %.6f s\n", time_spent);
    // else printf("MM1 and MM6 are NOT the same!!!!!!!!!! :(\n");
    // --------------------------------



    printf("\n----------------------\n Tests complete! :) \n----------------------\n");

    return 0;
}