#ifndef _CUDA_
#define _CUDA_

#include <assert.h>
#include <cublas_v2.h>

#define CEIL_DIV(M, N) (((M) + (N)-1) / (N))


// CUDA Kernels (implementations must be in header for template instantiation)

// Basic GPU matrix multiplication
__global__ void gpu_multiply(double *a, double *b, double *c, int N) {
    // Calculate global thread ID
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    // Boundary check for our matrix
    if (row < N && col < N) {
        // Accumulate partial result
        double sum = 0;
        for (int k = 0; k < N; k++) {
            sum += a[row * N + k] * b[k * N + col];
        }
        c[row * N + col] = sum;
    }
}

// Basic GPU matrix multiplication
__global__ void gpu_multiply_float(float *a, float *b, float *c, int N) {
    // Calculate global thread ID
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    // Boundary check for our matrix
    if (row < N && col < N) {
        // Accumulate partial result
        float sum = 0;
        for (int k = 0; k < N; k++) {
            sum += a[row * N + k] * b[k * N + col];
        }
        c[row * N + col] = sum;
    }
}

// Shared memory cache-blocking GPU matrix multiplication
// Matrix sizes: MxK * KxN = MxN
template <const int BLOCKSIZE>
__global__ void multiply_shared_mem_block(double *A, double *B, double *C, int M, int N, int K) {
  // the output block that we want to compute in this threadblock
  const uint cRow = blockIdx.x;
  const uint cCol = blockIdx.y;

  // allocate buffer for current block in fast shared mem
  // shared mem is shared between all threads in a block
  __shared__ double As[BLOCKSIZE * BLOCKSIZE];
  __shared__ double Bs[BLOCKSIZE * BLOCKSIZE];

  // the inner row & col that we're accessing in this thread
  const uint threadCol = threadIdx.x;
  const uint threadRow = threadIdx.y;

  // advance pointers to the starting positions
  A += cRow * BLOCKSIZE * K;                    // row=cRow, col=0
  B += cCol * BLOCKSIZE;                        // row=0, col=cCol
  C += (cRow * BLOCKSIZE * N) + (cCol * BLOCKSIZE); // row=cRow, col=cCol

  double tmp = 0.0;
  for (int bkIdx = 0; bkIdx < K; bkIdx += BLOCKSIZE) {
    // Have each thread load one of the elements in A & B
    // Make the threadCol (=threadIdx.x) the consecutive index
    // to allow global memory access coalescing
    As[threadRow * BLOCKSIZE + threadCol] = A[threadRow * K + threadCol];
    Bs[threadRow * BLOCKSIZE + threadCol] = B[threadRow * N + threadCol];

    // block threads in this block until cache is fully populated
    __syncthreads();
    A += BLOCKSIZE;
    B += BLOCKSIZE * N;

    // execute the dotproduct on the currently cached block
    for (int dotIdx = 0; dotIdx < BLOCKSIZE; ++dotIdx) {
      tmp += As[threadRow * BLOCKSIZE + dotIdx] * Bs[dotIdx * BLOCKSIZE + threadCol];
    }
    // need to sync again at the end, to avoid faster threads
    // fetching the next block into the cache before slower threads are done
    __syncthreads();
  }
  C[threadRow * N + threadCol] = tmp;
}

template <const int BM, const int BN, const int BK, const int TM, const int TN>
__global__ void __launch_bounds__((BM * BN) / (TM * TN), 1)
    multiply_blocktiling(int M, int N, int K, const double *A, const double *B, double *C) {
    const uint cRow = blockIdx.y;
    const uint cCol = blockIdx.x;

    const uint totalResultsBlocktile = BM * BN;
    // A thread is responsible for calculating TM*TN elements in the blocktile
    const uint numThreadsBlocktile = totalResultsBlocktile / (TM * TN);

    // ResultsPerBlock / ResultsPerThread == ThreadsPerBlock
    assert(numThreadsBlocktile == blockDim.x);

    // BN/TN are the number of threads to span a column
    const int threadCol = threadIdx.x % (BN / TN);
    const int threadRow = threadIdx.x / (BN / TN);

    // allocate space for the current blocktile in smem
    __shared__ double As[BM * BK];
    __shared__ double Bs[BK * BN];

    // Move blocktile to beginning of A's row and B's column
    A += cRow * BM * K;
    B += cCol * BN;
    C += cRow * BM * N + cCol * BN;

    // calculating the indices that this thread will load into SMEM
    const uint innerRowA = threadIdx.x / BK;
    const uint innerColA = threadIdx.x % BK;
    // calculates the number of rows of As that are being loaded in a single step
    // by a single block
    const uint strideA = numThreadsBlocktile / BK;
    const uint innerRowB = threadIdx.x / BN;
    const uint innerColB = threadIdx.x % BN;
    // for both As and Bs we want each load to span the full column-width, for
    // better GMEM coalescing (as opposed to spanning full row-width and iterating
    // across columns)
    const uint strideB = numThreadsBlocktile / BN;

    // allocate thread-local cache for results in registerfile
    double threadResults[TM * TN] = {0.0};
    // register caches for As and Bs
    double regM[TM] = {0.0};
    double regN[TN] = {0.0};

    // outer-most loop over block tiles
    for (uint bkIdx = 0; bkIdx < K; bkIdx += BK) {
        // populate the SMEM caches
        for (uint loadOffset = 0; loadOffset < BM; loadOffset += strideA) {
        As[(innerRowA + loadOffset) * BK + innerColA] =
            A[(innerRowA + loadOffset) * K + innerColA];
        }
        for (uint loadOffset = 0; loadOffset < BK; loadOffset += strideB) {
        Bs[(innerRowB + loadOffset) * BN + innerColB] =
            B[(innerRowB + loadOffset) * N + innerColB];
        }
        __syncthreads();

        // advance blocktile
        A += BK;     // move BK columns to right
        B += BK * N; // move BK rows down

        // calculate per-thread results
        for (uint dotIdx = 0; dotIdx < BK; ++dotIdx) {
        // block into registers
        for (uint i = 0; i < TM; ++i) {
            regM[i] = As[(threadRow * TM + i) * BK + dotIdx];
        }
        for (uint i = 0; i < TN; ++i) {
            regN[i] = Bs[dotIdx * BN + threadCol * TN + i];
        }
        for (uint resIdxM = 0; resIdxM < TM; ++resIdxM) {
            for (uint resIdxN = 0; resIdxN < TN; ++resIdxN) {
            threadResults[resIdxM * TN + resIdxN] +=
                regM[resIdxM] * regN[resIdxN];
            }
        }
        }
        __syncthreads();
    }

    // write out the results
    for (uint resIdxM = 0; resIdxM < TM; ++resIdxM) {
        for (uint resIdxN = 0; resIdxN < TN; ++resIdxN) {
            C[(threadRow * TM + resIdxM) * N + threadCol * TN + resIdxN] =
                threadResults[resIdxM * TN + resIdxN];
        }
    }
}

template <const int BM, const int BN, const int BK, const int TM, const int TN>
__global__ void multiply_vectorize(int M, int N, int K, double *A, double *B, double *C) {
    const uint cRow = blockIdx.y;
    const uint cCol = blockIdx.x;

    // BN/TN are the number of threads to span a column
    const int threadCol = threadIdx.x % (BN / TN);
    const int threadRow = threadIdx.x / (BN / TN);

    // allocate space for the current blocktile in smem
    __shared__ double As[BM * BK];
    __shared__ double Bs[BK * BN];

    // Move blocktile to beginning of A's row and B's column
    A += cRow * BM * K;
    B += cCol * BN;
    C += cRow * BM * N + cCol * BN;

    // calculating the indices that this thread will load into SMEM
    // we'll load 128bit / 32bit = 4 elements per thread at each step
    const uint innerRowA = threadIdx.x / (BK / 4);
    const uint innerColA = threadIdx.x % (BK / 4);
    const uint innerRowB = threadIdx.x / (BN / 4);
    const uint innerColB = threadIdx.x % (BN / 4);

    // allocate thread-local cache for results in registerfile
    double threadResults[TM * TN] = {0.0};
    double regM[TM] = {0.0};
    double regN[TN] = {0.0};

    // outer-most loop over block tiles
    for (uint bkIdx = 0; bkIdx < K; bkIdx += BK) {
        // populate the SMEM caches
        // transpose A while loading it
        double4 tmp =
            reinterpret_cast<double4 *>(&A[innerRowA * K + innerColA * 4])[0];
        As[(innerColA * 4 + 0) * BM + innerRowA] = tmp.x;
        As[(innerColA * 4 + 1) * BM + innerRowA] = tmp.y;
        As[(innerColA * 4 + 2) * BM + innerRowA] = tmp.z;
        As[(innerColA * 4 + 3) * BM + innerRowA] = tmp.w;

        reinterpret_cast<double4 *>(&Bs[innerRowB * BN + innerColB * 4])[0] =
            reinterpret_cast<double4 *>(&B[innerRowB * N + innerColB * 4])[0];
        __syncthreads();

        // advance blocktile
        A += BK;     // move BK columns to right
        B += BK * N; // move BK rows down

        // calculate per-thread results
        for (uint dotIdx = 0; dotIdx < BK; ++dotIdx) {
        // block into registers
        for (uint i = 0; i < TM; ++i) {
            regM[i] = As[dotIdx * BM + threadRow * TM + i];
        }
        for (uint i = 0; i < TN; ++i) {
            regN[i] = Bs[dotIdx * BN + threadCol * TN + i];
        }
        for (uint resIdxM = 0; resIdxM < TM; ++resIdxM) {
            for (uint resIdxN = 0; resIdxN < TN; ++resIdxN) {
            threadResults[resIdxM * TN + resIdxN] +=
                regM[resIdxM] * regN[resIdxN];
            }
        }
        }
        __syncthreads();
    }

    // write out the results
    for (uint resIdxM = 0; resIdxM < TM; resIdxM += 1) {
        for (uint resIdxN = 0; resIdxN < TN; resIdxN += 4) {
        // load C vector into registers
        double4 tmp = reinterpret_cast<double4 *>(
            &C[(threadRow * TM + resIdxM) * N + threadCol * TN + resIdxN])[0];
        // perform GEMM update in reg
        tmp.x = threadResults[resIdxM * TN + resIdxN] + tmp.x;
        tmp.y = threadResults[resIdxM * TN + resIdxN + 1] + tmp.y;
        tmp.z = threadResults[resIdxM * TN + resIdxN + 2] + tmp.z;
        tmp.w = threadResults[resIdxM * TN + resIdxN + 3] + tmp.w;
        // write back
        reinterpret_cast<double4 *>(
            &C[(threadRow * TM + resIdxM) * N + threadCol * TN + resIdxN])[0] =
            tmp;
        }
    }
}

const int K9_NUM_THREADS = 256;

template <const int BM, const int BN, const int BK, const int TM, const int TN>
__global__ void __launch_bounds__(K9_NUM_THREADS)
    multiply_autotuned(int M, int N, int K, double *A, double *B, double *C) {
    const uint cRow = blockIdx.y;
    const uint cCol = blockIdx.x;

    // size of warptile
    constexpr int WM = TM * 16;
    constexpr int WN = TN * 16;
    // iterations of warptile
    constexpr int WMITER = CEIL_DIV(BM, WM);
    constexpr int WNITER = CEIL_DIV(BN, WN);

    // Placement of the thread in the warptile
    const int threadCol = threadIdx.x % (WN / TN);
    const int threadRow = threadIdx.x / (WN / TN);

    // allocate space for the current blocktile in smem
    __shared__ double As[BM * BK];
    __shared__ double Bs[BK * BN];

    // Move blocktile to beginning of A's row and B's column
    A += cRow * BM * K;
    B += cCol * BN;
    C += cRow * BM * N + cCol * BN;

    // calculating the indices that this thread will load into SMEM
    // we'll load 128bit / 32bit = 4 elements per thread at each step
    const uint innerRowA = threadIdx.x / (BK / 4);
    const uint innerColA = threadIdx.x % (BK / 4);
    constexpr uint rowStrideA = (K9_NUM_THREADS * 4) / BK;
    const uint innerRowB = threadIdx.x / (BN / 4);
    const uint innerColB = threadIdx.x % (BN / 4);
    constexpr uint rowStrideB = K9_NUM_THREADS / (BN / 4);

    // allocate thread-local cache for results in registerfile
    double threadResults[WMITER * WNITER * TM * TN] = {0.0};
    double regM[TM] = {0.0};
    double regN[TN] = {0.0};

    // outer-most loop over block tiles
    for (uint bkIdx = 0; bkIdx < K; bkIdx += BK) {
        // populate the SMEM caches
        for (uint offset = 0; offset + rowStrideA <= BM; offset += rowStrideA) {
        double4 tmp = reinterpret_cast<double4 *>(
            &A[(innerRowA + offset) * K + innerColA * 4])[0];
        // transpose A while storing it
        As[(innerColA * 4 + 0) * BM + innerRowA + offset] = tmp.x;
        As[(innerColA * 4 + 1) * BM + innerRowA + offset] = tmp.y;
        As[(innerColA * 4 + 2) * BM + innerRowA + offset] = tmp.z;
        As[(innerColA * 4 + 3) * BM + innerRowA + offset] = tmp.w;
        }

        for (uint offset = 0; offset + rowStrideB <= BK; offset += rowStrideB) {
        reinterpret_cast<double4 *>(
            &Bs[(innerRowB + offset) * BN + innerColB * 4])[0] =
            reinterpret_cast<double4 *>(
                &B[(innerRowB + offset) * N + innerColB * 4])[0];
        }
        __syncthreads();

        for (uint wmIdx = 0; wmIdx < WMITER; ++wmIdx) {
        for (uint wnIdx = 0; wnIdx < WNITER; ++wnIdx) {
            // calculate per-thread results
            for (uint dotIdx = 0; dotIdx < BK; ++dotIdx) {
            // block into registers
            for (uint i = 0; i < TM; ++i) {
                regM[i] = As[dotIdx * BM + (wmIdx * WM) + threadRow * TM + i];
            }
            for (uint i = 0; i < TN; ++i) {
                regN[i] = Bs[dotIdx * BN + (wnIdx * WN) + threadCol * TN + i];
            }
            for (uint resIdxM = 0; resIdxM < TM; ++resIdxM) {
                for (uint resIdxN = 0; resIdxN < TN; ++resIdxN) {
                threadResults[(wmIdx * TM + resIdxM) * (WNITER * TN) +
                                wnIdx * TN + resIdxN] +=
                    regM[resIdxM] * regN[resIdxN];
                }
            }
            }
        }
        }
        __syncthreads();
        // advance blocktile
        A += BK;     // move BK columns to right
        B += BK * N; // move BK rows down
    }

    // write out the results
    for (uint wmIdx = 0; wmIdx < WMITER; ++wmIdx) {
        for (uint wnIdx = 0; wnIdx < WNITER; ++wnIdx) {
        double *C_interim = C + (wmIdx * WM * N) + (wnIdx * WN);
        for (uint resIdxM = 0; resIdxM < TM; resIdxM += 1) {
            for (uint resIdxN = 0; resIdxN < TN; resIdxN += 4) {
            // load C vector into registers
            double4 tmp = reinterpret_cast<double4 *>(
                &C_interim[(threadRow * TM + resIdxM) * N + threadCol * TN +
                            resIdxN])[0];
            // perform GEMM update in reg
            const int i =
                (wmIdx * TM + resIdxM) * (WNITER * TN) + wnIdx * TN + resIdxN;
            tmp.x = threadResults[i + 0] + tmp.x;
            tmp.y = threadResults[i + 1] + tmp.y;
            tmp.z = threadResults[i + 2] + tmp.z;
            tmp.w = threadResults[i + 3] + tmp.w;
            // write back
            reinterpret_cast<double4 *>(&C_interim[(threadRow * TM + resIdxM) * N +
                                                    threadCol * TN + resIdxN])[0] =
                tmp;
            }
        }
        }
    }
}

// cuBLAS wrapper function (double precision)
// Performs C = A * B using cuBLAS DGEMM
// Matrix sizes: MxK * KxN = MxN
// NOTE: RTX A5000 has 1:32 FP64:FP32 ratio, so double precision is 32x slower!
inline void multiply_cublas(cublasHandle_t handle, double *A, double *B, double *C, int M, int N, int K) {
    const double alpha = 1.0;
    const double beta = 0.0;

    // cuBLAS uses column-major order, so we compute C^T = B^T * A^T
    // to get the same result as row-major C = A * B
    cublasDgemm(handle, CUBLAS_OP_N, CUBLAS_OP_N,
                N, M, K,           // dimensions: N x M result from K x N * M x K
                &alpha,
                B, N,              // B is K x N in row-major = N x K in col-major
                A, K,              // A is M x K in row-major = K x M in col-major
                &beta,
                C, N);             // C is M x N in row-major = N x M in col-major
}

// cuBLAS wrapper function (single precision) - MUCH FASTER on consumer GPUs!
// Performs C = A * B using cuBLAS SGEMM
// Matrix sizes: MxK * KxN = MxN
inline void multiply_cublas_float(cublasHandle_t handle, float *A, float *B, float *C, int M, int N, int K) {
    const float alpha = 1.0f;
    const float beta = 0.0f;

    // cuBLAS uses column-major order, so we compute C^T = B^T * A^T
    // to get the same result as row-major C = A * B
    cublasSgemm(handle, CUBLAS_OP_N, CUBLAS_OP_N,
                N, M, K,
                &alpha,
                B, N,
                A, K,
                &beta,
                C, N);
}

// Host function declarations
double randfrom(double min, double max);
void init_matrix(double *a, int N);
void standard_multiply(double *a, double *b, double *c, int N);
void standard_transposed_multiply(double *a, double *b, double *c, int N);
int verify(double *result, double *solution, int N);

#endif /* _CUDA_ */