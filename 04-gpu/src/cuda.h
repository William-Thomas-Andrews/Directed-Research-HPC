#ifndef _CUDA_
#define _CUDA_

// #include "Matrix.h"

// CUDA kernel
__global__ void gpu_multiply(double *a, double *b, double *c, int N);

// Host functions
double randfrom(double min, double max);
void init_matrix(double *a, int N);
void standard_multiply(double *a, double *b, double *c, int N);
void standard_transposed_multiply(double *a, double *b, double *c, int N);
int verify(double *result, double *solution, int N);




#endif /* _CUDA_ */