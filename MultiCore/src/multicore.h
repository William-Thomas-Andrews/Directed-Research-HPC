#include "avx.h"
#include <omp.h>



#ifndef _MC_H_
#define _MC_H_


static inline void par_multiply_1(struct Matrix *result, struct Matrix *A, struct Matrix *B) {
    int A_cols = A->cols; int B_cols = B->cols; int A_rows = A->rows; int B_rows = B->rows;
    if (A->cols != B->rows)      { fprintf(stderr, "Matrix 1 colums do not match Matrix 2 rows.\n");           exit(1); }
    if (result->rows != A_rows)  { fprintf(stderr, "Result matrix rows do not match Matrix 1 rows.\n");        exit(1); }
    if (result->cols != B_cols)  { fprintf(stderr, "Result matrix columns do not match Matrix 2 columns.\n");  exit(1); }
    double sum;
    #pragma omp parallel for schedule(static)
    for (int i = 0; i < A_rows; i++) {
        for (int j = 0; j < B_cols; j++) {
            sum = 0.0;
            for (int k = 0; k < B_rows; k++) {
                // result->data_array[i * B_cols + j] += A->data_array[i * A_cols + k] * B->data_array[k * B_cols + j]; // Disabled because using the 'sum' container is significantly more cache efficient
                sum += A->data_array[i * A_cols + k] * B->data_array[k * B_cols + j];
            }
            result->data_array[i * B_cols + j] = sum;
        }
    }
}


// Unrolled Blocked Intrinsic
static inline void par_unroll_blocked_avx(struct Matrix* result, struct Matrix* A, struct Matrix* B, int n, int bsize)
{
    int A_cols = A->cols;
    int B_cols = B->cols;
    int i, j, k, kk, jj;
    int en = bsize * (n/bsize); /* Amount that fits evenly into blocks */
    kk = 0;
    printf("%d\n",kk+bsize);

    // #pragma omp parallel for collapse(2) schedule(static)
    // for (int i =0; i < 1; i++) {
    //     for(int j = 0; j < 1; j++) ;
    // }

    #pragma omp parallel for collapse(2) schedule(static)
    for (jj = 0; jj < n; jj += bsize) {
        for (i = 0; i < n; i++) {
            for (kk = 0; kk < n; kk += bsize) {
                for (j = jj; j < jj + bsize; j++) {
                    __m512d acc = _mm512_setzero_pd();
                    for (k = kk; k < kk + bsize; k += 8) {
                        __m512d a = _mm512_loadu_pd(&A->data_array[i * A_cols + k]);
                        __m512d b = _mm512_loadu_pd(&B->data_array[j * B_cols + k]); // B transposed!
                        acc = _mm512_fmadd_pd(a, b, acc);
                    }
                    result->data_array[i * result->cols + j] += _mm512_reduce_add_pd(acc);
                }
            }
        }
    }

    // #pragma omp parallel for collapse(2) schedule(static)
    // for (jj = 0; jj < en; jj += bsize) {
    //     for (i = 0; i < n; i++) {
    //         for (j = jj; j < jj + bsize; j++) {
    //             sum = result->data_array[i*result->cols + j];
    //             acc = _mm512_setzero_pd();
    //             #pragma unroll(512)
    //             for (k = kk; k < kk + bsize; k += 8) {
    //                 acc = _mm512_fmadd_pd(_mm512_loadu_pd(&A->data_array[i * A_cols + k]), _mm512_loadu_pd(&B->data_array[j * B_cols + k]), acc);
    //             }
    //             result->data_array[i*result->cols + j] = _mm512_reduce_add_pd(acc) + sum;
    //         }
    //     }
    // }
    // kk = bsize;
    // #pragma omp parallel for collapse(2) schedule(static)
    // for (jj = 0; jj < en; jj += bsize) {
    //     for (i = 0; i < n; i++) {
    //         for (j = jj; j < jj + bsize; j++) {
    //             sum = result->data_array[i*result->cols + j];
    //             acc = _mm512_setzero_pd();
    //             #pragma unroll(512)
    //             for (k = kk; k < kk + bsize; k += 8) {
    //                 acc = _mm512_fmadd_pd(_mm512_loadu_pd(&A->data_array[i * A_cols + k]), _mm512_loadu_pd(&B->data_array[j * B_cols + k]), acc);
    //             }
    //             result->data_array[i*result->cols + j] = _mm512_reduce_add_pd(acc) + sum;
    //         }
    //     }
    // }
}


#endif /* _MC_H_ */