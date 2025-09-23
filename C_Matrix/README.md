# C Matrix Multiplication Performance Analysis

A comprehensive C implementation comparing various matrix multiplication algorithms and optimizations as part of high-performance computing research.

## Overview

This project implements and benchmarks multiple matrix multiplication strategies to analyze their performance characteristics, cache efficiency, and parallelization potential. It includes serial algorithms, multithreaded implementations, blocking techniques, and compiler optimization analysis.

## Features

### Matrix Multiplication Implementations

- **MM1 (Serial)**: Standard triple-nested loop (i-j-k order)
- **MM2 (Serial)**: Cache-optimized loop order (i-k-j)
- **MM3 (Serial)**: Alternative loop order (j-i-k)
- **MM4 (Parallel)**: Row-wise parallelization with 2 threads
- **MM5 (Parallel)**: Column-wise parallelization with 2 threads
- **MM6 (Parallel)**: Column-wise parallelization with 4 threads
- **MM7 (Block)**: Custom 2x2 block implementation
- **B&OH Block**: Bryant & O'Hallaron optimized block algorithm

### Key Features

- High-precision arithmetic using `long double`
- Comprehensive correctness verification between implementations
- Performance timing and comparison
- Memory-efficient matrix operations
- Thread-safe parallel implementations
- Configurable compiler optimizations




## Building and Running

### Prerequisites

- CMake 3.22.1 or higher
- GCC with C23 support
- pthread library
- (Optional) Valgrind for memory analysis

### Quick Start

```bash
# Configure and build
./scripts/configure.sh
./scripts/build.sh

# Run performance tests
./scripts/run.sh

# Or build and run in one step
./scripts/build_run.sh
```

### Manual Build

```bash
mkdir -p build && cd build
cmake ..
make
./bin/MATRIX
```

## Performance Analysis

The program tests 1000x1000 matrix multiplication across all implementations and reports:

- Execution time for each algorithm
- Correctness verification against the reference implementation
- Relative performance comparison

### Sample Output

```
Here is the Matrix Multiplication result:
                          This function call took 2.845123000 ms
MM1 and B&OH Solution are the same! This function call took 0.891234000 ms
MM1 and Block Implementation are the same! This function call took 1.234567000 ms
MM1 and MM2 are the same! This function call took 3.123456000 ms
...
```

## Compiler Optimizations

The project includes carefully tuned optimization flags in `CMakeLists.txt`:

```cmake
set(CMAKE_C_FLAGS_RELEASE "-O2 -march=native -ffast-math")
```

- `-O2`: Balanced optimization level
- `-march=native`: CPU-specific instruction optimization
- `-ffast-math`: Aggressive floating-point optimizations

## Research Applications

This implementation is designed for:

- **Cache Performance Analysis**: Comparing different loop orders and blocking strategies
- **Parallel Computing Research**: Evaluating threading overhead and scalability
- **Compiler Optimization Studies**: Understanding the impact of various optimization flags
- **Algorithm Comparison**: Benchmarking against optimized reference implementations

<!-- ## Future Work

Current TODO items include:

- NUMA-aware memory allocation
- Extended block sizes (4+ blocks) with multithreading
- Thread scaling analysis
- Process vs. thread distribution investigation
- Fork-based parallelization comparison -->

## Technical Details

### Matrix Structure

```c
struct Matrix {
    long double* data_array;  // Contiguous memory layout
    int size, rows, cols;     // Dimensions and total elements
};
```

### Memory Management

- Efficient contiguous memory allocation (extremely lightweight too)
- Cache-friendly data access patterns
- Proper cleanup and error handling
- Memory leak detection support

## Building for Different Configurations

```bash
# Debug build with symbols
cmake -DCMAKE_BUILD_TYPE=Debug ..

# Release build with optimizations
cmake -DCMAKE_BUILD_TYPE=Release ..

# Memory checking
./scripts/memcheck.sh
```

<!-- ## Contributing

This project is part of ongoing HPC research. Key areas for contribution:

1. Additional parallelization strategies
2. SIMD/vectorization optimizations
3. Memory bandwidth analysis
4. Cross-platform performance comparison -->

<!-- ## License

Part of the Directed-Research-HPC project for academic research purposes. -->