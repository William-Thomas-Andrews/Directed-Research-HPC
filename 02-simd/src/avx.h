#include "Matrix.h"

#include <stdalign.h>
#include <immintrin.h>

#ifndef _AVX_H_
#define _AVX_H_

#define DEFINE_PRE_AVX(Type) \
__attribute__((always_inline)) inline void PRE_AVX(Type __restrict result, const Type __restrict A, const Type __restrict B) { \
    __m512 vec_1, vec_2, vec_3, acc; \
    float sum; \
    int A_cols = A->cols; int B_cols = B->cols; int A_rows = A->rows; int B_rows = B->rows; \
    for (int i = 0; i < A_rows; i++) { \
        for (int j = 0; j < B_rows; j++) { \
            acc = _mm512_setzero_ps(); \
            for (int k = 0; k < A_cols; k+=16) acc = _mm512_fmadd_ps(_mm512_loadu_ps(&A->data_array[i * A_cols + k]), _mm512_loadu_ps(&B->data_array[j * A_cols + k]), acc); \
            result->data_array[i * B_rows + j] = _mm512_reduce_add_ps(acc); \
        } \
    } \
}

static __attribute__((always_inline)) inline void avx_matrix_multiply(struct Matrix* result, struct Matrix* A, struct Matrix* B)
{
    __m512 vec_1, vec_2, vec_3, acc;
    float sum;
    int A_cols = A->cols; int B_cols = B->cols; int A_rows = A->rows; int B_rows = B->rows;
    for (int i = 0; i < A_rows; i++) {
        for (int j = 0; j < B_rows; j++) {
            acc = _mm512_setzero_ps();
            for (int k = 0; k < A_cols; k+=16) {
                vec_1 = _mm512_loadu_ps(&A->data_array[i * A_cols + k]);
                vec_2 = _mm512_loadu_ps(&B->data_array[j * A_cols + k]); // Transpose saves the day here!
                acc = _mm512_fmadd_ps(vec_1, vec_2, acc);
            }
            result->data_array[i * B_rows + j] = _mm512_reduce_add_ps(acc);
        }
    }
}

static __attribute__((always_inline)) inline void restricted_avx_matrix_multiply(struct Matrix* __restrict result, struct Matrix* __restrict A, struct Matrix* __restrict B)
{
    __m512 vec_1, vec_2, vec_3, acc;
    float sum;
    int A_cols = A->cols; int B_cols = B->cols; int A_rows = A->rows; int B_rows = B->rows;
    for (int i = 0; i < A_rows; i++) {
        for (int j = 0; j < B_rows; j++) {
            acc = _mm512_setzero_ps();
            for (int k = 0; k < A_cols; k+=16) {
                vec_1 = _mm512_loadu_ps(&A->data_array[i * A_cols + k]);
                vec_2 = _mm512_loadu_ps(&B->data_array[j * A_cols + k]);
                acc = _mm512_fmadd_ps(vec_1, vec_2, acc);
            }
            result->data_array[i * B_rows + j] = _mm512_reduce_add_ps(acc);
        }
    }
}

// Blocked Intrinsic
static __attribute__((always_inline)) inline void blocked_avx(struct Matrix* result, struct Matrix* A, struct Matrix* B, int n, int bsize)
{
    __m512 vec_1, vec_2, vec_3, acc;
    int A_cols = A->cols;
    int B_cols = B->cols;
    int i, j, k, kk, jj;
    float sum;
    int en = bsize * (n/bsize); /* Amount that fits evenly into blocks */
    for (kk = 0; kk < en; kk += bsize) {
        for (jj = 0; jj < en; jj += bsize) {
            for (i = 0; i < n; i++) {
                for (j = jj; j < jj + bsize; j++) {
                    sum = result->data_array[i*result->cols + j];
                    acc = _mm512_setzero_ps();
                    for (k = kk; k < kk + bsize; k += 16) {
                        vec_1 = _mm512_loadu_ps(&A->data_array[i * A_cols + k]);
                        vec_2 = _mm512_loadu_ps(&B->data_array[j * B_cols + k]);
                        acc = _mm512_fmadd_ps(vec_1, vec_2, acc);
                    }
                    result->data_array[i*result->cols + j] = _mm512_reduce_add_ps(acc) + sum;
                }
            }
        }
    }
}

// Unrolled Blocked Intrinsic
static __attribute__((always_inline)) inline void unroll_blocked_avx(struct Matrix* result, struct Matrix* A, struct Matrix* B, int n, int bsize)
{
    __m512 vec_1, vec_2, vec_3, acc;
    int A_cols = A->cols;
    int B_cols = B->cols;
    int i, j, k, kk, jj;
    float sum;
    int en = bsize * (n/bsize); /* Amount that fits evenly into blocks */
    kk = 0;
    for (jj = 0; jj < en; jj += bsize) {
        for (i = 0; i < n; i++) {
            for (j = jj; j < jj + bsize; j++) {
                sum = result->data_array[i*result->cols + j];
                acc = _mm512_setzero_ps();
                #pragma unroll(512)
                for (k = kk; k < kk + bsize; k += 16) {
                    acc = _mm512_fmadd_ps(_mm512_loadu_ps(&A->data_array[i * A_cols + k]), _mm512_loadu_ps(&B->data_array[j * B_cols + k]), acc);
                }
                result->data_array[i*result->cols + j] = _mm512_reduce_add_ps(acc) + sum;
            }
        }
    }
    kk = bsize;
    for (jj = 0; jj < en; jj += bsize) {
        for (i = 0; i < n; i++) {
            for (j = jj; j < jj + bsize; j++) {
                sum = result->data_array[i*result->cols + j];
                acc = _mm512_setzero_ps();
                #pragma unroll(512)
                for (k = kk; k < kk + bsize; k += 16) {
                    acc = _mm512_fmadd_ps(_mm512_loadu_ps(&A->data_array[i * A_cols + k]), _mm512_loadu_ps(&B->data_array[j * B_cols + k]), acc);
                }
                result->data_array[i*result->cols + j] = _mm512_reduce_add_ps(acc) + sum;
            }
        }
    }
}

#endif /* _AVX_H_ */