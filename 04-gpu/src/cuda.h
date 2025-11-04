#ifndef _CUDA_
#define _CUDA_


__global__ void gpu_multiply(int *a, int *b, int *c, int N);

void init_matrix(int *a, int N);

void standard_multiply(int *a, int *b, int *c, int N);

int verify(int *result, int *solution, int N);


#endif /* _CUDA_ */