import numpy as np
import time
np.__config__.show()
from numba import njit, prange

@njit(parallel=True, fastmath=True)
def matmul(A, B):
    n = A.shape[0]
    C = np.zeros((n, n))
    for i in prange(n):
        for j in range(n):
            for k in range(n):
                C[i, j] += A[i, k] * B[k, j]
    return C

# Define the dimensions of the matrices
size = 2048
rows_A = size
cols_A = size
rows_B = size
cols_B = size

# Create two random matrices
matrix_A = np.random.rand(rows_A, cols_A)
matrix_B = np.random.rand(rows_B, cols_B)

# Perform matrix multiplication and measure the time
start_time = time.time()
result_matrix = np.dot(matrix_A, matrix_B)  # or matrix_A @ matrix_B
end_time = time.time()

# Print the execution time
print(f"Matrix multiplication of {rows_A}x{cols_A} and {rows_B}x{cols_B} matrices took: {end_time - start_time:.4f} seconds")

# Optionally, print a small portion of the result matrix to verify
# print("\nFirst 5x5 block of the result matrix:")
# print(result_matrix[:5, :5])

# matmul(matrix_A, matrix_B)