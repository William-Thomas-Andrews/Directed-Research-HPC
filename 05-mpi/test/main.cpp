#include <iostream>
#include <mpi.h>
#include <cstring>

#define N 4   // matrix size

void print_matrix(const char* name, float M[N][N]) {
    std::cout << "\n" << name << "\n";
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++)
            std::cout << M[i][j] << " ";
        std::cout << "\n";
    }
    std::cout << "\n";
}

int main(int argc, char* argv[]) {
    int rank, size;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (N % size != 0) {
        if (rank == 0)
            std::cerr << "ERROR: N must be divisible by size.\n";
        MPI_Finalize();
        return 1;
    }

    int rows_per_proc = N / size;

    float A[N][N], B[N][N], C[N][N];
    float local_A[rows_per_proc][N];
    float local_C[rows_per_proc][N];

    // Root initializes matrices
    if (rank == 0) {
        float A_init[N][N] = {
            {1,2,3,4},
            {5,6,7,8},
            {9,1,2,3},
            {4,5,6,7}
        };
        float B_init[N][N] = {
            {1,2,3,4},
            {5,6,7,8},
            {9,1,2,3},
            {4,5,6,7}
        };
        std::memcpy(A, A_init, sizeof(A));
        std::memcpy(B, B_init, sizeof(B));
    }

    // Scatter rows of A
    MPI_Scatter(A, rows_per_proc * N, MPI_FLOAT, local_A, rows_per_proc * N, MPI_FLOAT, 0, MPI_COMM_WORLD);

    // Broadcast all of B to everyone
    MPI_Bcast(B, N * N, MPI_FLOAT, 0, MPI_COMM_WORLD);

    // Compute local block of C
    for (int r = 0; r < rows_per_proc; r++) {
        for (int j = 0; j < N; j++) {
            float sum = 0.0f;
            for (int k = 0; k < N; k++) {
                sum += local_A[r][k] * B[k][j];
            }
            local_C[r][j] = sum;
        }
    }

    // Gather local C blocks into full C on root
    MPI_Gather(local_C, rows_per_proc * N, MPI_FLOAT, C, rows_per_proc * N, MPI_FLOAT, 0, MPI_COMM_WORLD);

    // Print result on root
    if (rank == 0) {
        print_matrix("A:", A);
        print_matrix("B:", B);
        print_matrix("C = A * B:", C);

        // Verify correctness using serial matmul
        float D[N][N] = {0};
        for (int i = 0; i < N; i++)
            for (int j = 0; j < N; j++)
                for (int k = 0; k < N; k++)
                    D[i][j] += A[i][k] * B[k][j];

        print_matrix("Reference (Serial):", D);
    }

    MPI_Finalize();
    return 0;
}
