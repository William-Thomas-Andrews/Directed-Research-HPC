# MPI Matrix Multiplication

This project implements blocked matrix multiplication using MPI (Message Passing Interface) for distributed computing.

## 1. Overview

The implementation uses a master-worker architecture:
- **Master process (rank 0)**: Distributes work blocks and collects results
- **Worker processes (rank 1-N)**: Perform block matrix multiplications

## 2. Background

As defined in this [tutorial](https://curc.readthedocs.io/en/latest/programming/MPI-C.html), "Message Passing Interface (MPI) is a standard used to allow several different processors on a cluster to communicate with each other." This API is fundamentally designed for interprocess communication, not thread communication. Interprocess communication is often difficult to implement and relatively costly in data transfer, but here we attempt to create an implementation consistent with my matrix multiplication personal HPC research.

The two main functions for sending and receiving data are as follows:

```c
int MPI_Send(void *buf, int count, MPI_Datatype datatype, int dest, int tag, MPI_Comm comm);
int MPI_Recv(void *buf, int count, MPI_Datatype datatype, int source, int tag, MPI_Comm comm, MPI_Status *status);
```

The argument `void *buf` specifies the start of the buffer of data being sent and received as a message. The argument `int count` specifies the amount of data elements of that particular buffer type to be sent/received. The argument `MPI_Datatype datatype` contains the MPI integrated datatype of the data to be sent/received. The `int dest` argument is for specifying which process should receive the message (this is not OS process identifier, but is the *rank* of the destination process within a specific `MPI_Comm`). For `MPI_Recv` there is a similar argument `int source` which specifies which process should receive the message (using the process *rank*). The parameter `int tag` specifies an optional message tag for differentiating messages. The last parameter for `MPI_Send` is `MPI_Comm comm` which, "represents a logical group of MPI processes. The default communicator provided by MPI is `MPI_COMM_WORLD`; it contains all MPI processes." The last argument for `MPI_Recv` is `MPI_Status *status` which is the status of the reception.






## 3. Results
- Each matrix has an amount of elements of: __Size x Size__ since we are dealing with square matrices.

- As we can see, MPI actually slows things down a lot because of the massive overhead of process creation and heavy message passing. However, as the workload increases in size, the MPI implementation actually starts to catch up to the naive matrix multiplication algorithm. 

- Overall, as seen below and also stated by experts, "One downside [to interprocess communication] is that such communication between processes is often either complicated to set up or slow, or both, because operating systems typically provide a lot of protection
between processes to avoid one process accidentally modifying data belonging to another process. Another downside
is that there’s an inherent overhead in running multiple
processes: it takes time to start a process, the operating
system must devote internal resources to managing the
process, and so forth. It’s not all negative: the added protection operating systems typically provide
between processes and the higher-level communication mechanisms mean that it
can be easier to write safe concurrent code with processes rather than threads ...  Using separate processes for concurrency also has an additional advantage—you
can run the separate processes on distinct machines connected over a network. Though
this increases the communication cost, on a carefully designed system it can be a costeffective way of increasing the available parallelism and improving performance." (Williams, Concurrency in Action, 2nd Edition).



### 3.1 Timing Comparison
| Small-size Implementation | Size | Time (seconds) | Speedup |
|----------------|-------|-----------|----------|
| Naive | 512 | 0.0502406 | 1.0× |
| Blocked | 512 | 0.0276674 | 1.81× |
| AVX512 Standard | 512 | 0.0275946 | 1.82× |
| AVX512 Blocked | 512 | 0.0234944 | 2.14× |
| OpenMP Parallel | 512 | 0.0174016 | 2.89x |
| OpenMP Parallel AVX | 512 | 0.0038226 | 13.14x |
| OpenMP Parallel AVX [Optimized] | 512 | 0.0040513 | 12.40x |
| MPI | 512 | 0.2530673 | 0.198x |

| Med - size Implementation | Size | Time (seconds) | Speedup |
|----------------|-------|-----------|----------|
| Naive | 1024 | 0.535251 | 1.0× |
| Blocked | 1024 | 0.28431 | 1.88× |
| AVX512 Standard | 1024 | 0.244953 | 2.19× |
| AVX512 Blocked | 1024 | 0.184856 | 2.90× |
| OpenMP Parallel | 1024 | 0.2506426 | 2.14x |
| OpenMP Parallel AVX | 1024 | 0.0185923 | 28.78x |
| OpenMP Parallel AVX [Optimized] | 1024 | 0.0152996 | 34.98x |
| MPI | 1024 | 1.420177 | 0.38x |

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

<!-- | Very Large-size Implementation | Size | Time (seconds) | Speedup |
|----------------|-------|-----------|----------|
| Naive | 4096 | 351.250132 | 1.0× |
| Blocked | 4096 | 3.4543676 | 2.03× |
| AVX512 Standard | 4096 | 2.7734796 | 2.53× |
| AVX512 Blocked | 4096 | 1.8161702 | 3.86× |
| OpenMP Parallel | 4096 | 37.155215 | 9.45x |
| OpenMP Parallel AVX | 4096 | 0.135186 | 51.9x |
| OpenMP Parallel AVX [Optimized] | 4096 | 0.077070 | 91.03x |
| MPI | 4096 | 76.199275 | 4.61x | -->

--------------------

## 4. Conclusions

- The MPI implementation was slower for all workloads but started catching up to the standard implementation as the workloads increased.

- As we can see from the results above, most likely for any size of pure computations, other forms of multithreaded concurrency and parallelism are much more efficient and cost effective than interprocess communication, but for computations on complicated distributed systems where security is emphasized, MPI might just be the way to go.

--------------------

## Features

- Blocked matrix multiplication with configurable block size (BS=16)
- Dynamic work distribution across worker processes
- Correctness verification against serial implementation
- Uses the Matrix library from `01-matrix`

## Building

### Option 1: Using scripts
```bash
cd scripts
./configure.sh  # Configure CMake
./build.sh      # Build the project
```

### Option 2: Manual build
```bash
cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make
```

## Running

### Using the run script
```bash
cd scripts
./run.sh [num_processes]  # Default: 4 processes
```

### Manual execution
```bash
cd build
mpirun -np <num_processes> ./bin/mpi_matmul
```

**Note**: You need at least 2 MPI processes (1 master + 1 worker).

## Configuration

- **POWER**: Matrix size is 2^POWER (default: 10, i.e., 1024x1024)
- **BS**: Block size for matrix blocking (default: 16)

Edit these values in [test/main.cpp](test/main.cpp#L9-L10).

## Dependencies

- MPI (OpenMPI or MPICH)
- CMake >= 3.22.1
- C++17 compiler
- Matrix library from `../01-matrix/include/Matrix.h`

## Implementation Details

The algorithm:
1. Master divides matrices A and B into blocks
2. Each block multiplication task is assigned round-robin to workers
3. Workers compute C_block = A_block × B_block
4. Master accumulates partial results into final matrix C
5. Results are verified against serial matrix multiplication
