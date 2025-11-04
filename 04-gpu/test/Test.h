/**
 * GPU Test Suite Header
 *
 * Declares the main test harness interface for GPU-based parallel
 * matrix multiplication benchmarks.
 */

#ifndef _TEST_H
#define _TEST_H

/**
 * Executes the complete suite of GPU parallel matrix multiplication benchmarks.
 *
 * @return 0 on success, non-zero on failure
 */
int run_tests();

#endif /* _TEST_H */