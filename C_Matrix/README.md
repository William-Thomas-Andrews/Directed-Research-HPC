# C Matrix Multiplication Performance Analysis

A comprehensive C implementation comparing various matrix multiplication algorithms and optimizations as part of high-performance computing directed study.

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


## Notes

### NUMA (non-uniform memory access)

#### How NUMA works

- When a processor looks for data at a certain memory address, it first looks in the L1 cache on the microprocessor. Then it moves to the larger L2 cache chip and finally to a third level of cache (L3). The NUMA configuration provides this third level. If the processor still cannot find the data, it will look in the remote memory located near the other microprocessors.

- Each of these clusters is viewed by NUMA as a node in the interconnection network. NUMA maintains a hierarchical view of the data on all nodes. Data is moved on the bus between the clusters using a scalable coherent interface. SCI coordinates cache coherence (consistency) across the nodes of the multiple clusters in the NUMA architecture.

### Compiler Flags

- The B&OH function only is heavily sped up by -ffast-math. This is because:
- My blocked function is not affected by -ffast-math. This is because:
- The other functions are unaffected, except MM2 which was the slowest in the first place. This function seemingly has its slowness amplified due to -ffast-math. This is because:
- The flag -flto keeps the parallel and MM2 the same, but slows everything else down by a decent bit. This is because:

### Linux Perf

- Use Linux 'perf' to help with OS and process usage viewing

### Questions and Answers

#### Will the OS automatically distribute work through processes or keep on one process?

- The OS will not distribute matrix work through processes unless you tell it to. It will keep it all on one process unless you specify other behavior with something like OpenMP.
- However, the OS can and often does change processes like these and their threads throughout the cores for reasons due to scheduling: load balancing, fairness, power management/thermal, NUMA awareness, and preemption with high priority tasks removing your task from the queue.




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

- Efficient contiguous memory allocation
- Extremely lightweight
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