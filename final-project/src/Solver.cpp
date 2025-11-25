#include <climits>
#include <chrono>
#include <thread>
#include "omp.h" 
#include "mpi.h"

#include "Solver.hpp"

Solver::Solver() {}

Solver::Solver(Matrix* matrix, float alpha) {
    Solver::grid = matrix;
}

Solver::~Solver() {}

// Standard Jacobi
void Solver::jacobi_1() {
    if (grid->get_rows() < 3 or grid->get_cols() < 3) {
        std::cout << "Dimensions too small, no iterations performed." << std::endl; 
        return;
    }
    Matrix temp = *grid; // copy assignment
    for (int i = 1; i < temp.get_rows()-1; i++) {
        for (int j = 1; j < temp.get_cols()-1; j++) {
            (*grid)(i, j) = 0.25 * ((temp)(i, j-1) + (temp)(i, j+1) + (temp)(i-1, j) + (temp)(i+1, j));
        }
    }
}

// Parallel Jacobi
void Solver::jacobi_2(Matrix* temp, ) {
    if (grid->get_rows() < 3 or grid->get_cols() < 3) {
        std::cout << "Dimensions too small, no iterations performed." << std::endl; 
        return;
    }
    // Matrix temp = *grid; // copy assignment
    for (int i = 1; i < temp.get_rows()-1; i++) {
        for (int j = 1; j < temp.get_cols()-1; j++) {
            (*grid)(i, j) = 0.25 * ((temp)(i, j-1) + (temp)(i, j+1) + (temp)(i-1, j) + (temp)(i+1, j));
        }
    }
}

// Standard Jacobi iteration
void Solver::jacobi_iterate_1(int iterations) {
    HeatVisualizer viz;
    for (int i = 0; i < iterations; i++) {
        this->jacobi_1();
        // if (i % 10 == 0) {
        //     viz.animate_iteration(*grid, i, 1000);
        // }
    }
}

// Parallel Jacobi iteration
void Solver::jacobi_iterate_2(int iterations) {
    // HeatVisualizer viz;
    const int num_threads = 4;
    std::barrier barrier_obj(num_threads);
    std::vector<std::thread> threads;
    for (int i = 0; i < iterations; i++) {
        Matrix temp = *grid; // copy assignment
        this->jacobi_2(temp);
        // if (i % 10 == 0) {
        //     viz.animate_iteration(*grid, i, 1000);
        // }
    }
    MPI_Finalize();
}

// Standard Gauss-Seidel
void Solver::gauss_seidel_1() {
    if (grid->get_rows() < 3 or grid->get_cols() < 3) {
        std::cout << "Dimensions too small, no iterations performed." << std::endl; 
        return;
    }
    for (int i = 1; i < grid->get_rows()-1; i++) {
        for (int j = 1; j < grid->get_cols()-1; j++) {
            (*grid)(i, j) = 0.25 * ((*grid)(i, j-1) + (*grid)(i, j+1) + (*grid)(i-1, j) + (*grid)(i+1, j));
        }
    }
}

// // Standard Gauss-Seidel
// void Solver::gauss_seidel_2() {
//     if (grid->get_rows() < 3 or grid->get_cols() < 3) {
//         std::cout << "Dimensions too small, no iterations performed." << std::endl; 
//         return;
//     }
//     for (int i = 1; i < grid->get_rows()-1; i++) {
//         for (int j = 1; j < grid->get_cols()-1; j++) {
//             (*grid)(i, j) = 0.25 * ((*grid)(i, j-1) + (*grid)(i, j+1) + (*grid)(i-1, j) + (*grid)(i+1, j));
//         }
//     }
// }

// Standard Gauss-Seidel iteration algorithm
void Solver::gauss_seidel_iterate_1(int iterations) {
    HeatVisualizer viz;
    for (int i = 0; i < iterations; i++) {
        this->gauss_seidel_1();
        // if (i % 10 == 0) {
        //     viz.animate_iteration(*grid, i, 1000);
        // }
    }
}

// // Standard Gauss-Seidel iteration algorithm
// void Solver::iterate_2(int iterations) {
//     HeatVisualizer viz;
//     for (int i = 0; i < iterations; i++) {
//         this->gauss_seidel_1();
//         // if (i % 10 == 0) {
//         //     viz.animate_iteration(*grid, i, 1000);
//         // }
//     }
// }