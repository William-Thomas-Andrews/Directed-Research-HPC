#include <climits>
#include <chrono>
#include <thread>

#include "Solver.hpp"

Solver::Solver() {}

Solver::Solver(Matrix* matrix, float alpha) {
    Solver::matrix = matrix;
}

Solver::~Solver() {}

void Solver::iterate(int iterations) {
    if (matrix->get_rows() < 3 or matrix->get_cols() < 3) {
        std::cout << "Dimensions too small, no iteration performed." << std::endl; 
        return;
    }
    for (int it = 0; it < iterations; it++) {
        for (int i = 1; i < matrix->get_rows()-1; i++) {
            for (int j = 1; j < matrix->get_cols()-1; j++) {
                (*matrix)(i, j) = 0.25 * ((*matrix)(i, j-1) + (*matrix)(i, j+1) + (*matrix)(i-1, j) + (*matrix)(i+1, j));
                // (*matrix)(i, j) = 0;
            }
        }
        std::this_thread::sleep_for(std::chrono::milliseconds(10));
    }
}