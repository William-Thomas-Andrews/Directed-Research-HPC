#include <climits>
#include <chrono>
#include <thread>
#include <vector>
#include "omp.h" 
#include "mpi.h"

#include "Solver.hpp"

Solver::Solver() {}

Solver::~Solver() {}

// Standard Jacobi
void Solver::jacobi_1(Matrix& grid) {
    if (grid.get_rows() < 3 or grid.get_cols() < 3) {
        std::cout << "Dimensions too small, no iterations performed." << std::endl; 
        return;
    }
    Matrix temp = grid; // copy assignment
    for (int i = 1; i < temp.get_rows()-1; i++) {
        for (int j = 1; j < temp.get_cols()-1; j++) {
            grid(i, j) = 0.25 * (temp(i, j-1) + temp(i, j+1) + temp(i-1, j) + temp(i+1, j));
        }
    }
}

// Standard Jacobi iteration
void Solver::jacobi_iterate_1(Matrix& grid, int iterations) {
    // HeatVisualizer viz;
    for (int i = 0; i < iterations; i++) {
        this->jacobi_1(grid);
        // if (i % 10 == 0) {
        //     viz.animate_iteration(grid, i, 1000);
        // }
    }
}

// Parallel Jacobi
void Solver::jacobi_2(Matrix& grid, Matrix& prev, int index) {
    if (grid.get_rows() < 3 or grid.get_cols() < 3 or prev.get_rows() < 3 or prev.get_cols() < 3) {
        std::cout << "Dimensions too small, no iterations performed." << std::endl; 
        return;
    }
    int rows = prev.get_rows() / 5;
    int cols = prev.get_cols() / 5;
    for (int i = (index / 5) * rows; i < ((index / 5) * rows) + rows; i++) {
        for (int j = ((index) % 5) * cols; j < (((index) % 5) * cols) + cols; j++) {
            if (i == 0 or j == 0 or i >= prev.get_rows()-1 or j >= prev.get_cols()-1) {
                continue;
            }
            grid(i, j) = 0.25 * (prev(i, j-1) + prev(i, j+1) + prev(i-1, j) + prev(i+1, j));
        }
    }
}


// Parallel Jacobi iteration
void Solver::jacobi_iterate_2(Matrix& grid, int iterations) {
    const int num_threads = 25;
    std::barrier barrier_obj(num_threads);
    std::vector<std::thread> threads;
    Matrix prev = grid; // copy assignment
    auto job = [&](int index) {
        for (int i = 0; i < iterations; i++) {
            // if (index == 0) prev = grid; // copy assignment
            barrier_obj.arrive_and_wait();
            if (i % 2 == 1) {
                Solver::jacobi_2(prev, grid, index);
            } 
            else {
                Solver::jacobi_2(grid, prev, index);
            }
            barrier_obj.arrive_and_wait();
        }
    };
    for (int i = 0; i < num_threads; i++) {
        threads.emplace_back(job, i);
    }
    for (int j = 0; j < num_threads; j++) {
        threads[j].join();
    }
}


// Standard Gauss-Seidel
void Solver::gauss_seidel_1(Matrix& grid) {
    if (grid.get_rows() < 3 or grid.get_cols() < 3) {
        std::cout << "Dimensions too small, no iterations performed." << std::endl; 
        return;
    }
    for (int i = 1; i < grid.get_rows()-1; i++) {
        for (int j = 1; j < grid.get_cols()-1; j++) {
            grid(i, j) = 0.25 * (grid(i, j-1) + grid(i, j+1) + grid(i-1, j) + grid(i+1, j));
        }
    }
}

// Standard Gauss-Seidel iteration algorithm
void Solver::gauss_seidel_iterate_1(Matrix& grid, int iterations) {
    // HeatVisualizer viz;
    for (int i = 0; i < iterations; i++) {
        this->gauss_seidel_1(grid);
        // if (i % 10 == 0) {
        //     viz.animate_iteration(grid, i, 1000);
        // }
    }
}