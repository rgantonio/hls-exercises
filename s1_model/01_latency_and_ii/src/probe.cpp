void probe(const int in[64], int out63[64], int out64[64]) {
L63:
    for (int i = 0; i < 63; i++) out63[i] = in[i] * 3 + 1;
L64:
    for (int i = 0; i < 64; i++) out64[i] = in[i] * 5 + 2;
}