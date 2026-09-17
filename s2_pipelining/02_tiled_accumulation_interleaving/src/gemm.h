// src/gemm.h
#pragma once
#ifndef DATA_T
#error "DATA_T must be set with -DDATA_T=<type> on add_files"
#endif
#ifndef GEMM_M
#error "GEMM_M must be set with -DGEMM_M=<columns> on add_files (32 everywhere except extra 5.5a)"
#endif
typedef DATA_T data_t;

const int N = 32;       // rows of A and C
const int K = 32;       // columns of A = rows of B
const int M = GEMM_M;   // columns of B and C

// All four compute C = A*B + C.
void gemm_naive(const data_t A[N][K], const data_t B[K][M], data_t C[N][M]);
void gemm_trans(const data_t A[N][K], const data_t B[K][M], data_t C[N][M]);
void gemm_tile(const data_t A[N][K], const data_t B[K][M], data_t C[N][M]);
void gemm_tshift(const data_t A[N][K], const data_t B[K][M], data_t C[N][M]);
