# High-Performance Computing Research Repository

A collection of computational performance analysis projects focusing on algorithm optimization, parallel computing, and hardware-software interaction studies.

## Repository Overview

This repository contains multiple independent research projects exploring various aspects of high-performance computing, with emphasis on:

- **Algorithm Performance Analysis**: Comparative studies of different computational approaches
- **Parallel Computing Strategies**: Threading, process distribution, and scalability analysis
- **Memory Hierarchy Optimization**: Cache efficiency, NUMA awareness, and memory access patterns
- **Compiler Optimization Impact**: Effects of various compilation flags and strategies

## Current Projects



### [Project 1: High Performance Matrix Framework](./01-matrix/)
**Matrix Multiplication Performance Analysis**

Comprehensive C implementation comparing 8 different matrix multiplication algorithms including serial implementations, parallel strategies with threading, and optimized block algorithms. Features high-precision arithmetic, correctness verification, and detailed performance benchmarking.

**Key Features:**
- Multiple algorithm implementations (serial, parallel, blocked)
- Cache optimization analysis
- Thread-safe parallel processing
- Compiler optimization studies
- Memory-efficient operations
- Extremely fast blocked matrix algorithms


### [Project 2: AVX Instruction Set Implementation, SIMD Vectorization, and Cache Properties Analysis](./02-simd/)
**Matrix Multiplication Performance Analysis**

An implementation that seeks to improve upon standard C matrix multiplication algorithms shown in the **01-matrix** project by using the AVX-512 instruction set. I used these instructions to SIMD vectorize my matrix operations in various ways to efficiently use cache locality and fully utilize the comparative speed of registers. As a result, I did infact create algorithms that are faster than previous tries.

**Key Features:**
- AVX-512 Intel instruction set
- Cache architecture analysis
- Algorithm benchmarking
- Cache vs Single Instruction Multiple Data (SIMD) vector register perfromance analysis

## Getting Started

Each subproject contains its own build system and documentation. Navigate to individual project directories for specific instructions.

### Prerequisites
- CMake 3.22.1 or higher
- GCC with modern C standard support
- pthread library
- (Optional) Valgrind for memory analysis

## Research Applications

This repository supports research in:

- **Computational Performance Engineering**: Understanding algorithm efficiency across different hardware
- **Parallel Computing Education**: Demonstrating threading concepts and trade-offs
- **Systems Programming**: Low-level optimization techniques and memory management
- **Academic Benchmarking**: Standardized performance comparison methodologies

## Future Subprojects

Additional projects planned for this repository include:

- **GPU Computing Studies**: CUDA/OpenCL performance analysis
- **Network Computing**: MPI and distributed algorithm implementations
- **Memory Management**: Custom allocator performance comparison
- **SIMD Optimization**: Vectorization strategy analysis

## Repository Structure

```
Directed-Research-HPC/
├── 01-matrix/           # Matrix multiplication performance study
│   ├── build/            # Build artifacts
│   ├── include/          # Header files
│   ├── scripts/          # Build and run automation
│   ├── src/              # Source implementations
│   ├── test/             # Test drivers and validation
│   └── README.md         # Detailed project documentation
├── 02-simd/             # SIMD vectorization with AVX-512
│   ├── build/            # Build artifacts
│   ├── scripts/          # Build and run automation
│   ├── src/              # Source implementations
│   ├── test/             # Test drivers and validation
│   └── README.md         # Detailed project documentation
├── 03-multicore/        # Multi-core parallelization study
│   ├── build/            # Build artifacts
│   ├── scripts/          # Build and run automation
│   ├── src/              # Source implementations
│   ├── test/             # Test drivers and validation
│   └── README.md         # Detailed project documentation
└── README.md            # This file
```

## Contributing

This repository serves as an academic research collection. Each project maintains its own contribution guidelines and research objectives.

## Academic Context

Part of directed research in high-performance computing, focusing on practical performance analysis and optimization techniques for computational algorithms.