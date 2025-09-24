#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#include "Test.h"


int main() {
    if (run_tests() != 0) { fprintf(stderr, "Error: test failed\n"); exit(1); } 
    return 0;
}

// TODO: Investigate numa 
// TODO: Block implementation (4+ blocks), and multi-thread that too (watch out for data races!! You have cache effects, decomposition effects) 
// TODO: see speedup based on number of threads
// TODO: will the OS automatically distribute through processes or keep on one process? Actuall
// If yes, then can we guarantee that it will be spread out? Will pthreads
// allow this to happen? are there C functions that let us check process states? 
// TODO: try manually creating new processes with fork() 