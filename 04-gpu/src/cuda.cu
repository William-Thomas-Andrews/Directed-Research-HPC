// This program performs matrix multiplication on two matrices on a GPU using CUDA

#include "cuda.h"

#include <stdio.h>
#include <cassert>

// Computes the product of two matrices
__global__ void gpu_multiply(double *a, double *b, double *c, int N) {
    // Calculate global thread IS
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.y + threadIdx.x;
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

// Initializes an array of size "N" with numbers between 0 and 100
void init_matrix(double *a, int N) {
    for (int i = 0; i < N*N; i++) {
        a[i] = rand() % 100;
    }
}

void standard_multiply(int *a, int *b, int *c, int N) {
    int sum;
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            sum = 0;
            for (int k = 0; k < N; k++) {
                sum += a[i * N + k] * b[k * N + j];
            }
            c[i * N + j] = sum;
        }
    }
}

int verify(int *result, int *solution, int N) {
    for (int i = 0; i < N*N; i++) {
        if (result[i] != solution[i]) {
            perror("Error: elements do not match.\n");
            return 0;
        }
    }
    return 1;
}