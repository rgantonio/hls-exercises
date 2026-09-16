// src/accumulate.h
#pragma once
#ifndef DATA_T
#error "DATA_T not defined: pass -DDATA_T=<type> via add_files -cflags"
#endif
typedef DATA_T data_t;

const int N = 1024;

void accumulate(const data_t x[N], data_t *sum);