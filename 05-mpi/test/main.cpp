#include <iostream>
#include <mpi.h>
#include <cstring>
#include <ctime>
#include <cstdlib>
#include <ctime>

#include "../../01-matrix/include/Matrix.h"

#define POWER 10 // exponent size
// #define N

// void print_matrix(const char* name, float* M, int N) {
//     std::cout << "\n" << name << "\n";
//     for (int i = 0; i < N; i++) {
//         for (int j = 0; j < N; j++)
//             std::cout << M[i * N + j] << " ";
//         std::cout << "\n";
//     }
//     std::cout << "\n";
// }

int main(int argc, char* argv[]) {
    int rank, size;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    clock_t start_time, end_time;
    double cpu_time_used;

    int N = 1 << POWER;

    if (N % size != 0) {
        if (rank == 0)
            std::cerr << "ERROR: N must be divisible by size.\n";
        MPI_Finalize();
        return 1;
    }

    int rows_per_proc = N / size;

    // // Use contiguous 1D arrays for MPI compatibility
    // float* A = nullptr;
    // float* B = (float*)malloc(N * N * sizeof(float));  // All processes need B
    // float* C = nullptr;
    // float* local_A = (float*)malloc(rows_per_proc * N * sizeof(float));
    // float* local_C = (float*)malloc(rows_per_proc * N * sizeof(float));

    // // Initialize local_C to zero
    // memset(local_C, 0, rows_per_proc * N * sizeof(float));

    // // Root initializes matrices
    // if (rank == 0) {
    //     srand(time(nullptr));

    //     A = (float*)malloc(N * N * sizeof(float));
    //     for (int i = 0; i < N * N; i++) {
    //         A[i] = rand() % 100;
    //     }

    //     for (int i = 0; i < N * N; i++) {
    //         B[i] = rand() % 100;
    //     }

    //     C = (float*)calloc(N * N, sizeof(float));
    // }
    // start_time = clock();
    // // Scatter rows of A to all processes
    // MPI_Scatter(A, rows_per_proc * N, MPI_FLOAT, local_A, rows_per_proc * N, MPI_FLOAT, 0, MPI_COMM_WORLD);

    // // Broadcast entire matrix B to all processes
    // MPI_Bcast(B, N * N, MPI_FLOAT, 0, MPI_COMM_WORLD);

    // // Compute local matrix multiplication
    // std::cout << "Process " << rank << " computing " << rows_per_proc << " rows\n";
    // for (int i = 0; i < rows_per_proc; i++) {
    //     for (int j = 0; j < N; j++) {
    //         float sum = 0.0;
    //         for (int k = 0; k < N; k++) {
    //             sum += local_A[i * N + k] * B[k * N + j];
    //         }
    //         local_C[i * N + j] = sum;
    //     }
    // }

    // // Gather results back to root
    // MPI_Gather(local_C, rows_per_proc * N, MPI_FLOAT, C, rows_per_proc * N, MPI_FLOAT, 0, MPI_COMM_WORLD);

    // end_time = clock(); // Record end time

    // cpu_time_used = ((double) (end_time - start_time)) / CLOCKS_PER_SEC;

    // printf("Time taken: %f seconds\n", cpu_time_used);

    // // Print result on root
    // if (rank == 0) {
    //     // print_matrix("A:", A);
    //     // print_matrix("B:", B);
    //     // print_matrix("C = A * B:", C);

    //     // Verify correctness using serial matmul
    //     float* D = (float*)calloc(N * N, sizeof(float));
    //     for (int i = 0; i < N; i++)
    //         for (int j = 0; j < N; j++)
    //             for (int k = 0; k < N; k++)
    //                 D[i * N + j] += A[i * N + k] * B[k * N + j];

    //     // print_matrix("Reference (Serial):", D);

    //     // Cleanup root matrices
    //     free(A);
    //     free(C);
    //     free(D);
    // }

    // // Cleanup
    // free(B);
    // free(local_A);
    // free(local_C);


    // New setup - Blocked MPI Matrix Multiplication
    #define BS 16  // Block size (smaller for better parallelization)

    // Check that we have at least 2 processes
    if (size < 2) {
        if (rank == 0) {
            std::cerr << "ERROR: Need at least 2 MPI processes (1 master + 1 worker)\n";
        }
        MPI_Finalize();
        return 1;
    }

    struct Matrix A;
    struct Matrix B;
    struct Matrix C;

    // Root initializes all matrices
    if (rank == 0) {
        init_matrix_r(&A, N, N);
        init_matrix_r(&B, N, N);
        init_matrix(&C, N, N);

        start_time = clock();

        // Calculate number of blocks
        int num_blocks = (N + BS - 1) / BS;
        int total_tasks = num_blocks * num_blocks * num_blocks;
        int task_id = 0;

        // Distribute blocked tasks to worker processes
        for (int ii = 0; ii < N; ii += BS) {
            for (int jj = 0; jj < N; jj += BS) {
                for (int kk = 0; kk < N; kk += BS) {
                    // Determine which process gets this task
                    int target_rank = (task_id % (size - 1)) + 1;  // Distribute to ranks 1 to size-1

                    // Send block coordinates and data
                    MPI_Send(&ii, 1, MPI_INT, target_rank, 0, MPI_COMM_WORLD);
                    MPI_Send(&jj, 1, MPI_INT, target_rank, 1, MPI_COMM_WORLD);
                    MPI_Send(&kk, 1, MPI_INT, target_rank, 2, MPI_COMM_WORLD);
                    MPI_Send(&N, 1, MPI_INT, target_rank, 3, MPI_COMM_WORLD);

                    // Send relevant portions of A and B
                    // For block multiplication C(ii:ii+BS, jj:jj+BS) += A(ii:ii+BS, kk:kk+BS) * B(kk:kk+BS, jj:jj+BS)
                    int block_rows_A = (ii + BS <= N) ? BS : (N - ii);
                    int block_cols_A = (kk + BS <= N) ? BS : (N - kk);
                    int block_rows_B = (kk + BS <= N) ? BS : (N - kk);
                    int block_cols_B = (jj + BS <= N) ? BS : (N - jj);

                    // Send A block
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

                    // Send B block
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

        // Receive results from all workers
        for (int task = 0; task < total_tasks; task++) {
            int ii, jj;
            int block_rows, block_cols;
            MPI_Status status;

            // Receive block coordinates
            MPI_Recv(&ii, 1, MPI_INT, MPI_ANY_SOURCE, 10, MPI_COMM_WORLD, &status);
            MPI_Recv(&jj, 1, MPI_INT, status.MPI_SOURCE, 11, MPI_COMM_WORLD, &status);
            MPI_Recv(&block_rows, 1, MPI_INT, status.MPI_SOURCE, 12, MPI_COMM_WORLD, &status);
            MPI_Recv(&block_cols, 1, MPI_INT, status.MPI_SOURCE, 13, MPI_COMM_WORLD, &status);

            // Receive result block
            float* C_block = (float*)malloc(block_rows * block_cols * sizeof(float));
            MPI_Recv(C_block, block_rows * block_cols, MPI_FLOAT, status.MPI_SOURCE, 14, MPI_COMM_WORLD, &status);

            // Accumulate into C
            for (int i = 0; i < block_rows; i++) {
                for (int j = 0; j < block_cols; j++) {
                    C.data_array[(ii + i) * N + (jj + j)] += C_block[i * block_cols + j];
                }
            }
            free(C_block);
        }

        // Send termination signal to all workers
        int terminate = -1;
        for (int worker = 1; worker < size; worker++) {
            MPI_Send(&terminate, 1, MPI_INT, worker, 0, MPI_COMM_WORLD);
        }

        end_time = clock();
        cpu_time_used = ((double)(end_time - start_time)) / CLOCKS_PER_SEC;
        printf("Blocked MPI Time taken: %f seconds\n", cpu_time_used);

        // Optional: Verify correctness
        struct Matrix D;
        init_matrix(&D, N, N);
        matrix_multiply_1(&D, &A, &B);

        // if (cmp_matrix(&C, &D)) {
        //     printf("MPI blocked result is CORRECT!\n");
        // } else {
        //     printf("MPI blocked result is INCORRECT!\n");
        // }

        del_matrix(&A);
        del_matrix(&B);
        del_matrix(&C);
        del_matrix(&D);
    }
    else { // Worker processes (rank > 0)
        while (true) {
            int ii, jj, kk, n;
            MPI_Status status;

            // Receive block coordinates
            MPI_Recv(&ii, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, &status);

            // Check for termination signal
            if (ii == -1) {
                break;  // Exit loop on termination signal
            }

            MPI_Recv(&jj, 1, MPI_INT, 0, 1, MPI_COMM_WORLD, &status);
            MPI_Recv(&kk, 1, MPI_INT, 0, 2, MPI_COMM_WORLD, &status);
            MPI_Recv(&n, 1, MPI_INT, 0, 3, MPI_COMM_WORLD, &status);

            // Receive A block dimensions and data
            int block_rows_A, block_cols_A;
            MPI_Recv(&block_rows_A, 1, MPI_INT, 0, 4, MPI_COMM_WORLD, &status);
            MPI_Recv(&block_cols_A, 1, MPI_INT, 0, 5, MPI_COMM_WORLD, &status);
            float* A_block = (float*)malloc(block_rows_A * block_cols_A * sizeof(float));
            MPI_Recv(A_block, block_rows_A * block_cols_A, MPI_FLOAT, 0, 6, MPI_COMM_WORLD, &status);

            // Receive B block dimensions and data
            int block_rows_B, block_cols_B;
            MPI_Recv(&block_rows_B, 1, MPI_INT, 0, 7, MPI_COMM_WORLD, &status);
            MPI_Recv(&block_cols_B, 1, MPI_INT, 0, 8, MPI_COMM_WORLD, &status);
            float* B_block = (float*)malloc(block_rows_B * block_cols_B * sizeof(float));
            MPI_Recv(B_block, block_rows_B * block_cols_B, MPI_FLOAT, 0, 9, MPI_COMM_WORLD, &status);

            // Compute local block multiplication: C_block = A_block * B_block
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

            // Send result back to root
            MPI_Send(&ii, 1, MPI_INT, 0, 10, MPI_COMM_WORLD);
            MPI_Send(&jj, 1, MPI_INT, 0, 11, MPI_COMM_WORLD);
            MPI_Send(&block_rows_A, 1, MPI_INT, 0, 12, MPI_COMM_WORLD);
            MPI_Send(&block_cols_B, 1, MPI_INT, 0, 13, MPI_COMM_WORLD);
            MPI_Send(C_block, block_rows_A * block_cols_B, MPI_FLOAT, 0, 14, MPI_COMM_WORLD);

            // Cleanup
            free(A_block);
            free(B_block);
            free(C_block);
        }
    }


    MPI_Finalize();
    return 0;
}
