#include "linalg.h"

void fillZeros(GLdouble *m) {
    for (int i=0; i<16; i++) {
        m[i] = 0;
    }
}

void fillIdentity(GLdouble *m) {
    fillZeros(m);
    m[0] = 1.0;
    m[5] = 1.0;
    m[10] = 1.0;
    m[15] = 1.0;
}
