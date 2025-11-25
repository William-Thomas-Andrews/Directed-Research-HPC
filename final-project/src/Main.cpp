#include <cmath>
#include <chrono>
#include <thread>

#include "Matrix.hpp"
#include "Solver.hpp"

// Example: Create initial heat distribution with hot spot in center
Matrix create_initial_heat_distribution(int rows, int cols) {
    Matrix M(rows, cols);

    int center_row = rows / 2;
    int center_col = cols / 2;

    for (int i = 0; i < rows; ++i) {
        for (int j = 0; j < cols; ++j) {
            // Distance from center
            float dist = std::sqrt(std::pow(i - center_row, 2) + std::pow(j - center_col, 2));
            // Gaussian heat distribution centered in middle
            M(i, j) = 100.0 * std::exp(-dist * dist / (2.0 * 100.0));
            // M(i, j) = 10.0;
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
    MPI_Init(NULL, NULL);
    int process_Rank, size_Of_Cluster;
    MPI_Comm_size(MPI_COMM_WORLD, &size_Of_Cluster);
    MPI_Comm_rank(MPI_COMM_WORLD, &process_Rank);
    int grid_size = 500;
    std::chrono::steady_clock::time_point begin, end;
    Solver solver;
    HeatVisualizer viz;

    Matrix heat_grid = create_initial_heat_distribution(grid_size, grid_size);
    // viz.animate_iteration(heat_grid, 0, 1000);
    std::cout << "Matrix dimensions: " << heat_grid.get_rows() << "x" << heat_grid.get_cols() << std::endl;
    solver = Solver(&heat_grid, 0.0);
    begin = std::chrono::steady_clock::now();
    solver.gauss_seidel_iterate_1(1000);
    end = std::chrono::steady_clock::now();
    std::cout << "Time difference = " << std::chrono::duration_cast<std::chrono::microseconds>(end - begin).count() << "[µs]" << std::endl;
    // std::cout << "Time difference = " << std::chrono::duration_cast<std::chrono::nanoseconds> (end - begin).count() << "[ns]" << std::endl;
    // viz.animate_iteration(heat_grid, 1000, 1000);

    heat_grid = create_initial_heat_distribution(grid_size, grid_size);
    std::cout << "Matrix dimensions: " << heat_grid.get_rows() << "x" << heat_grid.get_cols() << std::endl;
    // solver = Solver(&heat_grid, 0.0);
    begin = std::chrono::steady_clock::now();
    solver.jacobi_iterate_1(1000);
    end = std::chrono::steady_clock::now();
    std::cout << "Time difference = " << std::chrono::duration_cast<std::chrono::microseconds>(end - begin).count() << "[µs]" << std::endl;
    // std::cout << "Time difference = " << std::chrono::duration_cast<std::chrono::nanoseconds> (end - begin).count() << "[ns]" << std::endl;
    // viz.animate_iteration(heat_grid, 1000, 1000);

    heat_grid = create_initial_heat_distribution(grid_size, grid_size);
    std::cout << "Matrix dimensions: " << heat_grid.get_rows() << "x" << heat_grid.get_cols() << std::endl;
    // solver = Solver(&heat_grid, 0.0);
    begin = std::chrono::steady_clock::now();
    solver.jacobi_iterate_2(1000);
    end = std::chrono::steady_clock::now();
    std::cout << "Time difference = " << std::chrono::duration_cast<std::chrono::microseconds>(end - begin).count() << "[µs]" << std::endl;
    // std::cout << "Time difference = " << std::chrono::duration_cast<std::chrono::nanoseconds> (end - begin).count() << "[ns]" << std::endl;
    // viz.animate_iteration(heat_grid, 1000, 1000);

    return 0;
}