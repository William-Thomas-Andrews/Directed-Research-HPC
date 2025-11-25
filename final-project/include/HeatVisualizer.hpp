#pragma once

#include <matplot/matplot.h>
#include <vector>
#include <string>
#include <thread>

#include "Matrix.hpp"
#include "Solver.hpp"


class HeatVisualizer {
private:
    bool show_colorbar;
    std::string colormap_name;
    std::string title;

public:
    HeatVisualizer();

    // Configuration methods (chainable)
    HeatVisualizer& set_colorbar(bool show);
    HeatVisualizer& set_colormap(const std::string& name);
    HeatVisualizer& set_title(const std::string& t);

    // Visualization methods
    void heatmap(const Matrix& M);
    void heatmap(const Matrix& M, double min_val, double max_val);

    // Surface plot (3D visualization)
    void surface(const Matrix& M);
    void surface(const Matrix& M, double min_val, double max_val);

    // Contour plot
    void contour(const Matrix& M);

    // Save current figure to file
    void save(const std::string& filename);

    // Show the plot (blocking)
    void show();

    // Animation support for iterative solvers
    void animate_iteration(const Matrix& M, int iteration, int max_iterations);

    // Utility: Convert Matrix to matplot-compatible 2D vector
    static std::vector<std::vector<double>> matrix_to_2d(const Matrix& M);
};
