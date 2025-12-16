#include <iostream>
#include <mpi.h>
#include <cstring>
#include <ctime>
#include <cstdlib>

#include "../../01-matrix/include/Matrix.h"

#define POWER 12
#define BS 16

int main(int argc, char* argv[]) {
    int rank, size;
    int N = 1 << POWER;
    printf("Matrix size: %d x %d\n", N, N);
    
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    clock_t start_time, end_time;
    double cpu_time_used;

    if (size < 2) {
        if (rank == 0) {
            std::cerr << "ERROR: Need at least 2 MPI processes (1 master + 1 worker)\n";
        }
        MPI_Finalize();
        return 1;
    }

    struct Matrix A, B, C;

    if (rank == 0) {
        init_matrix_r(&A, N, N);
        init_matrix_r(&B, N, N);
        init_matrix(&C, N, N);

        start_time = clock();

        int num_blocks = (N + BS - 1) / BS;
        int total_tasks = num_blocks * num_blocks * num_blocks;
        int task_id = 0;

        for (int ii = 0; ii < N; ii += BS) {
            for (int jj = 0; jj < N; jj += BS) {
                for (int kk = 0; kk < N; kk += BS) {
                    int target_rank = (task_id % (size - 1)) + 1;

                    MPI_Send(&ii, 1, MPI_INT, target_rank, 0, MPI_COMM_WORLD);
                    MPI_Send(&jj, 1, MPI_INT, target_rank, 1, MPI_COMM_WORLD);
                    MPI_Send(&kk, 1, MPI_INT, target_rank, 2, MPI_COMM_WORLD);
                    MPI_Send(&N, 1, MPI_INT, target_rank, 3, MPI_COMM_WORLD);

                    int block_rows_A = (ii + BS <= N) ? BS : (N - ii);
                    int block_cols_A = (kk + BS <= N) ? BS : (N - kk);
                    int block_rows_B = (kk + BS <= N) ? BS : (N - kk);
                    int block_cols_B = (jj + BS <= N) ? BS : (N - jj);

                    float* A_block = (float*)malloc(block_rows_A * block_cols_A * sizeof(float));
                    for (int i = 0; i < block_rows_A; i++) {
                        for (int k = 0; k < block_cols_A; k++) {
                            A_block[i * block_cols_A + k] = A.data_array[(ii + i) * N + (kk + k)];
                        }
                    }
                    MPI_Send(&block_rows_A, 1, MPI_INT, target_rank, 4, MPI_COMM_WORLD);
                    MPI_Send(&block_cols_A, 1, MPI_INT, target_rank, 5, MPI_COMM_WORLD);
                    MPI_Send(A_block, block_rows_A * block_cols_A, MPI_FLOAT, target_rank, 6, MPI_COMM_WORLD);
                    free(A_block);

                    float* B_block = (float*)malloc(block_rows_B * block_cols_B * sizeof(float));
                    for (int k = 0; k < block_rows_B; k++) {
                        for (int j = 0; j < block_cols_B; j++) {
                            B_block[k * block_cols_B + j] = B.data_array[(kk + k) * N + (jj + j)];
                        }
                    }
                    MPI_Send(&block_rows_B, 1, MPI_INT, target_rank, 7, MPI_COMM_WORLD);
                    MPI_Send(&block_cols_B, 1, MPI_INT, target_rank, 8, MPI_COMM_WORLD);
                    MPI_Send(B_block, block_rows_B * block_cols_B, MPI_FLOAT, target_rank, 9, MPI_COMM_WORLD);
                    free(B_block);

                    task_id++;
                }
            }
        }

        for (int task = 0; task < total_tasks; task++) {
            int ii, jj, block_rows, block_cols;
            MPI_Status status;

            MPI_Recv(&ii, 1, MPI_INT, MPI_ANY_SOURCE, 10, MPI_COMM_WORLD, &status);
            MPI_Recv(&jj, 1, MPI_INT, status.MPI_SOURCE, 11, MPI_COMM_WORLD, &status);
            MPI_Recv(&block_rows, 1, MPI_INT, status.MPI_SOURCE, 12, MPI_COMM_WORLD, &status);
            MPI_Recv(&block_cols, 1, MPI_INT, status.MPI_SOURCE, 13, MPI_COMM_WORLD, &status);

            float* C_block = (float*)malloc(block_rows * block_cols * sizeof(float));
            MPI_Recv(C_block, block_rows * block_cols, MPI_FLOAT, status.MPI_SOURCE, 14, MPI_COMM_WORLD, &status);

            for (int i = 0; i < block_rows; i++) {
                for (int j = 0; j < block_cols; j++) {
                    C.data_array[(ii + i) * N + (jj + j)] += C_block[i * block_cols + j];
                }
            }
            free(C_block);
        }

        int terminate = -1;
        for (int worker = 1; worker < size; worker++) {
            MPI_Send(&terminate, 1, MPI_INT, worker, 0, MPI_COMM_WORLD);
        }

        end_time = clock();
        cpu_time_used = ((double)(end_time - start_time)) / CLOCKS_PER_SEC;
        printf("Blocked MPI Time: %f seconds\n", cpu_time_used);

        struct Matrix D;
        init_matrix(&D, N, N);
        matrix_multiply_1(&D, &A, &B);

        if (cmp_matrix(&C, &D)) {
            printf("MPI result is CORRECT!\n");
        } else {
            printf("MPI result is INCORRECT!\n");
        }

        del_matrix(&A);
        del_matrix(&B);
        del_matrix(&C);
        del_matrix(&D);
    } else {
        while (true) {
            int ii, jj, kk, n;
            MPI_Status status;

            MPI_Recv(&ii, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, &status);
            if (ii == -1) break;

            MPI_Recv(&jj, 1, MPI_INT, 0, 1, MPI_COMM_WORLD, &status);
            MPI_Recv(&kk, 1, MPI_INT, 0, 2, MPI_COMM_WORLD, &status);
            MPI_Recv(&n, 1, MPI_INT, 0, 3, MPI_COMM_WORLD, &status);

            int block_rows_A, block_cols_A;
            MPI_Recv(&block_rows_A, 1, MPI_INT, 0, 4, MPI_COMM_WORLD, &status);
            MPI_Recv(&block_cols_A, 1, MPI_INT, 0, 5, MPI_COMM_WORLD, &status);
            float* A_block = (float*)malloc(block_rows_A * block_cols_A * sizeof(float));
            MPI_Recv(A_block, block_rows_A * block_cols_A, MPI_FLOAT, 0, 6, MPI_COMM_WORLD, &status);

            int block_rows_B, block_cols_B;
            MPI_Recv(&block_rows_B, 1, MPI_INT, 0, 7, MPI_COMM_WORLD, &status);
            MPI_Recv(&block_cols_B, 1, MPI_INT, 0, 8, MPI_COMM_WORLD, &status);
            float* B_block = (float*)malloc(block_rows_B * block_cols_B * sizeof(float));
            MPI_Recv(B_block, block_rows_B * block_cols_B, MPI_FLOAT, 0, 9, MPI_COMM_WORLD, &status);

            float* C_block = (float*)calloc(block_rows_A * block_cols_B, sizeof(float));
            for (int i = 0; i < block_rows_A; i++) {
                for (int j = 0; j < block_cols_B; j++) {
                    float sum = 0.0f;
                    for (int k = 0; k < block_cols_A; k++) {
                        sum += A_block[i * block_cols_A + k] * B_block[k * block_cols_B + j];
                    }
                    C_block[i * block_cols_B + j] = sum;
                }
            }

            MPI_Send(&ii, 1, MPI_INT, 0, 10, MPI_COMM_WORLD);
            MPI_Send(&jj, 1, MPI_INT, 0, 11, MPI_COMM_WORLD);
            MPI_Send(&block_rows_A, 1, MPI_INT, 0, 12, MPI_COMM_WORLD);
            MPI_Send(&block_cols_B, 1, MPI_INT, 0, 13, MPI_COMM_WORLD);
            MPI_Send(C_block, block_rows_A * block_cols_B, MPI_FLOAT, 0, 14, MPI_COMM_WORLD);

            free(A_block);
            free(B_block);
            free(C_block);
        }
    }

    MPI_Finalize();
    return 0;
}
