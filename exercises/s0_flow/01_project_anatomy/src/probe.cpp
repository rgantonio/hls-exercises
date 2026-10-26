void probe(const int in[64], int out[64], int n) {
    // no pragmas anywhere
    for (int i = 0; i < 63; i++) out[i] = in[i] * 3;   // trip count 63
    for (int i = 0; i < 64; i++) out[i] = in[i] * 3;   // trip count 64
}