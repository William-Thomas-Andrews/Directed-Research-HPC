#include <climits>

#include "Solver.hpp"

Solver::Solver() {}

Solver::Solver(Matrix* matrix, float alpha) {
    Solver::matrix = matrix;
}

Solver::~Solver() {}

void Solver::iterate(int iterations) {
    for (int i = 0; i < matrix->get_rows(); i++) {
        for (int j = 0; j < matrix->get_cols(); j++) {
            (*matrix)(i, j) = 0.0;
        }
    }
}