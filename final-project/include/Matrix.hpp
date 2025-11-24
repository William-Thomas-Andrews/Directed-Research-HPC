#pragma once

#include <iostream>
#include <vector>
#include <random>



class Matrix {
    private:
        float* matrix_array;
        int size;
        int rows;
        int columns;
        
    public:
        Matrix();
        Matrix(int num_rows, int num_columns);
        Matrix(int num_rows, int num_columns, float lower_bound, float upper_bound);
        Matrix(float item, int num_rows, int num_columns);
        Matrix(const std::vector<float>& data, int num_rows, int num_columns);
        Matrix(float* data, int data_size, int num_rows, int num_columns);
        Matrix(const Matrix& other);
        ~Matrix();

        // Operators
        Matrix& operator=(const Matrix& other);
        Matrix operator+(const Matrix& other);
        Matrix operator-(const Matrix& other);
        Matrix operator*(const Matrix& other);
        Matrix operator/(const Matrix& other);
        bool operator==(const Matrix& other);
        bool operator!=(const Matrix& other);

        std::vector<float> get_data() const ;

        float* get_data_address();

        int get_size();

        std::string get_string();

        float get_element(int row_index, int col_index);
        int get_rows();
        int get_cols();

        float sum_elements();
        float sum_row(int row);

        Matrix Transpose();
        float& operator()(int row_index, int col_index) const ;
        void clear();

        friend Matrix operator+(const Matrix& M, float val);
        friend Matrix operator-(const Matrix& M, float val);
        friend Matrix operator*(const Matrix& M, float val);
        friend Matrix operator/(const Matrix& M, float val);
        friend Matrix operator+(float val, const Matrix& M);
        friend Matrix operator-(float val, const Matrix& M);
        friend Matrix operator*(float val, const Matrix& M);
        friend Matrix operator/(float val, const Matrix& M);

        friend std::ostream& operator<<(std::ostream& os, const Matrix& A);
        friend Matrix dot(const Matrix& A, const Matrix& B);
        friend Matrix transpose(const Matrix& A);
};

std::ostream& operator<<(std::ostream& os, Matrix& A);

Matrix dot(const Matrix& A, const Matrix& B);