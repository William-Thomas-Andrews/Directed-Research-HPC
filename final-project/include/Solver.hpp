#pragma once

#include <iostream>
#include <vector>
#include <random>
#include <barrier>

#include "Matrix.hpp"
#include "HeatVisualizer.hpp"



class Solver {        
    public:
        Solver();
        ~Solver();
        void jacobi_1(Matrix& grid);
        void jacobi_iterate_1(Matrix& grid, int iterations);
        void jacobi_2(Matrix& grid, Matrix& prev, int index);
        void jacobi_iterate_2(Matrix& grid, int iterations);
        void gauss_seidel_1(Matrix& grid);
        // void gauss_seidel_2();
        void gauss_seidel_iterate_1(Matrix& grid, int iterations);
        // void gauss_seidel_iterate_2(int iterations);
};