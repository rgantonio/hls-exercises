void probe(const int in[64], int out63[64], int out64[64], int out65[65], int out1024[1024]) {
L63:
    for (int i = 0; i < 63; i++) out63[i] = in[i] * 3 + 1;
L64:
    for (int i = 0; i < 64; i++) out64[i] = in[i] * 5 + 2;
L65:  
    for (int i = 0; i < 65;   i++) out65[i]  = in[i] * 7 + 3;
L1024:
    for (int i = 0; i < 1024; i++) out1024[i]= in[i & 63] * 11 + 4;
}