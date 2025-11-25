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
void Solver::jacobi_2() {
    if (grid->get_rows() < 3 or grid->get_cols() < 3) {
        std::cout << "Dimensions too small, no iterations performed." << std::endl; 
        return;
    }
    Matrix temp = *grid; // copy assignment


    for(int i = 0; i < size_Of_Cluster; i++) {
        // if(i == process_Rank){
        //     // printf("Hello World from process %d of %d\n", process_Rank, size_Of_Cluster);
        // }
        // solve()
        MPI_Barrier(MPI_COMM_WORLD);
    }
    
    // omp_set_num_threads(32);
    // #pragma omp unroll
    // // #pragma omp parallel for
    // for (int i = 1; i < temp.get_rows()-1; i++) {
    //     for (int j = 1; j < temp.get_cols()-1; j++) {
    //         (*grid)(i, j) = 0.25 * ((temp)(i, j-1) + (temp)(i, j+1) + (temp)(i-1, j) + (temp)(i+1, j));
    //     }
    // }
    // // std::cout << omp_get_thread_num() << std::endl;
    // std::cout << omp_get_num_threads() << std::endl;
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
    HeatVisualizer viz;
    for (int i = 0; i < iterations; i++) {
        this->jacobi_2();
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