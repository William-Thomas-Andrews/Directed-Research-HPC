#include <cmath>
#include <chrono>
#include <thread>
#include "mpi.h"

#include "Matrix.hpp"
#include "Solver.hpp"

#define ITERATIONS 10000
#define SIZE 50

// Example: Create initial heat distribution with hot spot in center
Matrix create_initial_heat_distribution(int rows, int cols) {
    Matrix M(rows, cols);

    int center_row = rows / 2;
    int center_col = cols / 2;

    for (int i = 0; i < rows; ++i) {
        for (int j = 0; j < cols; ++j) {
            float dist = std::sqrt(std::pow(i - center_row, 2) + std::pow(j - center_col, 2)); // Distance from center
            M(i, j) = 100.0 * std::exp(-dist * dist / (2.0 * 100.0)); // Gaussian heat distribution centered in middle
        }
    }

    // Set boundary conditions (edges fixed at 0)
    for (int i = 0; i < rows; ++i) {
        M(i, 0) = 0.0;
        M(i, cols - 1) = 65.0;
    }
    for (int j = 0; j < cols; ++j) {
        M(0, j) = 0.0;
        M(rows - 1, j) = 78.0;
    }

    return M;
}

int main() {
    // Create a sample heat distribution matrix
    // MPI_Init(NULL, NULL);
    // int process_Rank, size_Of_Cluster;
    // MPI_Comm_size(MPI_COMM_WORLD, &size_Of_Cluster);
    // MPI_Comm_rank(MPI_COMM_WORLD, &process_Rank);

    int grid_size = SIZE;
    std::chrono::steady_clock::time_point begin, end;
    Solver solver = Solver();
    HeatVisualizer viz;
    Matrix heat_grid;

    // heat_grid = create_initial_heat_distribution(grid_size, grid_size);
    // // std::uniqe_ptr<Matrix> ptr = std::make_unique<Matrix>(create_initial_heat_distribution(grid_size, grid_size));
    // viz.animate_iteration(heat_grid, 0, 1000);
    // // std::cout << "Matrix dimensions: " << heat_grid.get_rows() << "x" << heat_grid.get_cols() << std::endl;
    // begin = std::chrono::steady_clock::now();
    // solver.gauss_seidel_iterate_1(heat_grid, ITERATIONS);
    // end = std::chrono::steady_clock::now();
    // std::cout << "Time difference = " << std::chrono::duration_cast<std::chrono::microseconds>(end - begin).count() << "[µs]" << std::endl;
    // // std::cout << "Time difference = " << std::chrono::duration_cast<std::chrono::nanoseconds> (end - begin).count() << "[ns]" << std::endl;
    // viz.animate_iteration(heat_grid, 1000, 1000);

    heat_grid = create_initial_heat_distribution(grid_size, grid_size);
    // std::cout << "Matrix dimensions: " << heat_grid.get_rows() << "x" << heat_grid.get_cols() << std::endl;
    begin = std::chrono::steady_clock::now();
    solver.jacobi_iterate_1(heat_grid, ITERATIONS);
    end = std::chrono::steady_clock::now();
    std::cout << "Time difference = " << std::chrono::duration_cast<std::chrono::microseconds>(end - begin).count() << "[µs]" << std::endl;
    // std::cout << "Time difference = " << std::chrono::duration_cast<std::chrono::nanoseconds> (end - begin).count() << "[ns]" << std::endl;
    viz.animate_iteration(heat_grid, 1000, 1000);

    // // std::this_thread::sleep_for(std::chrono::milliseconds(150));
    // heat_grid = create_initial_heat_distribution(grid_size, grid_size);
    // // std::cout << "Matrix dimensions: " << heat_grid.get_rows() << "x" << heat_grid.get_cols() << std::endl;
    // begin = std::chrono::steady_clock::now();
    // solver.jacobi_iterate_2(heat_grid, ITERATIONS);
    // end = std::chrono::steady_clock::now();
    // std::cout << "Time difference = " << std::chrono::duration_cast<std::chrono::microseconds>(end - begin).count() << "[µs]" << std::endl;
    // // std::cout << "Time difference = " << std::chrono::duration_cast<std::chrono::nanoseconds> (end - begin).count() << "[ns]" << std::endl;
    // viz.animate_iteration(heat_grid, 1000, 1000);

    // TODO: Implement the double shared grid thing for above rather than constantly creating new grids
    // Also perhaps make a new way to lock it

    return 0;
}