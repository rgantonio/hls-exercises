// src/fir3.h
#pragma once
#ifndef DATA_T
#error "DATA_T not defined: pass -DDATA_T=<type> via add_files -cflags"
#endif
typedef DATA_T data_t;

const int N = 1024;
const int M = N - 2;   // one output per full 3-tap window

void fir3(const data_t x[N], data_t y[M]);