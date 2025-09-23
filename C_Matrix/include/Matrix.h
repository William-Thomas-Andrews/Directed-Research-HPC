#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <float.h> 
#include <stdbool.h>
#include <pthread.h>


#ifndef _MATRIX_H_
#define _MATRIX_H

#define MIN 0.00L
#define MAX 100.00L

long double randfrom(long double min, long double max) {
    long double range = (max - min); 
    long double div = RAND_MAX / range;
    return min + (rand() / div);
}

struct Matrix {
    long double* data_array;
    int size, rows, cols;
};

static inline void init_matrix(struct Matrix *matrix, int r, int c) {
    if (r < 0 || c < 0) { fprintf(stderr, "Error: row or col sizes cannot be below 0\n"); exit(1); }
    int size = r*c;
    matrix->size = size;
    matrix->rows = r;
    matrix->cols = c;
    matrix->data_array = (long double*)calloc(size, sizeof(long double));
}

static inline void init_matrix_r(struct Matrix *matrix, int r, int c) {
    if (r < 0 || c < 0) { fprintf(stderr, "Error: row or col sizes cannot be below 0\n"); exit(1); }
    int size = r*c;
    matrix->size = size;
    matrix->rows = r;
    matrix->cols = c;
    matrix->data_array = (long double*)malloc(size * sizeof(long double));
    srand(time(NULL));
    for (int i = 0; i < size; i++) {
        matrix->data_array[i] = randfrom(MIN, MAX);
    }
}

static inline void init_matrix_v(struct Matrix *matrix, int r, int c, long double val) {
    if (r < 0 || c < 0) { fprintf(stderr, "Error: row or col sizes cannot be below 0\n"); exit(1); }
    int size = r*c;
    matrix->size = size;
    matrix->rows = r;
    matrix->cols = c;
    matrix->data_array = (long double*)malloc(size * sizeof(long double));
    for (int i = 0; i < size; i++) {
        matrix->data_array[i] = val; 
    }
}

static inline long double* get_element(struct Matrix *matrix, int row_index, int col_index) {
    if (row_index < 0)  { fprintf(stderr, "Error: Row index %d smaller than 0\n", row_index); exit(1); }
    else if (row_index >= matrix->rows) { fprintf(stderr, "Error: Row index %d larger than row upper bound %d\n", row_index, matrix->rows-1); exit(1); }
    else if (col_index < 0) { fprintf(stderr, "Error: Column index %d smaller than 0\n", col_index); exit(1); }
    else if (col_index >= matrix->cols) { fprintf(stderr, "Error: Col index %d larger than col upper bound %d\n", col_index, matrix->cols-1); exit(1); }
    int index = (row_index) * matrix->cols + (col_index);
    return &(matrix->data_array[index]);
}

static inline int get_size(struct Matrix *matrix) {
    return matrix->size;
}

static inline void matrix_multiply_1(struct Matrix *result, struct Matrix *A, struct Matrix *B) {
    int A_cols = A->cols; int B_cols = B->cols; int A_rows = A->rows; int B_rows = B->rows;
    if (A->cols != B->rows)      { fprintf(stderr, "Matrix 1 colums do not match Matrix 2 rows.\n");           exit(1); }
    if (result->rows != A_rows)  { fprintf(stderr, "Result matrix rows do not match Matrix 1 rows.\n");        exit(1); }
    if (result->cols != B_cols)  { fprintf(stderr, "Result matrix columns do not match Matrix 2 columns.\n");  exit(1); }
    // long double sum;
    for (int i = 0; i < A_rows; i++) {
        for (int j = 0; j < B_cols; j++) {
            // sum = 0.0;
            for (int k = 0; k < B_rows; k++) {
                // get_element(result, i, j) += get_element(A, i, k) * get_element(B, k, j);
                result->data_array[i * B_cols + j] += A->data_array[i * A_cols + k] * B->data_array[k * B_cols + j]; // Disabled because using the 'sum' container is significantly more cache efficient
                // sum += get_element(A, i, k) * get_element(B, k, j);
                // sum += A->data_array[i * A_cols + k] * B->data_array[k * B_cols + j];
            }
            // result(i, j) = sum;
            // result->data_array[i * B_cols + j] = sum;;
        }
    }
}


static inline void matrix_multiply_2(struct Matrix *result, struct Matrix *A, struct Matrix *B) {
    int A_cols = A->cols; int B_cols = B->cols; int A_rows = A->rows; int B_rows = B->rows;
    if (A->cols != B->rows)      { fprintf(stderr, "Matrix 1 colums do not match Matrix 2 rows.\n");           exit(1); }
    if (result->rows != A_rows)  { fprintf(stderr, "Result matrix rows do not match Matrix 1 rows.\n");        exit(1); }
    if (result->cols != B_cols)  { fprintf(stderr, "Result matrix columns do not match Matrix 2 columns.\n");  exit(1); }
    for (int i = 0; i < A_cols; i++) {
        for (int j = 0; j < B_cols; j++) {
            for (int k = 0; k < A_rows; k++) {
                // *get_element(result, k, j) += (*get_element(A, k, i)) * (*get_element(B, i, j));
                result->data_array[k * B_cols + j] += A->data_array[k * A_cols + i] * B->data_array[i * B_cols + j];
            }
        }
    }
}


static inline void matrix_multiply_3(struct Matrix *result, struct Matrix *A, struct Matrix *B) {
    int A_cols = A->cols; int B_cols = B->cols; int A_rows = A->rows; int B_rows = B->rows;
    if (A->cols != B->rows)      { fprintf(stderr, "Matrix 1 colums do not match Matrix 2 rows.\n");           exit(1); }
    if (result->rows != A_rows)  { fprintf(stderr, "Result matrix rows do not match Matrix 1 rows.\n");        exit(1); }
    if (result->cols != B_cols)  { fprintf(stderr, "Result matrix columns do not match Matrix 2 columns.\n");  exit(1); }
    // long double sum;
    for (int i = 0; i < B_cols; i++) {
        for (int j = 0; j < A_rows; j++) {
            // sum = 0.0;
            for (int k = 0; k < A_cols; k++) {
                // *get_element(result, j, i) += (*get_element(A, j, l)) * (*get_element(B, l, i));
                result->data_array[j * B_cols + i] += A->data_array[j * A_cols + k] * B->data_array[k * B_cols + i];
                // sum += A->data_array[j * A_cols + k] * B->data_array[k * B_cols + i];
            }
            // result->data_array[j * B_cols + i] = sum;
        }
    }
}

struct ThreadArgs {
    struct Matrix *result, *A, *B;
};  

static inline void *routine_40(void* arg) {
    struct ThreadArgs *data = (struct ThreadArgs *)arg;
    long double sum;
    for (int i = 0; i < data->A->rows / 2; i++) {
        for (int j = 0; j < data->B->cols; j++) {
            sum = 0.0;
            for (int k = 0; k < data->B->rows; k++) {
                // get_element(result, i, j) += get_element(A, i, k) * get_element(B, k, j);
                // result->data_array[i * B_cols + j] += A->data_array[i * A_cols + k) * B->data_array[k * B_cols + j); // Disabled because using the 'sum' container is significantly more cache efficient
                // sum += get_element(A, i, k) * get_element(B, k, j);
                sum += data->A->data_array[i * data->A->cols + k] * data->B->data_array[k * data->B->cols + j];
            }
            // result(i, j) = sum;
            data->result->data_array[i * data->B->cols + j] = sum;;
        }
    }
    free(data);
    pthread_exit(NULL);
}

static inline void *routine_41(void* arg) {
    struct ThreadArgs *data = (struct ThreadArgs *)arg;
    long double sum;
    for (int i = (data->A->rows / 2); i < data->A->rows; i++) {
        for (int j = 0; j < data->B->cols; j++) {
            sum = 0.0;
            for (int k = 0; k < data->B->rows; k++) {
                // get_element(result, i, j) += get_element(A, i, k) * get_element(B, k, j);
                // result->data_array[i * B_cols + j] += A->data_array[i * A_cols + k) * B->data_array[k * B_cols + j); // Disabled because using the 'sum' container is significantly more cache efficient
                // sum += get_element(A, i, k) * get_element(B, k, j);
                sum += data->A->data_array[i * data->A->cols + k] * data->B->data_array[k * data->B->cols + j];
            }
            // result(i, j) = sum;
            data->result->data_array[i * data->B->cols + j] = sum;;
        }
    }
    free(data);
    pthread_exit(NULL);
}

// Multi-threaded
static inline void matrix_multiply_4(struct Matrix *result, struct Matrix *A, struct Matrix *B) {
    int A_cols = A->cols; int B_cols = B->cols; int A_rows = A->rows; int B_rows = B->rows;
    if (A->cols != B->rows)      { fprintf(stderr, "Matrix 1 colums do not match Matrix 2 rows.\n");           exit(1); }
    if (result->rows != A_rows)  { fprintf(stderr, "Result matrix rows do not match Matrix 1 rows.\n");        exit(1); }
    if (result->cols != B_cols)  { fprintf(stderr, "Result matrix columns do not match Matrix 2 columns.\n");  exit(1); }
    struct ThreadArgs *args_0 = (struct ThreadArgs *)malloc(sizeof(struct ThreadArgs));
    args_0->result = result; args_0->A = A; args_0->B = B;
    pthread_t thread_0;
    struct ThreadArgs *args_1 = (struct ThreadArgs*)malloc(sizeof(struct ThreadArgs));
    args_1->result = result; args_1->A = A; args_1->B = B;
    pthread_t thread_1;
    void *ret_0, *ret_1;
    pthread_create(&thread_0, NULL, &routine_40, (void*)args_0);
    pthread_create(&thread_1, NULL, &routine_41, (void*)args_1);
    pthread_join(thread_0, &ret_0);
    pthread_join(thread_1, &ret_1);
}

static inline void *routine_50(void* arg) {
    struct ThreadArgs *data = (struct ThreadArgs *)arg;
    long double sum;
    for (int i = 0; i < data->B->cols / 2; i++) {
        for (int j = 0; j < data->A->rows; j++) {
            sum = 0.0;
            for (int k = 0; k < data->A->cols; k++) {
                // *get_element(result, j, i) += (*get_element(A, j, l)) * (*get_element(B, l, i));
                // data->result->data_array[j * data->B->cols + i] += data->A->data_array[j * data->A->cols + k] * data->B->data_array[k * data->B->cols + i];
                sum += data->A->data_array[j * data->A->cols + k] * data->B->data_array[k * data->B->cols + i];
            }
            data->result->data_array[j * data->B->cols + i] = sum;
        }
    }
    free(data);
    pthread_exit(NULL);
}

static inline void *routine_51(void* arg) {
    struct ThreadArgs *data = (struct ThreadArgs *)arg;
    long double sum;
    for (int i = data->B->cols / 2; i < data->B->cols; i++) {
        for (int j = 0; j < data->A->rows; j++) {
            sum = 0.0;
            for (int k = 0; k < data->A->cols; k++) {
                // *get_element(result, j, i) += (*get_element(A, j, l)) * (*get_element(B, l, i));
                // data->result->data_array[j * data->B->cols + i] += data->A->data_array[j * data->A->cols + k] * data->B->data_array[k * data->B->cols + i];
                sum += data->A->data_array[j * data->A->cols + k] * data->B->data_array[k * data->B->cols + i];
            }
            data->result->data_array[j * data->B->cols + i] = sum;
        }
    }
    free(data);
    pthread_exit(NULL);
}

// Multi-threaded
static inline void matrix_multiply_5(struct Matrix *result, struct Matrix *A, struct Matrix *B) {
    int A_cols = A->cols; int B_cols = B->cols; int A_rows = A->rows; int B_rows = B->rows;
    if (A->cols != B->rows)      { fprintf(stderr, "Matrix 1 colums do not match Matrix 2 rows.\n");           exit(1); }
    if (result->rows != A_rows)  { fprintf(stderr, "Result matrix rows do not match Matrix 1 rows.\n");        exit(1); }
    if (result->cols != B_cols)  { fprintf(stderr, "Result matrix columns do not match Matrix 2 columns.\n");  exit(1); }
    struct ThreadArgs *args_0 = (struct ThreadArgs *)malloc(sizeof(struct ThreadArgs));
    args_0->result = result; args_0->A = A; args_0->B = B;
    pthread_t thread_0;
    struct ThreadArgs *args_1 = (struct ThreadArgs*)malloc(sizeof(struct ThreadArgs));
    args_1->result = result; args_1->A = A; args_1->B = B;
    pthread_t thread_1;
    void *ret_0, *ret_1;
    pthread_create(&thread_0, NULL, &routine_50, (void*)args_0);
    pthread_create(&thread_1, NULL, &routine_51, (void*)args_1);
    pthread_join(thread_0, &ret_0);
    pthread_join(thread_1, &ret_1);
}

static inline void *routine_60(void* arg) {
    struct ThreadArgs *data = (struct ThreadArgs *)arg;
    long double sum;
    for (int i = 0; i < data->B->cols / 4; i++) {
        for (int j = 0; j < data->A->rows; j++) {
            sum = 0.0;
            for (int k = 0; k < data->A->cols; k++) {
                // *get_element(result, j, i) += (*get_element(A, j, l)) * (*get_element(B, l, i));
                // data->result->data_array[j * data->B->cols + i] += data->A->data_array[j * data->A->cols + k] * data->B->data_array[k * data->B->cols + i];
                sum += data->A->data_array[j * data->A->cols + k] * data->B->data_array[k * data->B->cols + i];
            }
            data->result->data_array[j * data->B->cols + i] = sum;
        }
    }
    free(data);
    pthread_exit(NULL);
}

static inline void *routine_61(void* arg) {
    struct ThreadArgs *data = (struct ThreadArgs *)arg;
    long double sum;
    for (int i = data->B->cols / 4; i < data->B->cols / 2; i++) {
        for (int j = 0; j < data->A->rows; j++) {
            sum = 0.0;
            for (int k = 0; k < data->A->cols; k++) {
                // *get_element(result, j, i) += (*get_element(A, j, l)) * (*get_element(B, l, i));
                // data->result->data_array[j * data->B->cols + i] += data->A->data_array[j * data->A->cols + k] * data->B->data_array[k * data->B->cols + i];
                sum += data->A->data_array[j * data->A->cols + k] * data->B->data_array[k * data->B->cols + i];
            }
            data->result->data_array[j * data->B->cols + i] = sum;
        }
    }
    free(data);
    pthread_exit(NULL);
}

static inline void *routine_62(void* arg) {
    struct ThreadArgs *data = (struct ThreadArgs *)arg;
    long double sum;
    for (int i = data->B->cols / 2; i < (data->B->cols * 3) / 4; i++) {
        for (int j = 0; j < data->A->rows; j++) {
            sum = 0.0;
            for (int k = 0; k < data->A->cols; k++) {
                // *get_element(result, j, i) += (*get_element(A, j, l)) * (*get_element(B, l, i));
                // data->result->data_array[j * data->B->cols + i] += data->A->data_array[j * data->A->cols + k] * data->B->data_array[k * data->B->cols + i];
                sum += data->A->data_array[j * data->A->cols + k] * data->B->data_array[k * data->B->cols + i];
            }
            data->result->data_array[j * data->B->cols + i] = sum;
        }
    }
    free(data);
    pthread_exit(NULL);
}

static inline void *routine_63(void* arg) {
    struct ThreadArgs *data = (struct ThreadArgs *)arg;
    long double sum;
    for (int i = (data->B->cols * 3) / 4; i < data->B->cols; i++) {
        for (int j = 0; j < data->A->rows; j++) {
            sum = 0.0;
            for (int k = 0; k < data->A->cols; k++) {
                // *get_element(result, j, i) += (*get_element(A, j, l)) * (*get_element(B, l, i));
                // data->result->data_array[j * data->B->cols + i] += data->A->data_array[j * data->A->cols + k] * data->B->data_array[k * data->B->cols + i];
                sum += data->A->data_array[j * data->A->cols + k] * data->B->data_array[k * data->B->cols + i];
            }
            data->result->data_array[j * data->B->cols + i] = sum;
        }
    }
    free(data);
    pthread_exit(NULL);
}

// Multi-threaded
static inline void matrix_multiply_6(struct Matrix *result, struct Matrix *A, struct Matrix *B) {
    int A_cols = A->cols; int B_cols = B->cols; int A_rows = A->rows; int B_rows = B->rows;
    if (A->cols != B->rows)      { fprintf(stderr, "Matrix 1 colums do not match Matrix 2 rows.\n");           exit(1); }
    if (result->rows != A_rows)  { fprintf(stderr, "Result matrix rows do not match Matrix 1 rows.\n");        exit(1); }
    if (result->cols != B_cols)  { fprintf(stderr, "Result matrix columns do not match Matrix 2 columns.\n");  exit(1); }
    struct ThreadArgs *args_0 = (struct ThreadArgs *)malloc(sizeof(struct ThreadArgs));
    args_0->result = result; args_0->A = A; args_0->B = B;
    pthread_t thread_0;
    struct ThreadArgs *args_1 = (struct ThreadArgs*)malloc(sizeof(struct ThreadArgs));
    args_1->result = result; args_1->A = A; args_1->B = B;
    pthread_t thread_1;
    struct ThreadArgs *args_2 = (struct ThreadArgs *)malloc(sizeof(struct ThreadArgs));
    args_2->result = result; args_2->A = A; args_2->B = B;
    pthread_t thread_2;
    struct ThreadArgs *args_3 = (struct ThreadArgs*)malloc(sizeof(struct ThreadArgs));
    args_3->result = result; args_3->A = A; args_3->B = B;
    pthread_t thread_3;
    void *ret_0, *ret_1, *ret_2, *ret_3;
    pthread_create(&thread_0, NULL, &routine_60, (void*)args_0);
    pthread_create(&thread_1, NULL, &routine_61, (void*)args_1);
    pthread_create(&thread_2, NULL, &routine_62, (void*)args_2);
    pthread_create(&thread_3, NULL, &routine_63, (void*)args_3);
    pthread_join(thread_0, &ret_0);
    pthread_join(thread_1, &ret_1);
    pthread_join(thread_2, &ret_2);
    pthread_join(thread_3, &ret_3);
}

static inline void matrix_multiply_7(struct Matrix *result, struct Matrix *A, struct Matrix *B) {
    int A_cols = A->cols; int B_cols = B->cols; int A_rows = A->rows; int B_rows = B->rows;
    if (A->cols != B->rows)      { fprintf(stderr, "Matrix 1 colums do not match Matrix 2 rows.\n");           exit(1); }
    if (result->rows != A_rows)  { fprintf(stderr, "Result matrix rows do not match Matrix 1 rows.\n");        exit(1); }
    if (result->cols != B_cols)  { fprintf(stderr, "Result matrix columns do not match Matrix 2 columns.\n");  exit(1); }
    
}

static inline void print_matrix(struct Matrix *matrix) {
    int cols = matrix->cols;
    for (int i = 0; i < matrix->rows; i++) {
        for (int j = 0; j < cols; j++) {
            if (j == cols-1) {
                printf("%Lf\n", matrix->data_array[i*cols + j]);
            } else {
                printf("%Lf ", matrix->data_array[i*cols + j]);
            }
        }
    }
    // A more cache inefficent version:
    // int size = matrix->size;
    // for (int index = 0; index < size; index++) {
    //     if (index != 0 && ((index+1) % cols) == 0) {
    //         printf("%Lf\n", matrix->data_array[index]);
    //     } else {
    //         printf("%Lf ", matrix->data_array[index]);
    //     }
    // }
}

static inline void del_matrix(struct Matrix *matrix) {
    free(matrix->data_array);
}

static inline int cmp_matrix(struct Matrix *A, struct Matrix *B) {
    if (A->rows != B->rows && A->cols != B->cols) { printf("Error: row and column sizes do not match\n"); return 0; } // fprintf(stderr, "Error: row and column sizes do not match\n");
    else if (A->rows != B->rows) return 0; // fprintf(stderr, "Error: row sizes do not match\n");
    else if (A->cols != B->cols) return 0; // fprintf(stderr, "Error: column sizes do not match\n");
    else if (A->size != B->size) return 0; // fprintf(stderr, "Error: matrix sizes do not match\n");
    for (int i = 0; i < A->size; i++) {
        if ((A->data_array[i] - B->data_array[i]) > 1e-9 || (A->data_array[i] - B->data_array[i]) < -1e-9)  { printf("DEBUG: %Lf and %Lf were not the same.\n", A->data_array[i], B->data_array[i]); return 0; }
    }
    return 1;
}



#endif /* _MATRIX_H_ */