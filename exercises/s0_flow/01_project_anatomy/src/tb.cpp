#include <cstdio>
#include <cstdlib>
#include <climits>

void tiny(int a, int b, int *c);

// Reference model. Computed in unsigned so that wraparound is
// well defined, which is what the hardware adder actually does.
// Signed overflow in C++ is undefined behaviour; the RTL has no
// such notion and simply wraps mod 2^32. See the note below.
static int ref(int a, int b) {
    return (int)((unsigned)a + (unsigned)b);
}

static const int POISON = 0x5A5A5A5A;

static int check(int a, int b, int &errors) {
    int c = POISON;                 // detect "kernel never wrote the output"
    tiny(a, b, &c);
    int expected = ref(a, b);
    if (c != expected) {
        printf("FAIL  a=%11d  b=%11d  got=%11d  expected=%11d%s\n",
               a, b, c, expected, (c == POISON) ? "   (output untouched)" : "");
        errors++;
        return 1;
    }
    return 0;
}

int main() {
    int errors = 0;
    int tests  = 0;

    // ---- directed vectors: zero, identity, signs, boundaries ----------
    const int va[] = { 0, 0, 1, 3, -7,  -7, INT_MAX, INT_MIN, INT_MAX, INT_MIN, 123456789 };
    const int vb[] = { 0, 5, 0, 4,  7, -11,       0,       0,       1,      -1, 987654321 };
    const int nvec = sizeof(va) / sizeof(va[0]);

    for (int i = 0; i < nvec; i++) {
        check(va[i], vb[i], errors);
        tests++;
    }

    // ---- random vectors: fixed seed, so the run is reproducible -------
    srand(1);
    for (int i = 0; i < 1000; i++) {
        // rand() gives only 15-31 bits depending on platform; build a full
        // 32-bit value so the upper half of the adder gets exercised too.
        int a = (rand() << 16) ^ rand();
        int b = (rand() << 16) ^ rand();
        check(a, b, errors);
        tests++;
    }

    printf("%s: %d/%d vectors passed\n",
           errors ? "FAIL" : "PASS", tests - errors, tests);
    return errors ? 1 : 0;
}