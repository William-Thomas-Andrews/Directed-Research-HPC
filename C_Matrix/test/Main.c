#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#include "Test.h"


int main() {
    if (run_tests() != 0) { fprintf(stderr, "Error: test failed\n"); exit(1); } 
    return 0;
}


// TODO: try manually creating new processes with fork() 
// TODO: Eventually write blocked transposed avx set of functions
// TODO: Writeup for avx project, and in-depth research into its assembly and why it did what it did on the hardware
// TODO: Implement realloc and padding for the matrices
// TODO: Implement loop unroll
// TODO: align the matrix data
// TODO: Look into cache thrashing and how to align things without cache thrashing