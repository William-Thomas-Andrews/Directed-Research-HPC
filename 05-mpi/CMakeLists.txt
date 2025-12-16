cmake_minimum_required(VERSION 3.22.1)

project(MPI_MATMUL)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

set(CMAKE_CXX_FLAGS_RELEASE "-O3 -ffast-math")
set(CMAKE_CXX_FLAGS_DEBUG "-O0 -g")

# Find MPI
find_package(MPI REQUIRED)

# Include directories
include_directories(
    ${CMAKE_SOURCE_DIR}/../01-matrix/include
    ${MPI_CXX_INCLUDE_DIRS}
)

# Add executable
add_executable(mpi_matmul
    test/main.cpp
)

# Link MPI libraries
target_link_libraries(mpi_matmul
    ${MPI_CXX_LIBRARIES}
)

# Set MPI compile flags
if(MPI_CXX_COMPILE_FLAGS)
    set_target_properties(mpi_matmul PROPERTIES
        COMPILE_FLAGS "${MPI_CXX_COMPILE_FLAGS}")
endif()

# Set MPI link flags
if(MPI_CXX_LINK_FLAGS)
    set_target_properties(mpi_matmul PROPERTIES
        LINK_FLAGS "${MPI_CXX_LINK_FLAGS}")
endif()
