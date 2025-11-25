#pragma once

#include <iostream>
#include <vector>
#include <random>

#include "Matrix.hpp"
#include "HeatVisualizer.hpp"



class Solver {
    private:
        Matrix* grid;
        
    public:
        Solver();
        Solver(Matrix* matrix, float alpha);
        ~Solver();
        void jacobi_1();
        void jacobi_2();
        void jacobi_iterate_1(int iterations);
        void jacobi_iterate_2(int iterations);
        void gauss_seidel_1();
        // void gauss_seidel_2();
        void gauss_seidel_iterate_1(int iterations);
        // void gauss_seidel_iterate_2(int iterations);
};