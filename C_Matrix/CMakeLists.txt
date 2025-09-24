cmake_minimum_required(VERSION 3.22.1)


project(MATRIX)

set(CMAKE_C_STANDARD 23)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# set(CMAKE_C_FLAGS_RELEASE "-O3 -march=native -mtune=native -flto -funroll-loops -ffast-math")
# set(CMAKE_C_FLAGS_RELEASE "-O2 -march=native -ffast-math")
# set(CMAKE_C_FLAGS_RELEASE "-O3 -march=native -mtune=native -ffast-math -funroll-loops")
# set(CMAKE_C_FLAGS_RELEASE "-O3 -flto -ffast-math") #B&OH function slowed by not using -ffast-math
# set(CMAKE_C_FLAGS_RELEASE "-O3 -ffast-math")
set(CMAKE_C_FLAGS_RELEASE "-O3 -flto -g -fno-omit-frame-pointer")
# set(CMAKE_C_FLAGS_RELEASE "-O2 -march=native -ffast-math -funroll-loops")
set(CMAKE_C_FLAGS_DEBUG "-O0 -g")

# Linux perf integration
option(ENABLE_PERF "Enable Linux perf profiling support" ON)
if(ENABLE_PERF)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -fno-omit-frame-pointer")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -no-pie")
    message(STATUS "Linux perf profiling support enabled")
endif()

file(GLOB_RECURSE SRC_FILES
    src/*.c
)

add_executable(MATRIX 
    test/Main.c
    test/Test.c
    ${SRC_FILES}
)

set(BUILD_TESTS OFF CACHE INTERNAL "" FORCE)
set(BUILD_BENCHMARKS OFF CACHE INTERNAL "" FORCE)

target_include_directories(MATRIX
    PUBLIC ${CMAKE_SOURCE_DIR}/src
    PUBLIC ${CMAKE_SOURCE_DIR}/include
    PUBLIC ${CMAKE_SOURCE_DIR}/test
)

# Add custom target for perf profiling
if(ENABLE_PERF)
    add_custom_target(perf-record
        COMMAND perf record -g --call-graph=dwarf $<TARGET_FILE:MATRIX>
        DEPENDS MATRIX
        COMMENT "Running perf record with call graph on MATRIX executable"
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    )

    add_custom_target(perf-report
        COMMAND perf report
        COMMENT "Generating perf report from recorded data"
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    )

    add_custom_target(perf-stat
        COMMAND perf stat $<TARGET_FILE:MATRIX>
        DEPENDS MATRIX
        COMMENT "Running perf stat on MATRIX executable"
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    )
endif()