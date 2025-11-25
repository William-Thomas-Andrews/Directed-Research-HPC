#include <iostream>
#include <iomanip>
#include <sstream>

#include "HeatVisualizer.hpp"

// Helper function to get colormap by name
std::vector<std::vector<double>> get_colormap_by_name(const std::string& name) {
    using namespace matplot;
    if (name == "hot") return palette::hot();
    if (name == "jet") return palette::jet();
    if (name == "parula") return palette::parula();
    if (name == "cool") return palette::cool();
    if (name == "spring") return palette::spring();
    if (name == "summer") return palette::summer();
    if (name == "autumn") return palette::autumn();
    if (name == "winter") return palette::winter();
    if (name == "gray") return palette::gray();
    if (name == "bone") return palette::bone();
    if (name == "copper") return palette::copper();
    if (name == "pink") return palette::pink();
    if (name == "hsv") return palette::hsv();
    // Default to hot
    return palette::hot();
}

HeatVisualizer::HeatVisualizer()
    : show_colorbar(true), colormap_name("hot"), title("Heat Distribution") {}

HeatVisualizer& HeatVisualizer::set_colorbar(bool show) {
    show_colorbar = show;
    return *this;
}

HeatVisualizer& HeatVisualizer::set_colormap(const std::string& name) {
    colormap_name = name;
    return *this;
}

HeatVisualizer& HeatVisualizer::set_title(const std::string& t) {
    title = t;
    return *this;
}

std::vector<std::vector<double>> HeatVisualizer::matrix_to_2d(Matrix& M) {
    int rows = M.get_rows();
    int cols = M.get_cols();

    std::vector<std::vector<double>> result(rows, std::vector<double>(cols));

    for (int i = 0; i < rows; ++i) {
        for (int j = 0; j < cols; ++j) {
            result[i][j] = M(i, j);
        }
    }

    return result;
}

void HeatVisualizer::heatmap(Matrix& M) {
    auto data = matrix_to_2d(M);

    auto fig = matplot::figure(true);
    matplot::imagesc(data);
    matplot::colormap(get_colormap_by_name(colormap_name));

    if (show_colorbar) {
        matplot::colorbar();
    }

    matplot::title(title);
    matplot::xlabel("X");
    matplot::ylabel("Y");
}

void HeatVisualizer::heatmap(Matrix& M, double min_val, double max_val) {
    auto data = matrix_to_2d(M);

    auto fig = matplot::figure(true);
    matplot::imagesc(data);
    matplot::colormap(get_colormap_by_name(colormap_name));
    matplot::caxis({min_val, max_val});

    if (show_colorbar) {
        matplot::colorbar();
    }

    matplot::title(title);
    matplot::xlabel("X");
    matplot::ylabel("Y");
}

void HeatVisualizer::surface(Matrix& M) {
    auto data = matrix_to_2d(M);
    int rows = M.get_rows();
    int cols = M.get_cols();

    // Create X and Y meshgrid
    auto [X, Y] = matplot::meshgrid(
        matplot::linspace(0, cols - 1, cols),
        matplot::linspace(0, rows - 1, rows)
    );

    auto fig = matplot::figure(true);
    auto s = matplot::surf(X, Y, data);
    matplot::colormap(get_colormap_by_name(colormap_name));

    if (show_colorbar) {
        matplot::colorbar();
    }

    matplot::title(title);
    matplot::xlabel("X");
    matplot::ylabel("Y");
    matplot::zlabel("Temperature");
    // Let matplot++ auto-scale zlim based on data range
}

void HeatVisualizer::surface(Matrix& M, double min_val, double max_val) {
    auto data = matrix_to_2d(M);
    int rows = M.get_rows();
    int cols = M.get_cols();

    // Find actual min/max values in the data for better visualization
    double actual_min = data[0][0];
    double actual_max = data[0][0];
    for (const auto& row : data) {
        for (double val : row) {
            actual_min = std::min(actual_min, val);
            actual_max = std::max(actual_max, val);
        }
    }

    // Create X and Y meshgrid
    auto [X, Y] = matplot::meshgrid(
        matplot::linspace(0, cols - 1, cols),
        matplot::linspace(0, rows - 1, rows)
    );

    auto fig = matplot::figure(true);
    auto s = matplot::surf(X, Y, data);
    matplot::colormap(get_colormap_by_name(colormap_name));

    // Use actual data range for better visualization
    matplot::caxis({actual_min, actual_max});

    if (show_colorbar) {
        matplot::colorbar();
    }

    matplot::title(title);
    matplot::xlabel("X");
    matplot::ylabel("Y");
    matplot::zlabel("Temperature");
    // Use actual data range instead of fixed min/max for better visualization
    matplot::zlim({actual_min, actual_max});
}

void HeatVisualizer::contour(Matrix& M) {
    auto data = matrix_to_2d(M);
    int rows = M.get_rows();
    int cols = M.get_cols();

    // Create X and Y meshgrid for contourf
    auto [X, Y] = matplot::meshgrid(
        matplot::linspace(0, cols - 1, cols),
        matplot::linspace(0, rows - 1, rows)
    );

    auto fig = matplot::figure(true);
    matplot::contourf(X, Y, data);
    matplot::colormap(get_colormap_by_name(colormap_name));

    if (show_colorbar) {
        matplot::colorbar();
    }

    matplot::title(title);
    matplot::xlabel("X");
    matplot::ylabel("Y");
}

void HeatVisualizer::save(const std::string& filename) {
    matplot::save(filename);
}

void HeatVisualizer::show() {
    matplot::show();
}

void HeatVisualizer::animate_iteration(Matrix& M, int iteration, int max_iterations) {
    this->set_colormap("hot")
    .set_title("Initial Heat Distribution")
    .set_colorbar(true);

    // Save heatmap to file (works on headless systems) with fixed 0-100 range
    this->heatmap(M, 0.0, 100.0);
    this->save("heat_heatmap.png");
    // std::cout << "Saved heat_heatmap.png" << std::endl;

    // Save surface plot to file
    this->set_title("Heat Distribution (3D Surface)");
    this->surface(M, 0.0, 100);
    this->save("heat_surface.png");
    // std::cout << "Saved heat_surface.png" << std::endl;

    // Save contour plot
    // this->set_title("Heat Distribution (Contour)");
    // this->contour(M);
    // this->save("heat_contour.png");
    // std::cout << "Saved heat_contour.png" << std::endl;
    std::cout << " - Iteration " << iteration << "/" << max_iterations << "\n";
    std::this_thread::sleep_for(std::chrono::milliseconds(150));
}
