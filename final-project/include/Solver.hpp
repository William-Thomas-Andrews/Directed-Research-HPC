#pragma once

#include <iostream>
#include <vector>
#include <random>

#include "Matrix.hpp"


class Solver {
    private:
        Matrix* matrix;
        
    public:
        Solver();
        Solver(Matrix* matrix, float alpha);
        ~Solver();
        void iterate(int iterations);
};