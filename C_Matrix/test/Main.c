#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#include "Test.h"


int main() {
    if (run_tests() != 0) { fprintf(stderr, "Error: test failed\n"); exit(1); } 
    return 0;
}


// TODO: try manually creating new processes with fork() 
// TODO: Implement transposed access
// TODO: Look through the assembly test.s
// TODO: Start AVX project
// TODO: Implement realloc and padding for the matrices