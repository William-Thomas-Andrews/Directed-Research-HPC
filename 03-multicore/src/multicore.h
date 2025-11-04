#include "avx.h"
#include <omp.h>



#ifndef _MC_H_
#define _MC_H_


static inline void par_multiply_1(struct Matrix *result, struct Matrix *A, struct Matrix *B) {
    int A_cols = A->cols; int B_cols = B->cols; int A_rows = A->rows; int B_rows = B->rows;
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
}

static inline void par_multiply_2(struct Matrix* result, struct Matrix* A, struct Matrix* B) 
{
    int A_cols = A->cols; int B_cols = B->cols; int res_cols = result->cols; int A_rows = A->rows; int B_rows = B->rows; int res_rows = result->rows;
    #pragma omp parallel for collapse(2)
    for (size_t i = 0; i < res_rows; i++) {
        for (size_t j = 0; j < res_cols; j++) {
            double sum = 0.0;
            #pragma omp simd reduction(+:sum)
            for (size_t k = 0; k < A_cols; k++) {
                sum += A->data_array[i*A_cols + k] * B->data_array[k*B_cols + j];
            }
            result->data_array[i*res_cols + j] = sum;
        }
    }
}


static inline void par_multiply_3(struct Matrix* result, struct Matrix* A, struct Matrix* B) 
{
    const int BLOCK = 64;
    int k, A_cols = A->cols, B_rows = B->rows, A_rows = A->rows;
    #pragma omp parallel for schedule(static)
    for (int ii = 0; ii < A_rows; ii += BLOCK) {
        for (int jj = 0; jj < B_rows; jj += BLOCK) {
            int i_end = (ii+BLOCK < A_rows) ? ii+BLOCK : A_rows;
            int j_end = (jj+BLOCK < B_rows) ? jj+BLOCK : B_rows;
            for (int i = ii; i < i_end; i++) {
                for (int j = jj; j < j_end; j++) {
                    __m512d sum_vec = _mm512_setzero_pd();
                    // Process 8 elements at a time with AVX-512
                    for (k = 0; k <= A_cols - 8; k += 8) {
                        __m512d a = _mm512_loadu_pd(&A->data_array[i*A_cols + k]);
                        __m512d b = _mm512_loadu_pd(&B->data_array[j*A_cols + k]);
                        sum_vec = _mm512_fmadd_pd(a, b, sum_vec);
                    }
                    double sum = _mm512_reduce_add_pd(sum_vec);
                    // Handle remainder
                    for (; k < A_cols; k++) {
                        sum += A->data_array[i*A_cols + k] * B->data_array[j*A_cols + k];
                    }
                    result->data_array[i*B_rows + j] = sum;
                }
            }
        }
    }
}


// Fastest
// Optimizations:
// 3-level cache blocking: MC/KC/NC tuned for L1/L2/L3
// 8x8 micro-kernel: Maximum register utilization
// Unrolled by 4x: Process 32 elements per loop (4×8 AVX-512 vectors)
// 8 separate accumulators: Maximizes ILP and throughput
// B transposed: Sequential memory access pattern
// FMA instructions: 2 flops per cycle per FMA unit
static inline void par_multiply_4(struct Matrix* result, struct Matrix* A, struct Matrix* B_transposed) {
    // B must be transposed before calling!
    int n = A->rows;
    int m = A->cols;
    int p = B_transposed->rows;
    
    // Multi-level blocking optimized for cache hierarchy
    const int MC = 256;  // Rows of A in L3 cache (can be tuned for CPU)
    const int KC = 256;  // Cols of A / Rows of B in L2 cache
    const int NC = 4096; // Cols of B in L2 cache
    const int MR = 8;    // Micro-kernel rows (register blocking)
    const int NR = 8;    // Micro-kernel cols (register blocking)
    
    #pragma omp parallel for schedule(static) collapse(2)
    for (int jc = 0; jc < p; jc += NC) {
        for (int ic = 0; ic < n; ic += MC) {
            int j_end = (jc + NC < p) ? jc + NC : p;
            int i_end = (ic + MC < n) ? ic + MC : n;
            
            for (int kc = 0; kc < m; kc += KC) {
                int k_end = (kc + KC < m) ? kc + KC : m;
                
                // Panel-panel multiply with micro-kernels
                for (int jr = jc; jr < j_end; jr += NR) {
                    for (int ir = ic; ir < i_end; ir += MR) {
                        // Micro-kernel: 8x8 block using AVX-512
                        int j_block = (jr + NR < j_end) ? jr + NR : j_end;
                        int i_block = (ir + MR < i_end) ? ir + MR : i_end;
                        
                        for (int i = ir; i < i_block; i++) {
                            // Process 8 columns at once with 8 separate accumulators
                            __m512d sum0 = _mm512_setzero_pd();
                            __m512d sum1 = _mm512_setzero_pd();
                            __m512d sum2 = _mm512_setzero_pd();
                            __m512d sum3 = _mm512_setzero_pd();
                            __m512d sum4 = _mm512_setzero_pd();
                            __m512d sum5 = _mm512_setzero_pd();
                            __m512d sum6 = _mm512_setzero_pd();
                            __m512d sum7 = _mm512_setzero_pd();
                            
                            int k = kc;
                            // Unroll by 4 for better ILP (instruction-level parallelism)
                            for (; k <= k_end - 32; k += 32) {
                                // Load A rows
                                __m512d a0 = _mm512_loadu_pd(&A->data_array[i*m + k]);
                                __m512d a1 = _mm512_loadu_pd(&A->data_array[i*m + k + 8]);
                                __m512d a2 = _mm512_loadu_pd(&A->data_array[i*m + k + 16]);
                                __m512d a3 = _mm512_loadu_pd(&A->data_array[i*m + k + 24]);
                                
                                if (jr + 0 < j_block) {
                                    __m512d b0 = _mm512_loadu_pd(&B_transposed->data_array[(jr+0)*m + k]);
                                    __m512d b1 = _mm512_loadu_pd(&B_transposed->data_array[(jr+0)*m + k + 8]);
                                    __m512d b2 = _mm512_loadu_pd(&B_transposed->data_array[(jr+0)*m + k + 16]);
                                    __m512d b3 = _mm512_loadu_pd(&B_transposed->data_array[(jr+0)*m + k + 24]);
                                    sum0 = _mm512_fmadd_pd(a0, b0, sum0);
                                    sum0 = _mm512_fmadd_pd(a1, b1, sum0);
                                    sum0 = _mm512_fmadd_pd(a2, b2, sum0);
                                    sum0 = _mm512_fmadd_pd(a3, b3, sum0);
                                }
                                if (jr + 1 < j_block) {
                                    __m512d b0 = _mm512_loadu_pd(&B_transposed->data_array[(jr+1)*m + k]);
                                    __m512d b1 = _mm512_loadu_pd(&B_transposed->data_array[(jr+1)*m + k + 8]);
                                    __m512d b2 = _mm512_loadu_pd(&B_transposed->data_array[(jr+1)*m + k + 16]);
                                    __m512d b3 = _mm512_loadu_pd(&B_transposed->data_array[(jr+1)*m + k + 24]);
                                    sum1 = _mm512_fmadd_pd(a0, b0, sum1);
                                    sum1 = _mm512_fmadd_pd(a1, b1, sum1);
                                    sum1 = _mm512_fmadd_pd(a2, b2, sum1);
                                    sum1 = _mm512_fmadd_pd(a3, b3, sum1);
                                }
                                if (jr + 2 < j_block) {
                                    __m512d b0 = _mm512_loadu_pd(&B_transposed->data_array[(jr+2)*m + k]);
                                    __m512d b1 = _mm512_loadu_pd(&B_transposed->data_array[(jr+2)*m + k + 8]);
                                    __m512d b2 = _mm512_loadu_pd(&B_transposed->data_array[(jr+2)*m + k + 16]);
                                    __m512d b3 = _mm512_loadu_pd(&B_transposed->data_array[(jr+2)*m + k + 24]);
                                    sum2 = _mm512_fmadd_pd(a0, b0, sum2);
                                    sum2 = _mm512_fmadd_pd(a1, b1, sum2);
                                    sum2 = _mm512_fmadd_pd(a2, b2, sum2);
                                    sum2 = _mm512_fmadd_pd(a3, b3, sum2);
                                }
                                if (jr + 3 < j_block) {
                                    __m512d b0 = _mm512_loadu_pd(&B_transposed->data_array[(jr+3)*m + k]);
                                    __m512d b1 = _mm512_loadu_pd(&B_transposed->data_array[(jr+3)*m + k + 8]);
                                    __m512d b2 = _mm512_loadu_pd(&B_transposed->data_array[(jr+3)*m + k + 16]);
                                    __m512d b3 = _mm512_loadu_pd(&B_transposed->data_array[(jr+3)*m + k + 24]);
                                    sum3 = _mm512_fmadd_pd(a0, b0, sum3);
                                    sum3 = _mm512_fmadd_pd(a1, b1, sum3);
                                    sum3 = _mm512_fmadd_pd(a2, b2, sum3);
                                    sum3 = _mm512_fmadd_pd(a3, b3, sum3);
                                }
                                if (jr + 4 < j_block) {
                                    __m512d b0 = _mm512_loadu_pd(&B_transposed->data_array[(jr+4)*m + k]);
                                    __m512d b1 = _mm512_loadu_pd(&B_transposed->data_array[(jr+4)*m + k + 8]);
                                    __m512d b2 = _mm512_loadu_pd(&B_transposed->data_array[(jr+4)*m + k + 16]);
                                    __m512d b3 = _mm512_loadu_pd(&B_transposed->data_array[(jr+4)*m + k + 24]);
                                    sum4 = _mm512_fmadd_pd(a0, b0, sum4);
                                    sum4 = _mm512_fmadd_pd(a1, b1, sum4);
                                    sum4 = _mm512_fmadd_pd(a2, b2, sum4);
                                    sum4 = _mm512_fmadd_pd(a3, b3, sum4);
                                }
                                if (jr + 5 < j_block) {
                                    __m512d b0 = _mm512_loadu_pd(&B_transposed->data_array[(jr+5)*m + k]);
                                    __m512d b1 = _mm512_loadu_pd(&B_transposed->data_array[(jr+5)*m + k + 8]);
                                    __m512d b2 = _mm512_loadu_pd(&B_transposed->data_array[(jr+5)*m + k + 16]);
                                    __m512d b3 = _mm512_loadu_pd(&B_transposed->data_array[(jr+5)*m + k + 24]);
                                    sum5 = _mm512_fmadd_pd(a0, b0, sum5);
                                    sum5 = _mm512_fmadd_pd(a1, b1, sum5);
                                    sum5 = _mm512_fmadd_pd(a2, b2, sum5);
                                    sum5 = _mm512_fmadd_pd(a3, b3, sum5);
                                }
                                if (jr + 6 < j_block) {
                                    __m512d b0 = _mm512_loadu_pd(&B_transposed->data_array[(jr+6)*m + k]);
                                    __m512d b1 = _mm512_loadu_pd(&B_transposed->data_array[(jr+6)*m + k + 8]);
                                    __m512d b2 = _mm512_loadu_pd(&B_transposed->data_array[(jr+6)*m + k + 16]);
                                    __m512d b3 = _mm512_loadu_pd(&B_transposed->data_array[(jr+6)*m + k + 24]);
                                    sum6 = _mm512_fmadd_pd(a0, b0, sum6);
                                    sum6 = _mm512_fmadd_pd(a1, b1, sum6);
                                    sum6 = _mm512_fmadd_pd(a2, b2, sum6);
                                    sum6 = _mm512_fmadd_pd(a3, b3, sum6);
                                }
                                if (jr + 7 < j_block) {
                                    __m512d b0 = _mm512_loadu_pd(&B_transposed->data_array[(jr+7)*m + k]);
                                    __m512d b1 = _mm512_loadu_pd(&B_transposed->data_array[(jr+7)*m + k + 8]);
                                    __m512d b2 = _mm512_loadu_pd(&B_transposed->data_array[(jr+7)*m + k + 16]);
                                    __m512d b3 = _mm512_loadu_pd(&B_transposed->data_array[(jr+7)*m + k + 24]);
                                    sum7 = _mm512_fmadd_pd(a0, b0, sum7);
                                    sum7 = _mm512_fmadd_pd(a1, b1, sum7);
                                    sum7 = _mm512_fmadd_pd(a2, b2, sum7);
                                    sum7 = _mm512_fmadd_pd(a3, b3, sum7);
                                }
                            }
                            
                            // Handle remaining k elements with vectorization
                            for (; k <= k_end - 8; k += 8) {
                                __m512d a = _mm512_loadu_pd(&A->data_array[i*m + k]);
                                if (jr + 0 < j_block) {
                                    __m512d b = _mm512_loadu_pd(&B_transposed->data_array[(jr+0)*m + k]);
                                    sum0 = _mm512_fmadd_pd(a, b, sum0);
                                }
                                if (jr + 1 < j_block) {
                                    __m512d b = _mm512_loadu_pd(&B_transposed->data_array[(jr+1)*m + k]);
                                    sum1 = _mm512_fmadd_pd(a, b, sum1);
                                }
                                if (jr + 2 < j_block) {
                                    __m512d b = _mm512_loadu_pd(&B_transposed->data_array[(jr+2)*m + k]);
                                    sum2 = _mm512_fmadd_pd(a, b, sum2);
                                }
                                if (jr + 3 < j_block) {
                                    __m512d b = _mm512_loadu_pd(&B_transposed->data_array[(jr+3)*m + k]);
                                    sum3 = _mm512_fmadd_pd(a, b, sum3);
                                }
                                if (jr + 4 < j_block) {
                                    __m512d b = _mm512_loadu_pd(&B_transposed->data_array[(jr+4)*m + k]);
                                    sum4 = _mm512_fmadd_pd(a, b, sum4);
                                }
                                if (jr + 5 < j_block) {
                                    __m512d b = _mm512_loadu_pd(&B_transposed->data_array[(jr+5)*m + k]);
                                    sum5 = _mm512_fmadd_pd(a, b, sum5);
                                }
                                if (jr + 6 < j_block) {
                                    __m512d b = _mm512_loadu_pd(&B_transposed->data_array[(jr+6)*m + k]);
                                    sum6 = _mm512_fmadd_pd(a, b, sum6);
                                }
                                if (jr + 7 < j_block) {
                                    __m512d b = _mm512_loadu_pd(&B_transposed->data_array[(jr+7)*m + k]);
                                    sum7 = _mm512_fmadd_pd(a, b, sum7);
                                }
                            }
                            
                            // Scalar remainder
                            for (; k < k_end; k++) {
                                double a = A->data_array[i*m + k];
                                if (jr + 0 < j_block) result->data_array[i*p + jr + 0] += a * B_transposed->data_array[(jr+0)*m + k];
                                if (jr + 1 < j_block) result->data_array[i*p + jr + 1] += a * B_transposed->data_array[(jr+1)*m + k];
                                if (jr + 2 < j_block) result->data_array[i*p + jr + 2] += a * B_transposed->data_array[(jr+2)*m + k];
                                if (jr + 3 < j_block) result->data_array[i*p + jr + 3] += a * B_transposed->data_array[(jr+3)*m + k];
                                if (jr + 4 < j_block) result->data_array[i*p + jr + 4] += a * B_transposed->data_array[(jr+4)*m + k];
                                if (jr + 5 < j_block) result->data_array[i*p + jr + 5] += a * B_transposed->data_array[(jr+5)*m + k];
                                if (jr + 6 < j_block) result->data_array[i*p + jr + 6] += a * B_transposed->data_array[(jr+6)*m + k];
                                if (jr + 7 < j_block) result->data_array[i*p + jr + 7] += a * B_transposed->data_array[(jr+7)*m + k];
                            }
                            
                            // Store accumulated results
                            if (jr + 0 < j_block) result->data_array[i*p + jr + 0] += _mm512_reduce_add_pd(sum0);
                            if (jr + 1 < j_block) result->data_array[i*p + jr + 1] += _mm512_reduce_add_pd(sum1);
                            if (jr + 2 < j_block) result->data_array[i*p + jr + 2] += _mm512_reduce_add_pd(sum2);
                            if (jr + 3 < j_block) result->data_array[i*p + jr + 3] += _mm512_reduce_add_pd(sum3);
                            if (jr + 4 < j_block) result->data_array[i*p + jr + 4] += _mm512_reduce_add_pd(sum4);
                            if (jr + 5 < j_block) result->data_array[i*p + jr + 5] += _mm512_reduce_add_pd(sum5);
                            if (jr + 6 < j_block) result->data_array[i*p + jr + 6] += _mm512_reduce_add_pd(sum6);
                            if (jr + 7 < j_block) result->data_array[i*p + jr + 7] += _mm512_reduce_add_pd(sum7);
                        }
                    }
                }
            }
        }
    }
}

static inline void par_multiply_5(struct Matrix* restrict result, struct Matrix* restrict A, struct Matrix* restrict B_transposed) {
    int n = A->rows;
    int m = A->cols;
    int p = B_transposed->rows;
    
    // Optimized for your CPU cache hierarchy
    const int MC = 128;
    const int KC = 512;
    const int NC = 2048;
    const int MR = 8;
    const int NR = 8;
    
    #pragma omp parallel for schedule(guided) collapse(2)
    for (int jc = 0; jc < p; jc += NC) {
        for (int ic = 0; ic < n; ic += MC) {
            int j_end = (jc + NC < p) ? jc + NC : p;
            int i_end = (ic + MC < n) ? ic + MC : n;
            
            for (int kc = 0; kc < m; kc += KC) {
                int k_end = (kc + KC < m) ? kc + KC : m;
                
                for (int jr = jc; jr < j_end - NR + 1; jr += NR) {
                    for (int ir = ic; ir < i_end - MR + 1; ir += MR) {
                        // Full 8x8 micro-kernel (no branches)
                        for (int i = ir; i < ir + MR; i++) {
                            double* restrict a_ptr = &A->data_array[i*m];
                            double* restrict c_ptr = &result->data_array[i*p + jr];
                            
                            __m512d sum0 = _mm512_setzero_pd();
                            __m512d sum1 = _mm512_setzero_pd();
                            __m512d sum2 = _mm512_setzero_pd();
                            __m512d sum3 = _mm512_setzero_pd();
                            __m512d sum4 = _mm512_setzero_pd();
                            __m512d sum5 = _mm512_setzero_pd();
                            __m512d sum6 = _mm512_setzero_pd();
                            __m512d sum7 = _mm512_setzero_pd();
                            
                            double* restrict b0_ptr = &B_transposed->data_array[(jr+0)*m];
                            double* restrict b1_ptr = &B_transposed->data_array[(jr+1)*m];
                            double* restrict b2_ptr = &B_transposed->data_array[(jr+2)*m];
                            double* restrict b3_ptr = &B_transposed->data_array[(jr+3)*m];
                            double* restrict b4_ptr = &B_transposed->data_array[(jr+4)*m];
                            double* restrict b5_ptr = &B_transposed->data_array[(jr+5)*m];
                            double* restrict b6_ptr = &B_transposed->data_array[(jr+6)*m];
                            double* restrict b7_ptr = &B_transposed->data_array[(jr+7)*m];
                            
                            int k = kc;
                            // Unroll by 4 with prefetching
                            for (; k <= k_end - 32; k += 32) {
                                // Prefetch next iteration
                                _mm_prefetch((const char*)(a_ptr + k + 64), _MM_HINT_T0);
                                _mm_prefetch((const char*)(b0_ptr + k + 64), _MM_HINT_T0);
                                
                                __m512d a0 = _mm512_loadu_pd(a_ptr + k);
                                __m512d a1 = _mm512_loadu_pd(a_ptr + k + 8);
                                __m512d a2 = _mm512_loadu_pd(a_ptr + k + 16);
                                __m512d a3 = _mm512_loadu_pd(a_ptr + k + 24);
                                
                                __m512d b;
                                b = _mm512_loadu_pd(b0_ptr + k);
                                sum0 = _mm512_fmadd_pd(a0, b, sum0);
                                b = _mm512_loadu_pd(b0_ptr + k + 8);
                                sum0 = _mm512_fmadd_pd(a1, b, sum0);
                                b = _mm512_loadu_pd(b0_ptr + k + 16);
                                sum0 = _mm512_fmadd_pd(a2, b, sum0);
                                b = _mm512_loadu_pd(b0_ptr + k + 24);
                                sum0 = _mm512_fmadd_pd(a3, b, sum0);
                                
                                b = _mm512_loadu_pd(b1_ptr + k);
                                sum1 = _mm512_fmadd_pd(a0, b, sum1);
                                b = _mm512_loadu_pd(b1_ptr + k + 8);
                                sum1 = _mm512_fmadd_pd(a1, b, sum1);
                                b = _mm512_loadu_pd(b1_ptr + k + 16);
                                sum1 = _mm512_fmadd_pd(a2, b, sum1);
                                b = _mm512_loadu_pd(b1_ptr + k + 24);
                                sum1 = _mm512_fmadd_pd(a3, b, sum1);
                                
                                b = _mm512_loadu_pd(b2_ptr + k);
                                sum2 = _mm512_fmadd_pd(a0, b, sum2);
                                b = _mm512_loadu_pd(b2_ptr + k + 8);
                                sum2 = _mm512_fmadd_pd(a1, b, sum2);
                                b = _mm512_loadu_pd(b2_ptr + k + 16);
                                sum2 = _mm512_fmadd_pd(a2, b, sum2);
                                b = _mm512_loadu_pd(b2_ptr + k + 24);
                                sum2 = _mm512_fmadd_pd(a3, b, sum2);
                                
                                b = _mm512_loadu_pd(b3_ptr + k);
                                sum3 = _mm512_fmadd_pd(a0, b, sum3);
                                b = _mm512_loadu_pd(b3_ptr + k + 8);
                                sum3 = _mm512_fmadd_pd(a1, b, sum3);
                                b = _mm512_loadu_pd(b3_ptr + k + 16);
                                sum3 = _mm512_fmadd_pd(a2, b, sum3);
                                b = _mm512_loadu_pd(b3_ptr + k + 24);
                                sum3 = _mm512_fmadd_pd(a3, b, sum3);
                                
                                b = _mm512_loadu_pd(b4_ptr + k);
                                sum4 = _mm512_fmadd_pd(a0, b, sum4);
                                b = _mm512_loadu_pd(b4_ptr + k + 8);
                                sum4 = _mm512_fmadd_pd(a1, b, sum4);
                                b = _mm512_loadu_pd(b4_ptr + k + 16);
                                sum4 = _mm512_fmadd_pd(a2, b, sum4);
                                b = _mm512_loadu_pd(b4_ptr + k + 24);
                                sum4 = _mm512_fmadd_pd(a3, b, sum4);
                                
                                b = _mm512_loadu_pd(b5_ptr + k);
                                sum5 = _mm512_fmadd_pd(a0, b, sum5);
                                b = _mm512_loadu_pd(b5_ptr + k + 8);
                                sum5 = _mm512_fmadd_pd(a1, b, sum5);
                                b = _mm512_loadu_pd(b5_ptr + k + 16);
                                sum5 = _mm512_fmadd_pd(a2, b, sum5);
                                b = _mm512_loadu_pd(b5_ptr + k + 24);
                                sum5 = _mm512_fmadd_pd(a3, b, sum5);
                                
                                b = _mm512_loadu_pd(b6_ptr + k);
                                sum6 = _mm512_fmadd_pd(a0, b, sum6);
                                b = _mm512_loadu_pd(b6_ptr + k + 8);
                                sum6 = _mm512_fmadd_pd(a1, b, sum6);
                                b = _mm512_loadu_pd(b6_ptr + k + 16);
                                sum6 = _mm512_fmadd_pd(a2, b, sum6);
                                b = _mm512_loadu_pd(b6_ptr + k + 24);
                                sum6 = _mm512_fmadd_pd(a3, b, sum6);
                                
                                b = _mm512_loadu_pd(b7_ptr + k);
                                sum7 = _mm512_fmadd_pd(a0, b, sum7);
                                b = _mm512_loadu_pd(b7_ptr + k + 8);
                                sum7 = _mm512_fmadd_pd(a1, b, sum7);
                                b = _mm512_loadu_pd(b7_ptr + k + 16);
                                sum7 = _mm512_fmadd_pd(a2, b, sum7);
                                b = _mm512_loadu_pd(b7_ptr + k + 24);
                                sum7 = _mm512_fmadd_pd(a3, b, sum7);
                            }
                            
                            // Handle k remainder with vectorization
                            for (; k <= k_end - 8; k += 8) {
                                __m512d a = _mm512_loadu_pd(a_ptr + k);
                                sum0 = _mm512_fmadd_pd(a, _mm512_loadu_pd(b0_ptr + k), sum0);
                                sum1 = _mm512_fmadd_pd(a, _mm512_loadu_pd(b1_ptr + k), sum1);
                                sum2 = _mm512_fmadd_pd(a, _mm512_loadu_pd(b2_ptr + k), sum2);
                                sum3 = _mm512_fmadd_pd(a, _mm512_loadu_pd(b3_ptr + k), sum3);
                                sum4 = _mm512_fmadd_pd(a, _mm512_loadu_pd(b4_ptr + k), sum4);
                                sum5 = _mm512_fmadd_pd(a, _mm512_loadu_pd(b5_ptr + k), sum5);
                                sum6 = _mm512_fmadd_pd(a, _mm512_loadu_pd(b6_ptr + k), sum6);
                                sum7 = _mm512_fmadd_pd(a, _mm512_loadu_pd(b7_ptr + k), sum7);
                            }
                            
                            // Scalar remainder
                            for (; k < k_end; k++) {
                                double a = a_ptr[k];
                                c_ptr[0] += a * b0_ptr[k];
                                c_ptr[1] += a * b1_ptr[k];
                                c_ptr[2] += a * b2_ptr[k];
                                c_ptr[3] += a * b3_ptr[k];
                                c_ptr[4] += a * b4_ptr[k];
                                c_ptr[5] += a * b5_ptr[k];
                                c_ptr[6] += a * b6_ptr[k];
                                c_ptr[7] += a * b7_ptr[k];
                            }
                            
                            // Store results
                            c_ptr[0] += _mm512_reduce_add_pd(sum0);
                            c_ptr[1] += _mm512_reduce_add_pd(sum1);
                            c_ptr[2] += _mm512_reduce_add_pd(sum2);
                            c_ptr[3] += _mm512_reduce_add_pd(sum3);
                            c_ptr[4] += _mm512_reduce_add_pd(sum4);
                            c_ptr[5] += _mm512_reduce_add_pd(sum5);
                            c_ptr[6] += _mm512_reduce_add_pd(sum6);
                            c_ptr[7] += _mm512_reduce_add_pd(sum7);
                        }
                    }
                }
                
                // Handle remainder rows/cols with simpler loop
                for (int j = jc; j < j_end; j++) {
                    for (int i = ic; i < i_end; i++) {
                        if (j < jc || j >= ((j_end/NR)*NR) || i < ic || i >= ((i_end/MR)*MR)) {
                            double sum = 0.0;
                            for (int k = kc; k < k_end; k++) {
                                sum += A->data_array[i*m + k] * B_transposed->data_array[j*m + k];
                            }
                            result->data_array[i*p + j] += sum;
                        }
                    }
                }
            }
        }
    }
}

static inline void par_multiply_6(struct Matrix* restrict result, 
                                   struct Matrix* restrict A, 
                                   struct Matrix* restrict B_transposed) {
    int n = A->rows;
    int m = A->cols;
    int p = B_transposed->rows;
    
    // Optimized cache blocking for Xeon w3-2435
    const int MC = 192;   // 192 × 512 × 8 = 768KB < 2MB L2 per core
    const int KC = 512;   // Larger KC for better L2 utilization
    const int NC = 2048;  // 512 × 2048 × 8 = 8MB < 22.5MB L3
    const int MR = 8;     // Register blocking
    const int NR = 8;     // Register blocking
    
    #pragma omp parallel for schedule(guided, 4) collapse(2)
    for (int jc = 0; jc < p; jc += NC) {
        for (int ic = 0; ic < n; ic += MC) {
            int j_end = (jc + NC < p) ? jc + NC : p;
            int i_end = (ic + MC < n) ? ic + MC : n;
            
            for (int kc = 0; kc < m; kc += KC) {
                int k_end = (kc + KC < m) ? kc + KC : m;
                
                // Process full 8x8 blocks (no boundary checks in inner loop)
                int j_full_blocks = jc + ((j_end - jc) / NR) * NR;
                int i_full_blocks = ic + ((i_end - ic) / MR) * MR;
                
                for (int jr = jc; jr < j_full_blocks; jr += NR) {
                    for (int ir = ic; ir < i_full_blocks; ir += MR) {
                        // Micro-kernel: process 8x8 block
                        for (int i = ir; i < ir + MR; i++) {
                            double* restrict a_ptr = &A->data_array[i*m];
                            double* restrict c_ptr = &result->data_array[i*p + jr];
                            
                            // 8 separate accumulators for maximum ILP
                            __m512d sum0 = _mm512_setzero_pd();
                            __m512d sum1 = _mm512_setzero_pd();
                            __m512d sum2 = _mm512_setzero_pd();
                            __m512d sum3 = _mm512_setzero_pd();
                            __m512d sum4 = _mm512_setzero_pd();
                            __m512d sum5 = _mm512_setzero_pd();
                            __m512d sum6 = _mm512_setzero_pd();
                            __m512d sum7 = _mm512_setzero_pd();
                            
                            double* restrict b0_ptr = &B_transposed->data_array[(jr+0)*m];
                            double* restrict b1_ptr = &B_transposed->data_array[(jr+1)*m];
                            double* restrict b2_ptr = &B_transposed->data_array[(jr+2)*m];
                            double* restrict b3_ptr = &B_transposed->data_array[(jr+3)*m];
                            double* restrict b4_ptr = &B_transposed->data_array[(jr+4)*m];
                            double* restrict b5_ptr = &B_transposed->data_array[(jr+5)*m];
                            double* restrict b6_ptr = &B_transposed->data_array[(jr+6)*m];
                            double* restrict b7_ptr = &B_transposed->data_array[(jr+7)*m];
                            
                            int k = kc;
                            
                            // Main loop: unroll by 4 (process 32 elements = 4×8 AVX-512 vectors)
                            for (; k <= k_end - 32; k += 32) {
                                // Prefetch next iteration (64 doubles ahead = 512 bytes)
                                _mm_prefetch((const char*)(a_ptr + k + 64), _MM_HINT_T0);
                                _mm_prefetch((const char*)(b0_ptr + k + 64), _MM_HINT_T0);
                                _mm_prefetch((const char*)(b4_ptr + k + 64), _MM_HINT_T0);
                                
                                // Load A (reused 8 times)
                                __m512d a0 = _mm512_loadu_pd(a_ptr + k);
                                __m512d a1 = _mm512_loadu_pd(a_ptr + k + 8);
                                __m512d a2 = _mm512_loadu_pd(a_ptr + k + 16);
                                __m512d a3 = _mm512_loadu_pd(a_ptr + k + 24);
                                
                                // Compute with separate loads to maximize throughput
                                sum0 = _mm512_fmadd_pd(a0, _mm512_loadu_pd(b0_ptr + k), sum0);
                                sum1 = _mm512_fmadd_pd(a0, _mm512_loadu_pd(b1_ptr + k), sum1);
                                sum2 = _mm512_fmadd_pd(a0, _mm512_loadu_pd(b2_ptr + k), sum2);
                                sum3 = _mm512_fmadd_pd(a0, _mm512_loadu_pd(b3_ptr + k), sum3);
                                sum4 = _mm512_fmadd_pd(a0, _mm512_loadu_pd(b4_ptr + k), sum4);
                                sum5 = _mm512_fmadd_pd(a0, _mm512_loadu_pd(b5_ptr + k), sum5);
                                sum6 = _mm512_fmadd_pd(a0, _mm512_loadu_pd(b6_ptr + k), sum6);
                                sum7 = _mm512_fmadd_pd(a0, _mm512_loadu_pd(b7_ptr + k), sum7);
                                
                                sum0 = _mm512_fmadd_pd(a1, _mm512_loadu_pd(b0_ptr + k + 8), sum0);
                                sum1 = _mm512_fmadd_pd(a1, _mm512_loadu_pd(b1_ptr + k + 8), sum1);
                                sum2 = _mm512_fmadd_pd(a1, _mm512_loadu_pd(b2_ptr + k + 8), sum2);
                                sum3 = _mm512_fmadd_pd(a1, _mm512_loadu_pd(b3_ptr + k + 8), sum3);
                                sum4 = _mm512_fmadd_pd(a1, _mm512_loadu_pd(b4_ptr + k + 8), sum4);
                                sum5 = _mm512_fmadd_pd(a1, _mm512_loadu_pd(b5_ptr + k + 8), sum5);
                                sum6 = _mm512_fmadd_pd(a1, _mm512_loadu_pd(b6_ptr + k + 8), sum6);
                                sum7 = _mm512_fmadd_pd(a1, _mm512_loadu_pd(b7_ptr + k + 8), sum7);
                                
                                sum0 = _mm512_fmadd_pd(a2, _mm512_loadu_pd(b0_ptr + k + 16), sum0);
                                sum1 = _mm512_fmadd_pd(a2, _mm512_loadu_pd(b1_ptr + k + 16), sum1);
                                sum2 = _mm512_fmadd_pd(a2, _mm512_loadu_pd(b2_ptr + k + 16), sum2);
                                sum3 = _mm512_fmadd_pd(a2, _mm512_loadu_pd(b3_ptr + k + 16), sum3);
                                sum4 = _mm512_fmadd_pd(a2, _mm512_loadu_pd(b4_ptr + k + 16), sum4);
                                sum5 = _mm512_fmadd_pd(a2, _mm512_loadu_pd(b5_ptr + k + 16), sum5);
                                sum6 = _mm512_fmadd_pd(a2, _mm512_loadu_pd(b6_ptr + k + 16), sum6);
                                sum7 = _mm512_fmadd_pd(a2, _mm512_loadu_pd(b7_ptr + k + 16), sum7);
                                
                                sum0 = _mm512_fmadd_pd(a3, _mm512_loadu_pd(b0_ptr + k + 24), sum0);
                                sum1 = _mm512_fmadd_pd(a3, _mm512_loadu_pd(b1_ptr + k + 24), sum1);
                                sum2 = _mm512_fmadd_pd(a3, _mm512_loadu_pd(b2_ptr + k + 24), sum2);
                                sum3 = _mm512_fmadd_pd(a3, _mm512_loadu_pd(b3_ptr + k + 24), sum3);
                                sum4 = _mm512_fmadd_pd(a3, _mm512_loadu_pd(b4_ptr + k + 24), sum4);
                                sum5 = _mm512_fmadd_pd(a3, _mm512_loadu_pd(b5_ptr + k + 24), sum5);
                                sum6 = _mm512_fmadd_pd(a3, _mm512_loadu_pd(b6_ptr + k + 24), sum6);
                                sum7 = _mm512_fmadd_pd(a3, _mm512_loadu_pd(b7_ptr + k + 24), sum7);
                            }
                            
                            // Handle remaining elements (8 at a time)
                            for (; k <= k_end - 8; k += 8) {
                                __m512d a = _mm512_loadu_pd(a_ptr + k);
                                sum0 = _mm512_fmadd_pd(a, _mm512_loadu_pd(b0_ptr + k), sum0);
                                sum1 = _mm512_fmadd_pd(a, _mm512_loadu_pd(b1_ptr + k), sum1);
                                sum2 = _mm512_fmadd_pd(a, _mm512_loadu_pd(b2_ptr + k), sum2);
                                sum3 = _mm512_fmadd_pd(a, _mm512_loadu_pd(b3_ptr + k), sum3);
                                sum4 = _mm512_fmadd_pd(a, _mm512_loadu_pd(b4_ptr + k), sum4);
                                sum5 = _mm512_fmadd_pd(a, _mm512_loadu_pd(b5_ptr + k), sum5);
                                sum6 = _mm512_fmadd_pd(a, _mm512_loadu_pd(b6_ptr + k), sum6);
                                sum7 = _mm512_fmadd_pd(a, _mm512_loadu_pd(b7_ptr + k), sum7);
                            }
                            
                            // Scalar remainder (rare)
                            for (; k < k_end; k++) {
                                double a_val = a_ptr[k];
                                c_ptr[0] += a_val * b0_ptr[k];
                                c_ptr[1] += a_val * b1_ptr[k];
                                c_ptr[2] += a_val * b2_ptr[k];
                                c_ptr[3] += a_val * b3_ptr[k];
                                c_ptr[4] += a_val * b4_ptr[k];
                                c_ptr[5] += a_val * b5_ptr[k];
                                c_ptr[6] += a_val * b6_ptr[k];
                                c_ptr[7] += a_val * b7_ptr[k];
                            }
                            
                            // Store accumulated results
                            c_ptr[0] += _mm512_reduce_add_pd(sum0);
                            c_ptr[1] += _mm512_reduce_add_pd(sum1);
                            c_ptr[2] += _mm512_reduce_add_pd(sum2);
                            c_ptr[3] += _mm512_reduce_add_pd(sum3);
                            c_ptr[4] += _mm512_reduce_add_pd(sum4);
                            c_ptr[5] += _mm512_reduce_add_pd(sum5);
                            c_ptr[6] += _mm512_reduce_add_pd(sum6);
                            c_ptr[7] += _mm512_reduce_add_pd(sum7);
                        }
                    }
                }
                
                // Handle edge cases (rows/cols not divisible by 8)
                // Process remaining columns
                for (int j = j_full_blocks; j < j_end; j++) {
                    for (int i = ic; i < i_end; i++) {
                        __m512d sum_vec = _mm512_setzero_pd();
                        int k = kc;
                        
                        for (; k <= k_end - 8; k += 8) {
                            __m512d a = _mm512_loadu_pd(&A->data_array[i*m + k]);
                            __m512d b = _mm512_loadu_pd(&B_transposed->data_array[j*m + k]);
                            sum_vec = _mm512_fmadd_pd(a, b, sum_vec);
                        }
                        
                        double sum = _mm512_reduce_add_pd(sum_vec);
                        for (; k < k_end; k++) {
                            sum += A->data_array[i*m + k] * B_transposed->data_array[j*m + k];
                        }
                        
                        result->data_array[i*p + j] += sum;
                    }
                }
                
                // Process remaining rows (columns already handled)
                for (int i = i_full_blocks; i < i_end; i++) {
                    for (int j = jc; j < j_full_blocks; j++) {
                        __m512d sum_vec = _mm512_setzero_pd();
                        int k = kc;
                        
                        for (; k <= k_end - 8; k += 8) {
                            __m512d a = _mm512_loadu_pd(&A->data_array[i*m + k]);
                            __m512d b = _mm512_loadu_pd(&B_transposed->data_array[j*m + k]);
                            sum_vec = _mm512_fmadd_pd(a, b, sum_vec);
                        }
                        
                        double sum = _mm512_reduce_add_pd(sum_vec);
                        for (; k < k_end; k++) {
                            sum += A->data_array[i*m + k] * B_transposed->data_array[j*m + k];
                        }
                        
                        result->data_array[i*p + j] += sum;
                    }
                }
            }
        }
    }
}


#endif /* _MC_H_ */