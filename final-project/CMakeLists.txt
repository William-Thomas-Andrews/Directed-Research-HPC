cmake_minimum_required(VERSION 3.22.1)

project(FIN CXX ASM)

find_package(MPI REQUIRED)

# Matplot++ integration via FetchContent
include(FetchContent)

FetchContent_Declare(
    matplotplusplus
    GIT_REPOSITORY https://github.com/alandefreitas/matplotplusplus
    GIT_TAG v1.2.1
)

# Disable Matplot++ tests and examples to speed up build
set(MATPLOTPP_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(MATPLOTPP_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(MATPLOTPP_BUILD_INSTALLER OFF CACHE BOOL "" FORCE)

FetchContent_MakeAvailable(matplotplusplus)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
SET(CMAKE_C_COMPILER mpicc)
SET(CMAKE_CXX_COMPILER mpicxx)

# Compiler flags for C files
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -mavx512f -fopenmp ")

# Collect C source files
file(GLOB_RECURSE CXX_SRC_FILES src/*.c)

# Create executable with both C and assembly sources
add_executable(FIN
    src/Main.cpp
    src/Matrix.cpp
    src/HeatVisualizer.cpp
    src/Solver.cpp
    ${CXX_SRC_FILES}
)

set(BUILD_TESTS OFF CACHE INTERNAL "" FORCE)
set(BUILD_BENCHMARKS OFF CACHE INTERNAL "" FORCE)

# find_package(OpenMP REQUIRED)
# target_link_libraries(FIN PRIVATE OpenMP::OpenMP_C)

target_include_directories(FIN
    PUBLIC ${CMAKE_SOURCE_DIR}/src
    PUBLIC ${CMAKE_SOURCE_DIR}/include
)

# include_directories(SYSTEM ${MPI_INCLUDE_PATH})

# Link Matplot++
target_link_libraries(FIN PUBLIC matplot)

target_link_libraries(FIN PUBLIC MPI::MPI_CXX)