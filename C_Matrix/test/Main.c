#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#include "Test.h"


int main() {
    if (run_tests() != 0) { fprintf(stderr, "Error: test failed\n"); exit(1); } 
    return 0;
}

// TODO: Investigate and implement numa 
// TODO: Block implementation (4+ blocks), and multi-thread that too (watch out for data races!! You have cache effects, decomposition effects) 
// TODO: see speedup based on number of threads
// TODO: Test the process stuff with Linux perf and possibly try OpenMP 
// TODO: try manually creating new processes with fork() 