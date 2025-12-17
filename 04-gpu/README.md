# GPU Computing and CUDA Programming

## Abstract
This project investigates GPU acceleration techniques using CUDA to harness the massive parallel processing power of graphics processing units. Building upon previous optimizations in **02-simd** and **03-multicore**, I explore how GPU architecture can dramatically accelerate computationally intensive operations.

---

## 1. Introduction

GPUs contain thousands of cores capable of executing operations in parallel, making them ideal for data-parallel workloads. This project implements GPU-accelerated algorithms using CUDA to compare performance against CPU-based implementations.

**Objective**: Measure GPU computing performance characteristics and understand the trade-offs between CPU and GPU execution for matrix multiplication.

---

## 2. Background

Relevant GPU computing concepts:

- **GPU Architecture**: Unlike CPUs with few fast cores optimized for sequential execution, GPUs have thousands of smaller cores designed for massive parallelism, ideal for data-parallel workloads.

- **NVIDIA CUDA**: A parallel computing platform and programming model that provides direct access to the GPU's instruction set and computational elements for executing compute kernels.

- **Thread Hierarchy**: CUDA organizes threads into a three-level hierarchy (Grid → Thread Block → Warp → Thread) for efficient coordination and resource management.

- **Coalesced Memory Access**: Memory access pattern where consecutive threads access consecutive memory locations, maximizing memory bandwidth by leveraging spatial locality.

- **Warp Divergence**: Performance degradation that occurs when threads within a warp take different execution paths due to conditionals, forcing serialized execution.

- **Memory Hierarchy**: GPUs use multiple memory types with different speeds and scopes—global memory (large, slow), shared memory (small, fast, block-scoped), and registers (fastest, thread-private).

---

## 3. Methodology

### 3.1 Implementation Details

Five GPU implementations were developed and compared against CPU baselines:

1. **Basic Double Precision**: Straightforward CUDA kernel with one thread per output element
2. **Vectorized Double Precision**: Optimized kernel using memory coalescing and tiling
3. **cuBLAS Double Precision**: NVIDIA's optimized BLAS library (double precision)
4. **cuBLAS Single Precision**: NVIDIA's optimized BLAS library (single precision)
5. **Autotuned Single Precision**: Custom kernel with autotuned block sizes and memory patterns

All implementations include host-to-device and device-to-host memory transfers in timing measurements.

### 3.2 Experimental Setup

- **GPU**: NVIDIA GPU with CUDA support
- **CUDA Version**: nvcc with `-O3` optimization flags
- **Host CPU**: Linux system with AVX512 support (for comparison)
- **Test Sizes**: Focused on large matrices (2048×2048) where GPU overhead is amortized

### 3.3 Measurement Method

- **Timing**: Includes complete GPU workflow (memory allocation, host-to-device transfer, kernel execution, device-to-host transfer)
- **Correctness**: Results validated against CPU naive implementation
- **Averaging**: Multiple runs per configuration for consistent measurements

---

## 4. Results

### 4.1 Timing Comparison (smaller sizes for GPU are trivial because they are just made up of overhead)
<!-- | Small-size Implementation | Size | Time (seconds) | Speedup |
|----------------|-------|-----------|----------|
| Naive | 512 | 0.0502406 | 1.0× |
| Blocked | 512 | 0.0276674 | 1.81× |
| AVX512 Standard | 512 | 0.0275946 | 1.82× |
| AVX512 Blocked | 512 | 0.0234944 | 2.14× |
| OpenMP Parallel | 512 | 0.0174016 | 2.89x |
| OpenMP Parallel AVX | 512 | 0.0038226 | 13.14x |
| OpenMP Parallel AVX [Optimized] | 512 | 0.0040513 | 12.40x |
| MPI | 512 | 0.2530673 | 0.198x |
| Basic double precision GPU matrix multiply | 512 | 0.0538293 |  |
| Vectorized double precision GPU matrix multiply | 512 | 0.0377586 |  |
| cuBLAS double precision GPU matrix multiply | 512 | 0.0408056 |  |
| cuBLAS single precision GPU matrix multiply | 512 | 0.0008596 |  |
| Autotuned single precision GPU matrix multiply | 512 | 0.001079 |  |

| Med - size Implementation | Size | Time (seconds) | Speedup |
|----------------|-------|-----------|----------|
| Naive | 1024 | 0.535251 | 1.0× |
| Blocked | 1024 | 0.28431 | 1.88× |
| AVX512 Standard | 1024 | 0.244953 | 2.19× |
| AVX512 Blocked | 1024 | 0.184856 | 2.90× |
| OpenMP Parallel | 1024 | 0.2506426 | 2.14x |
| OpenMP Parallel AVX | 1024 | 0.0185923 | 28.78x |
| OpenMP Parallel AVX [Optimized] | 1024 | 0.0152996 | 34.98x |
| MPI | 1024 | 1.420177 | 0.38x | -->


| Large-size Implementation | Size | Time (seconds) | Speedup |
|----------------|-------|-----------|----------|
| Naive | 2048 | 7.0163024 | 1.0× |
| Blocked | 2048 | 3.4543676 | 2.03× |
| AVX512 Standard | 2048 | 2.7734796 | 2.53× |
| AVX512 Blocked | 2048 | 1.8161702 | 3.86× |
| OpenMP Parallel | 2048 | 3.350301 | 2.09x |
| OpenMP Parallel AVX | 2048 | 0.135186 | 51.9x |
| OpenMP Parallel AVX [Optimized] | 2048 | 0.077070 | 91.03x |
| MPI | 2048 | 9.5215043 | 0.74x |
| Basic double precision GPU matrix multiply | 2048 | 0.0538293 | 130.34x |
| Vectorized double precision GPU matrix multiply | 2048 | 0.0377586 | 185.82x |
| cuBLAS double precision GPU matrix multiply | 2048 | 0.0408056 | 171.94x |
| cuBLAS single precision GPU matrix multiply | 2048 | 0.0008596 | 8162.28x |
| Autotuned single precision GPU matrix multiply | 2048 | 0.001079 | 6502.60x |

### 4.2 Observations

1. **Precision Matters**: Single precision GPU implementations (8162× speedup) vastly outperform double precision (130-185×), demonstrating the GPU's architectural preference for FP32 operations.

2. **GPU vs. Best CPU**: Even basic GPU implementations (130×) exceed the best CPU result (91× from OpenMP+AVX512), with optimized GPU kernels reaching 8000× speedup.

3. **cuBLAS Performance**: NVIDIA's cuBLAS library is highly optimized, achieving near-peak performance with minimal code complexity compared to custom kernels.

4. **Memory Transfer Overhead**: Times include data transfers, yet GPUs still dominate for large matrices. Smaller sizes (commented out) show overhead can negate benefits.

5. **Diminishing Returns**: The jump from basic to vectorized GPU kernels (130× to 185×) is modest compared to the CPU optimization journey, showing GPUs are naturally well-suited to this workload.


---

## 5. Discussion

GPUs represent a paradigm shift for compute-intensive workloads. Key insights:

**When to Use GPUs**:
- Large-scale data-parallel problems where thousands of independent operations can execute simultaneously
- Applications where computational intensity justifies data transfer overhead
- Workloads compatible with single precision arithmetic (machine learning, graphics, many scientific simulations)

**Performance Factors**:
- Memory transfer overhead is significant but amortized for large problems
- Precision choice dramatically impacts performance (FP32 vs FP64)
- Library implementations (cuBLAS) often outperform hand-written kernels unless highly specialized
- GPU memory hierarchy optimization is critical but less manual tuning required than CPU

**CPU vs. GPU Trade-offs**:
- CPUs excel at: small datasets, complex control flow, latency-sensitive tasks, double precision requirements
- GPUs excel at: large datasets, simple arithmetic operations, throughput-oriented workloads, FP32 operations

---

## 6. Conclusion

This project demonstrates GPU computing's transformative impact on parallel workloads. The 8162× speedup achieved with cuBLAS single precision represents a 90× improvement over the best CPU implementation (OpenMP+AVX512), validating GPUs for matrix operations.

The progression from naive CPU (7.0s) to optimized GPU (0.0009s) for 2048×2048 matrices shows the full potential of hardware-aware optimization. However, the commented results reveal that overhead makes GPUs inefficient for small problems—understanding this crossover point is essential for real-world applications.


---

## 7. Future Work

- Multi-GPU implementations
- Tensor cores and mixed precision
- CUDA streams and concurrent execution
- Comparison with OpenCL and other GPU frameworks

---
