// src/acc_il.h
#pragma once
#ifndef K
#error "K must be set with -DK=<lanes> on add_files"
#endif
#if K < 1
#error "K must be at least 1"
#endif

typedef float data_t;   // interleaving only matters when the add is slow

const int N = 1024;

void acc_shift(const data_t x[N], data_t *sum);
void acc_index(const data_t x[N], data_t *sum);
