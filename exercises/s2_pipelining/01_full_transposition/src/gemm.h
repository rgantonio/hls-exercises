// src/gemm.h
#pragma once
#ifndef DATA_T
#error "DATA_T must be set with -DDATA_T=<type> on add_files"
#endif
typedef DATA_T data_t;

const int N = 32;   // rows of A and C
const int K = 32;   // columns of A = rows of B
const int M = 32;   // columns of B and C

// Both compute C = A*B + C.
void gemm_naive(const data_t A[N][K], const data_t B[K][M], data_t C[N][M]);
void gemm_trans(const data_t A[N][K], const data_t B[K][M], data_t C[N][M]);
