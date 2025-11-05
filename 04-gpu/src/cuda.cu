// Host-side utility functions for CUDA matrix multiplication

#include "cuda.h"
#include <stdio.h>
#include <stdlib.h>

#define MIN 0.00L
#define MAX 2.00L

// Random number generator
double new_randfrom(double min, double max) {
    double range = (max - min);
    double div = RAND_MAX / range;
    return min + (rand() / div);
}

void new_transpose(double *input, int N) {
    double *temp;
    // init_matrix(&temp, input->cols, input->rows);
    temp = (double *) malloc(sizeof(double) * N * N);
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            temp[j * N + i] = input[i * N + j];
        }
    }
    for (int k = 0; k < N*N; k++) {
        input[k] = temp[k];
    }
    free(temp);
}

// Initializes an array of size "N" with numbers between 0 and 100
void init_matrix(double *a, int N) {
    for (int i = 0; i < N*N; i++) {
        a[i] = new_randfrom(MIN, MAX);
    }
}

void standard_multiply(double *a, double *b, double *c, int N) {
    double sum;
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            sum = 0.0;
            for (int k = 0; k < N; k++) {
                sum += a[i * N + k] * b[k * N + j];
            }
            c[i * N + j] = sum;
        }
    }
}

// Intelligent transposition for array locality
void standard_transposed_multiply(double *a, double *b, double *c, int N) {
    new_transpose(b, N);
    double sum;
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            sum = 0.0;
            for (int k = 0; k < N; k++) {
                sum += a[i * N + k] * b[j * N + k];
            }
            c[i * N + j] = sum;
        }
    }
    new_transpose(b, N);
}

int verify(double *result, double *solution, int N) {
    for (int i = 0; i < N*N; i++) {
        if ((result[i] - solution[i]) > 1e-9 || (result[i] - solution[i]) < -1e-9) {
            printf("Error: elements %f and %f do not match.\n", result[i], solution[i]);
            return 0;
        }
    }
    return 1;
}


