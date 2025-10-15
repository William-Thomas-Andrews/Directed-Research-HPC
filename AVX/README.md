# Project Title

## Abstract
> This project seeks to improve upon standard C matrix multiplication algorithms shown in the **C_Matrix** project by using the AVX-512 instruction set. 
> I used these instructions to SIMD vectorize my matrix operations in various ways to efficiently use cache locality and fully utilize the comparative speed of registers. > As a result, I did infact create algorithms that are faster than previous tries.

---

## 1. Introduction

- Matrix multiplication has an extremely wide variety of applications, notably in: data transformations in computer graphics, machine learning, physics, and engineering. Neural networks are computationally mostly matrix multiplication, with some nonlinear function application and derivatives.
- I seek to use the register based AVX-512 instruction set to speed up otherwise cache-heavy matrix algorithms that I have written in the **C_Matrix** project.
- I also inspect in detail blocking since it had the best performance of my original functions from **C_Matrix**.
- Objective: To measure how blocking and AVX-512 affect performance compared to a naive implementation.

---

## 2. Background

- Relevant computer architecture concepts:
  - __Cache Hierarchy__: Modern computers contain a hierarchy of L1d, L1i, L2, and L3 caches. The L1d cache (L1 data cache) stores recently used data so the CPU can access it almost instantly in the least clock cycles possible. The L1i cache (L1 instruction cache) has a similar role but for accessing CPU instructions to execute tasks very quickly. The L2 cache is larger than the L1 cache but has slower access time. The L3 cache is even larger but has even slower access time.
  - For sizes, the computer I used has 384 KiB in the L1d cache, 256 KiB in the L1i cache, 16 MiB in the L2 cache, and 22.5 MiB in the L3 cache. 
  - __Memory locality__:
  - __SIMD execution__:
  - __AVX-512 Intrinsics__:
  - __Cache indexing__:
  - __Cache thrashing__:


---

## 3. Methodology

### 3.1 Implementation Details
- Describe the algorithms implemented (naive, blocked, SIMD, etc.). First I implemented AVX-512 intrinsics by simply vectorizing my standard matrix function by going through the last loop in increments of 8 (because 512 bits = 8 doubles) and loading 8 doubles into a **__m512** type vector from the rows, and the same for another **__m512** type vector.
- The load instruction I used was:
> __m512d _mm512_loadu_pd (void const* mem_addr)
- Since reading data into a register for a **__m512** vector reads 512 bits contigously onward from the pointer it was passed, the standard matrix multiplication *i-j-k* function would not work because matrix B has its data read by column, so I had to transpose the matrix to read matrix B's data contiguously.
- I created an accumulator vector called *acc* that was set to the 0 vector everytime the innermost loop was about to run with the instruction:
> __m512d _mm512_setzero_pd ()
- This accumulator vector was used to accumulate the vectors that resulted from each iteration of the innermost loop and be added to as a single entry by summing the elements with this instruction:
> double _mm512_reduce_add_pd (__m512d a)
- In the loop, for each iteration the accumulator was updated with this instruction:
> __m512d _mm512_fmadd_pd (__m512d a, __m512d b, __m512d c)
- This instruction above takes in vectors *a* and *b* and pairwize multiplies them, and adds them to vector *c*. I simply put *acc* as the argument for vector *c* and assigned what this operation returns to be *acc*.
- That concludes our basic intrinsic operations, which tell the computer with machine code to put our vectors into registers and perform the standard matrix operations I have shown above.
- I used the keyword *static* for this function to limit the scope to internal use to try to help the compiler know that this function has a specific use.
- I also used the GNU compiler extension:  *\_\_attribute__((always_inline))*. This directive instructs the compiler to inline the function regardless of any other factors.
- Below is the standard avx matrix multiplication function with its comments removed:

```c
static __attribute__((always_inline)) inline void 
avx_matrix_multiply(struct Matrix* result, struct Matrix* A, struct Matrix* B) {
    int A_cols = A->cols; int B_cols = B->cols; int A_rows = A->rows; int B_rows = B->rows;

    __m512d vec_1, vec_2, acc;
    
    for (int i = 0; i < A_rows; i++) {
        for (int j = 0; j < B_rows; j++) {
            acc = _mm512_setzero_pd();
            for (int k = 0; k < A_cols; k+=8) {
                vec_1 = _mm512_loadu_pd(&A->data_array[i * A_cols + k]);
                vec_2 = _mm512_loadu_pd(&B->data_array[j * A_cols + k]); 
                acc = _mm512_fmadd_pd(vec_1, vec_2, acc);
            }
            result->data_array[i * B_rows + j] = _mm512_reduce_add_pd(acc);
        }
    }
}
```

### 3.2 Experimental Setup
- I used my standard school computer: a x86_64 Intel(R) Xeon(R) w3-2435, with 46 bit physical address size, and 57 bit virtual address size.
- This computer has an L1 data cache of size 384 KiB (8 instances), an L1 instruction cache of size 256 KiB (8 instances), an L2 cache of size 16 MiB (8 instances), and an L3 cache of size 22.5 MiB (1 instance).
- I used **GCC** as my compiler with two flags: *-O3* and *-mavx512f*.
- This computer is an Ubunut 22.04.3 OS.
- Test sizes: 512×512, 1024×1024, 2048×2048 matrices.

### 3.3 Measurement Method
- Timing was done with the `clock()` function.
- Correctness was verified with my comparision function:
> static inline int cmp_matrix(struct Matrix *A, struct Matrix *B)
- To create an efficient final number, I averaged 5 runs each.

---

## 4. Results

### 4.1 Timing Comparison
| Small-size Implementation | Size | Time (s) | Speedup |
|----------------|-------|-----------|----------|
| Naive | 512 | 1.540 | 1.0× |
| Blocked | 512 | 0.370 | 4.1× |
| AVX512 Standard | 512 | 0.220 | 7.0× |
| AVX512 Blocked | 512 | 0.220 | 7.0× |

| Medium-size Implementation | Size | Time (s) | Speedup |
|----------------|-------|-----------|----------|
| Naive | 1024 | 1.540 | 1.0× |
| Blocked | 1024 | 0.370 | 4.1× |
| AVX512 Standard | 1024 | 0.220 | 7.0× |
| AVX512 Blocked | 1024 | 0.220 | 7.0× |

| Large-size Implementation | Size | Time (s) | Speedup |
|----------------|-------|-----------|----------|
| Naive | 2048 | 1.540 | 1.0× |
| Blocked | 2048 | 0.370 | 4.1× |
| AVX512 Standard | 2048 | 0.220 | 7.0× |
| AVX512 Blocked | 2048 | 0.220 | 7.0× |

### 4.2 Observations
- Describe trends (e.g., blocking improves cache reuse)
- Note when performance plateaus or decreases
- Comment on the impact of register usage, alignment, or memory access patterns

### 4.3 Visualizations (Optional)
Insert graphs or charts:
- Execution time vs. matrix size
- Cache misses vs. implementation
- Roofline or speedup plots

---

## 5. Discussion
Interpret your results — this is where you show understanding, not just data.

- Why does one method outperform another?
- Were there trade-offs (register pressure, cache thrashing, etc.)?
- How does this relate to known performance models (e.g., roofline model, memory bandwidth limits)?
- If something unexpected happened, explain your reasoning or hypotheses.

---

## 6. Conclusion
Summarize your key findings and insights.

- What did you learn about optimization or hardware behavior?
- What would you try next (e.g., parallelization, prefetching, fused kernels)?
- State the main performance takeaway.

---

## 7. Future Work
Outline possible next steps.

- OpenMP or CUDA parallelization  
- Deeper blocking hierarchies (L1/L2/L3 blocking)
- Profiling with performance counters
- Comparing to BLAS libraries
- Examining loop unrolling and its effects

---

## 8. References
List any resources used for theory, implementation, or inspiration.

- Intel Intrinsics Guide  
- “Optimizing Matrix Multiplication using Blocked Algorithms” — [Author, Year]  
- Hennessy & Patterson, *Computer Architecture: A Quantitative Approach*  
- BLIS Framework documentation  
- NumPy source or OpenBLAS documentation

---

<!-- ## Appendix (Optional)
Include:
- Detailed pseudocode
- Full benchmark logs
- Extended tables or graphs -->
