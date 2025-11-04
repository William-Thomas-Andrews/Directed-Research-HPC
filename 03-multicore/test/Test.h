/**
 * Multicore Test Suite Header
 *
 * Declares the main test harness interface for OpenMP-based parallel
 * matrix multiplication benchmarks.
 */

#ifndef _TEST_H
#define _TEST_H

/**
 * Executes the complete suite of multicore parallel matrix multiplication benchmarks.
 *
 * @return 0 on success, non-zero on failure
 */
int run_tests();

#endif /* _TEST_H */