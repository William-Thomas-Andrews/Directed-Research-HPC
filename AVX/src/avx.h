#include "Matrix.h"

#include <stdalign.h>
#include <immintrin.h>

#ifndef _AVX_H_
#define _AVX_H_

#define DEFINE_PRE_AVX(Type) \
__attribute__((always_inline)) inline void PRE_AVX(Type __restrict result, const Type __restrict A, const Type __restrict B) { \
    __m512d vec_1, vec_2, vec_3, acc; \
    double sum; \
    int A_cols = A->cols; int B_cols = B->cols; int A_rows = A->rows; int B_rows = B->rows; \
    for (int i = 0; i < A_rows; i++) { \
        for (int j = 0; j < B_rows; j++) { \
            acc = _mm512_setzero_pd(); \
            for (int k = 0; k < A_cols; k+=8) acc = _mm512_fmadd_pd(_mm512_loadu_pd(&A->data_array[i * A_cols + k]), _mm512_loadu_pd(&B->data_array[j * A_cols + k]), acc); \
            result->data_array[i * B_rows + j] = _mm512_reduce_add_pd(acc); \
        } \
    } \
}

static __attribute__((always_inline)) inline void avx_matrix_multiply(struct Matrix* result, struct Matrix* A, struct Matrix* B) {
   
    // if (A->cols != B->rows)         { fprintf(stderr, "Matrix 1 colums do not match Matrix 2 rows.\n");           exit(1); }
    // if (result->rows != A->rows)  { fprintf(stderr, "Result matrix rows do not match Matrix 1 rows.\n");        exit(1); }
    // if (result->cols != B->cols)  { fprintf(stderr, "Result matrix columns do not match Matrix 2 columns.\n");  exit(1); }
    __m512d vec_1, vec_2, vec_3, acc;
    double sum;
    
    // transpose(B); // For cache-friendly operations
    int A_cols = A->cols; int B_cols = B->cols; int A_rows = A->rows; int B_rows = B->rows;
    
    for (int i = 0; i < A_rows; i++) {
        for (int j = 0; j < B_rows; j++) {
            // sum = 0.0;
            acc = _mm512_setzero_pd();
            for (int k = 0; k < A_cols; k+=8) {
                // vec_1 = _mm512_loadu_pd(&A->data_array[i * A_cols + k]);
                // vec_2 = _mm512_loadu_pd(&B->data_array[j * A_cols + k]); // Transpose saves the day here!
                // vec_3 = _mm512_mul_pd(vec_1, vec_2);
                // sum += _mm512_reduce_add_pd(vec_3);
                // sum += _mm512_reduce_add_pd(_mm512_mul_pd(_mm512_loadu_pd(&A->data_array[i * A_cols + k]), _mm512_loadu_pd(&B->data_array[j * A_cols + k]))); // Instructions above combined
                // acc = _mm512_fmadd_pd(vec_1, vec_2, acc);
                acc = _mm512_fmadd_pd(_mm512_loadu_pd(&A->data_array[i * A_cols + k]), _mm512_loadu_pd(&B->data_array[j * A_cols + k]), acc);
            }
            // result->data_array[i * B_rows + j] = sum;
            result->data_array[i * B_rows + j] = _mm512_reduce_add_pd(acc);
        }
    }
}

static __attribute__((always_inline)) inline void restricted_avx_matrix_multiply(struct Matrix* __restrict result, struct Matrix* __restrict A, struct Matrix* __restrict B) {
   
    // if (A->cols != B->rows)         { fprintf(stderr, "Matrix 1 colums do not match Matrix 2 rows.\n");           exit(1); }
    // if (result->rows != A->rows)  { fprintf(stderr, "Result matrix rows do not match Matrix 1 rows.\n");        exit(1); }
    // if (result->cols != B->cols)  { fprintf(stderr, "Result matrix columns do not match Matrix 2 columns.\n");  exit(1); }
    __m512d vec_1, vec_2, vec_3, acc;
    double sum;
    
    // transpose(B); // For cache-friendly operations
    int A_cols = A->cols; int B_cols = B->cols; int A_rows = A->rows; int B_rows = B->rows;
    
    for (int i = 0; i < A_rows; i++) {
        for (int j = 0; j < B_rows; j++) {
            // sum = 0.0;
            acc = _mm512_setzero_pd();
            for (int k = 0; k < A_cols; k+=8) {
                // vec_1 = _mm512_loadu_pd(&A->data_array[i * A_cols + k]);
                // vec_2 = _mm512_loadu_pd(&B->data_array[j * A_cols + k]); 
                // vec_3 = _mm512_mul_pd(vec_1, vec_2);
                // sum += _mm512_reduce_add_pd(vec_3);
                // sum += _mm512_reduce_add_pd(_mm512_mul_pd(_mm512_loadu_pd(&A->data_array[i * A_cols + k]), _mm512_loadu_pd(&B->data_array[j * A_cols + k]))); // Instructions above combined
                // acc = _mm512_fmadd_pd(vec_1, vec_2, acc);
                acc = _mm512_fmadd_pd(_mm512_loadu_pd(&A->data_array[i * A_cols + k]), _mm512_loadu_pd(&B->data_array[j * A_cols + k]), acc);
            }
            // result->data_array[i * B_rows + j] = sum;
            result->data_array[i * B_rows + j] = _mm512_reduce_add_pd(acc);
        }
    }
}

// Blocked Intrinsic
void blocked_avx(struct Matrix* result, struct Matrix* A, struct Matrix* B, int n, int bsize)
{
    __m512d vec_1, vec_2, vec_3, acc;
    int A_cols = A->cols;
    int B_cols = B->cols;
    int i, j, k, kk, jj;
    double sum;
    int en = bsize * (n/bsize); /* Amount that fits evenly into blocks */
    // for (i = 0; i < n; i++)
    //     for (j = 0; j < n; j++)
    //         result->data_array[i * result->cols + j] = 0.0;
    for (kk = 0; kk < en; kk += bsize) {
        printf("%d\n",kk+bsize);
        for (jj = 0; jj < en; jj += bsize) {
            for (i = 0; i < n; i++) {
                for (j = jj; j < jj + bsize; j++) {
                    sum = result->data_array[i*result->cols + j];
                    acc = _mm512_setzero_pd();
                    for (k = kk; k < kk + bsize; k += 8) {
                        // vec_1 = _mm512_loadu_pd(&A->data_array[i * A_cols + k]);
                        // vec_2 = _mm512_loadu_pd(&B->data_array[j * B_cols + k]);
                        // vec_3 = _mm512_mul_pd(vec_1, vec_2);
                        // sum += _mm512_reduce_add_pd(vec_3);
                        // sum += A->data_array[i*A->cols + k] * B->data_array[k*B->cols + j];
                        // acc = _mm512_fmadd_pd(vec_1, vec_2, acc);
                        acc = _mm512_fmadd_pd(_mm512_loadu_pd(&A->data_array[i * A_cols + k]), _mm512_loadu_pd(&B->data_array[j * B_cols + k]), acc);
                    }
                    result->data_array[i*result->cols + j] = _mm512_reduce_add_pd(acc) + sum;
                }
            }
        }
    }
}

#endif /* _AVX_H_ */