cmake_minimum_required(VERSION 3.22.1)


project(AVX)

set(CMAKE_C_STANDARD 23)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# set(CMAKE_C_FLAGS_RELEASE "-O3 -march=native -mtune=native -flto -funroll-loops -ffast-math")
# set(CMAKE_C_FLAGS_RELEASE "-O2 -march=native -ffast-math")
# set(CMAKE_C_FLAGS_RELEASE "-O3 -march=native -mtune=native -ffast-math -funroll-loops")
# set(CMAKE_C_FLAGS_RELEASE "-O3 -flto -ffast-math") #B&OH function slowed by not using -ffast-math
# set(CMAKE_C_FLAGS_RELEASE "-O3 -S -c -ffast-math")
set(CMAKE_C_FLAGS_RELEASE "-O3 -mavx512f")
# add_compile_options(-mavx2 -mfma -mavx512f)
# set(CMAKE_C_FLAGS_RELEASE "-O3 -flto")
# set(CMAKE_C_FLAGS_RELEASE "-O3 ")
# set(CMAKE_C_FLAGS_RELEASE "-O2 -march=native -ffast-math -funroll-loops")
set(CMAKE_C_FLAGS_DEBUG "-O0 -g")


file(GLOB_RECURSE SRC_FILES
    src/*.c
)

add_executable(AVX 
    test/Main.c
    test/Test.c
    ${SRC_FILES}
)

set(BUILD_TESTS OFF CACHE INTERNAL "" FORCE)
set(BUILD_BENCHMARKS OFF CACHE INTERNAL "" FORCE)

target_include_directories(AVX
    PUBLIC ${CMAKE_SOURCE_DIR}/src
    PUBLIC ${CMAKE_SOURCE_DIR}/test
    PUBLIC ${CMAKE_SOURCE_DIR}/../C_Matrix/include/
)


# include_directories(/home/wtandrews/320_CSCI/version2)

