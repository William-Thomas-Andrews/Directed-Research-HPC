#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#include "Test.h"


int main() {
    if (run_tests() != 0) { fprintf(stderr, "Error: test failed\n"); exit(1); } 
    return 0;
}


// TODO: try manually creating new processes with fork() 
// TODO: Implement AVX classic, and shuffle/permute stuff
// TODO: Implement realloc and padding for the matrices