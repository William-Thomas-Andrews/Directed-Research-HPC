#include "Matrix.hpp"
#include "HeatVisualizer.hpp"
#include <cmath>

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
        M(i, cols - 1) = 0.0;
    }
    for (int j = 0; j < cols; ++j) {
        M(0, j) = 0.0;
        M(rows - 1, j) = 0.0;
    }

    return M;
}

int main() {
    // Create a sample heat distribution matrix
    int grid_size = 50;
    Matrix heat_grid = create_initial_heat_distribution(grid_size, grid_size);

    std::cout << "Matrix dimensions: " << heat_grid.get_rows() << "x" << heat_grid.get_cols() << std::endl;

    // Create visualizer and configure
    HeatVisualizer viz;
    viz.set_colormap("hot")
       .set_title("Initial Heat Distribution")
       .set_colorbar(true);

    // Save heatmap to file (works on headless systems)
    viz.heatmap(heat_grid);
    viz.save("heat_heatmap.png");
    std::cout << "Saved heat_heatmap.png" << std::endl;

    // Save surface plot to file
    viz.set_title("Heat Distribution (3D Surface)");
    viz.surface(heat_grid);
    viz.save("heat_surface.png");
    std::cout << "Saved heat_surface.png" << std::endl;

    // Save contour plot
    viz.set_title("Heat Distribution (Contour)");
    viz.contour(heat_grid);
    viz.save("heat_contour.png");
    std::cout << "Saved heat_contour.png" << std::endl;

    return 0;
}