// This program performs matrix multiplication on two matrices on a GPU using CUDA


#include <cstdlib>

// Computes the product of two matrices
__global__ void gpu_multiply(int *a, int *b, int *c, int N) {

}

// Initializes an array of size "N" with numbers between 0 and 100
void init_matrix(int *a, int N) {
    for (int i = 0; i < N*N; i++) {
        a[i] = rand() % 100;
    }
}



