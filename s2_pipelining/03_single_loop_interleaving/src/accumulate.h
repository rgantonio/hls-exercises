// src/accumulate.h   (S1.2 header with the silent fallback replaced)
#pragma once
#ifndef DATA_T
#error "DATA_T must be set with -DDATA_T=<type> on add_files"
#endif
typedef DATA_T data_t;

const int N = 1024;

void accumulate(const data_t x[N], data_t *sum);
