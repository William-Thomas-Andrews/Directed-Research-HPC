#include "Test.h"

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>


int main() {
    if (run_tests() != 0) { fprintf(stderr, "Error: test failed\n"); exit(1); } 
    return 0;
}