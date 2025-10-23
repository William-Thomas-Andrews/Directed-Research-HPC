cmake_minimum_required(VERSION 3.22.1)

project(MC C ASM)

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
set(CMAKE_C_FLAGS_RELEASE "-O3 -mavx512f -fopenmp")
# set(CMAKE_C_FLAGS_DEBUG "-O0 -g")

# Assembly flags (if you're using GAS/GNU assembler)
set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} -mavx512f")

# Collect C source files
file(GLOB_RECURSE C_SRC_FILES src/*.c)

# Collect assembly source files (.s or .S)
file(GLOB_RECURSE ASM_SRC_FILES src/*.s src/*.S)

# Create executable with both C and assembly sources
add_executable(MC 
    test/Main.c
    test/Test.c
    ${C_SRC_FILES}
    ${ASM_SRC_FILES}
)

set(BUILD_TESTS OFF CACHE INTERNAL "" FORCE)
set(BUILD_BENCHMARKS OFF CACHE INTERNAL "" FORCE)

# find_package(OpenMP REQUIRED)
# target_link_libraries(MC PRIVATE OpenMP::OpenMP_C)

target_include_directories(MC
    PUBLIC ${CMAKE_SOURCE_DIR}/src
    PUBLIC ${CMAKE_SOURCE_DIR}/test
    PUBLIC ${CMAKE_SOURCE_DIR}/../C_Matrix/include/
    PUBLIC ${CMAKE_SOURCE_DIR}/../AVX/src/
)

# Optional: Generate assembly listings alongside normal compilation
# This creates .s files in the build directory for inspection
# add_custom_command(TARGET AVX POST_BUILD
#     COMMAND ${CMAKE_C_COMPILER} -S -O3 -mavx512f ${C_SRC_FILES} -o ${CMAKE_BINARY_DIR}/output.s
#     COMMENT "Generating assembly listing"
# )