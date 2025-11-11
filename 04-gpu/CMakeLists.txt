cmake_minimum_required(VERSION 3.22.1)

project(CUDA LANGUAGES CXX CUDA)

# Enable assembly language support
enable_language(C ASM)

set(CMAKE_C_STANDARD 23)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# Compiler flags for C files
# set(CMAKE_C_FLAGS_RELEASE "-O3 -march=native -mtune=native -flto -funroll-loops -ffast-math")
# set(CMAKE_C_FLAGS_RELEASE "-O2 -march=native -ffast-math")
# set(CMAKE_C_FLAGS_RELEASE "-O3 -march=native -mtune=native -ffast-math -funroll-loops")
# set(CMAKE_C_FLAGS_RELEASE "-O3 -flto -ffast-math")
set(CMAKE_C_FLAGS_RELEASE "-O3 -mavx512f -fopenmp ")
# set(CMAKE_C_FLAGS_RELEASE "-O3 -mavx512f -fopenmp -march=native -mavx512dq -mfma -funroll-loops -ffast-math -fno-math-errno -fno-trapping-math")
# set(CMAKE_C_FLAGS_DEBUG "-O0 -g")

# Assembly flags (if you're using GAS/GNU assembler)
set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} -mavx512f")

# CUDA compiler flags for optimization
# RTX A5000 uses Ampere architecture (compute capability 8.6)
set(CMAKE_CUDA_ARCHITECTURES 86)
set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} -O3 --use_fast_math")
set(CMAKE_CUDA_FLAGS_RELEASE "-O3 --use_fast_math -lineinfo")

# Collect C source files
file(GLOB_RECURSE CU_SRC_FILES src/*.cu)

# Collect assembly source files (.s or .S)
file(GLOB_RECURSE ASM_SRC_FILES src/*.s src/*.S)

# Create executable with both C and assembly sources
add_executable(CUDA 
    test/Main.cu
    test/Test.cu
    ${CU_SRC_FILES}
    ${ASM_SRC_FILES}
)

set(BUILD_TESTS OFF CACHE INTERNAL "" FORCE)
set(BUILD_BENCHMARKS OFF CACHE INTERNAL "" FORCE)

# find_package(OpenMP REQUIRED)
# target_link_libraries(CUDA PRIVATE OpenMP::OpenMP_C)

# Link cuBLAS library
target_link_libraries(CUDA PRIVATE cublas)

target_include_directories(CUDA
    PUBLIC ${CMAKE_SOURCE_DIR}/src
    PUBLIC ${CMAKE_SOURCE_DIR}/test
    PUBLIC ${CMAKE_SOURCE_DIR}/../01-matrix/include/
    PUBLIC ${CMAKE_SOURCE_DIR}/../02-simd/src/
    PUBLIC ${CMAKE_SOURCE_DIR}/../03-multicore/src/
)

# Optional: Generate assembly listings alongside normal compilation
# This creates .s files in the build directory for inspection
# add_custom_command(TARGET AVX POST_BUILD
#     COMMAND ${CMAKE_C_COMPILER} -S -O3 -mavx512f ${C_SRC_FILES} -o ${CMAKE_BINARY_DIR}/output.s
#     COMMENT "Generating assembly listing"
# )