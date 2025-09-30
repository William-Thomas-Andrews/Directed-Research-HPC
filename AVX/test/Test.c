#include "Test.h"
#include "Matrix.h"
#include <immintrin.h>
#include <stdio.h>

// Function implementations
void vector_add_scalar(float *a, float *b, float *result, int n) {
    for (int i = 0; i < n; i++) {
        result[i] = a[i] + b[i];
    }
}

#ifdef __AVX2__
void vector_add_avx2(float *a, float *b, float *result, int n) {
    int i;
    for (i = 0; i <= n - 8; i += 8) {
        __m256 va = _mm256_loadu_ps(&a[i]);
        __m256 vb = _mm256_loadu_ps(&b[i]);
        __m256 vr = _mm256_add_ps(va, vb);
        _mm256_storeu_ps(&result[i], vr);
    }
    for (; i < n; i++) {
        result[i] = a[i] + b[i];
    }
}
#endif

#ifdef __AVX512F__
void vector_add_avx512(float *a, float *b, float *result, int n) {
    int i;
    for (i = 0; i <= n - 16; i += 16) {

    }
    for (; i < n; i++) {
        result[i] = a[i] + b[i];
    }
}
#endif

void vector_add(float *a, float *b, float *result, int n) {
    #ifdef __AVX512F__
        vector_add_avx512(a, b, result, n);
    #elif __AVX2__
        vector_add_avx2(a, b, result, n);
    #else
        vector_add_scalar(a, b, result, n);
    #endif
}

int run_tests() {
    struct Matrix m;
    float a[16], b[16], result[16];
    __m512 simd512_array_1 = _mm512_set_ps(8.0f, 4.0f, 2.0f, 1.0f, 8.0f, 4.0f, 2.0f, 1.0f, 8.0f, 4.0f, 2.0f, 1.0f, 8.0f, 4.0f, 2.0f, 1.0f);
    __m512 simd512_array_2 = _mm512_set_ps(4.0f, 3.0f, 2.0f, 1.0f, 4.0f, 3.0f, 2.0f, 1.0f, 4.0f, 3.0f, 2.0f, 1.0f, 4.0f, 3.0f, 2.0f, 1.0f);
    __m512 simd512_array_3;

    // Initialize arrays
    // for (int i = 0; i < 32; i++) {
    //     a[i] = i * 1.0f;
    //     b[i] = i * 2.0f;
    // }

    simd512_array_3 = _mm512_add_ps(simd512_array_1, simd512_array_2);
    _mm512_store_ps(result, simd512_array_3);
    printf("[ ");
    for (int j = 0; j < 16; j++) {
        printf("%f ", result[j]);
    }
    printf("]\n");

    // printf("[ ");
    // for (int k = 0; k < 32; k++) {
    //     printf("%f ", b[k]);
    // }
    // printf("]\n");
    

    // // Call the dispatcher - it picks the right implementation
    // vector_add(a, b, result, 32);
    
    // printf("result[0] = %f\n", result[0]);
    // printf("result[31] = %f\n", result[31]);
    
    return 0;
}