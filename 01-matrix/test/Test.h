/**
 * Test Suite Header
 *
 * Declares the main test harness interface for matrix multiplication benchmarks.
 */

#ifndef _TEST_H
#define _TEST_H

#include <unistd.h>
#include <stdlib.h>

/**
 * Executes the complete suite of matrix multiplication benchmarks.
 *
 * @return 0 on success, non-zero on failure
 */
int run_tests();

#endif /* _TEST_H */