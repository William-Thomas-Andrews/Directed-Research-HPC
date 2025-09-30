#include "Matrix.h"
#include <immintrin.h>

#ifndef _AVX_H_
#define _AVX_H_

static inline void avx_matrix_multiply(struct Matrix* result, struct Matrix* A, struct Matrix* B) {
    int A_cols = A->cols; int B_cols = B->cols; int A_rows = A->rows; int B_rows = B->rows;
    if (A->cols != B->rows)      { fprintf(stderr, "Matrix 1 colums do not match Matrix 2 rows.\n");           exit(1); }
    if (result->rows != A_rows)  { fprintf(stderr, "Result matrix rows do not match Matrix 1 rows.\n");        exit(1); }
    if (result->cols != B_cols)  { fprintf(stderr, "Result matrix columns do not match Matrix 2 columns.\n");  exit(1); }
    __m512 vec_1;
    __m512 vec_2;
    __m512 vec_3;
    double sum;
    for (int i = 0; i < A_rows; i++) {
        for (int j = 0; j < B_cols; j++) {
            sum = 0.0;
            
            for (int k = 0; k < B_rows; k += 16) {
                vec_2 = _mm512_load_ps(&A->data_array[i * A_cols + k]);
                vec_2 = _mm512_load_ps(&A->data_array[i * A_cols + k]); // Transpose will save the day here!
                sum += A->data_array[i * A_cols + k] * B->data_array[k * B_cols + j];
            }
            result->data_array[i * B_cols + j] = sum;
        }
    }
}

#endif /* _AVX_H_ */