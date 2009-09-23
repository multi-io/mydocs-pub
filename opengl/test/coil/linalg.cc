#include "linalg.h"

#include <math.h>

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


void fillRotation(const GLdouble *a,
                  GLfloat  	angle, 
                  GLfloat  	x, 
                  GLfloat  	y, 
                  GLfloat  	z,
                  GLdouble *res) {
    // (straight from http://www.opengl.org/sdk/docs/man/xhtml/glRotate.xml)
    GLdouble aRad = angle / 180 * M_PI;
    GLdouble c = cos(aRad);
    GLdouble s = sin(aRad);

    res[0]  = x*x*(1-c)+c;
    res[1]  = y*x*(1-c)+z*s;
    res[2]  = x*z*(1-c)-y*s;
    res[3]  = 0;

    res[4]  = x*y*(1-c)-z*s;
    res[5]  = y*y*(1-c)+c;
    res[6]  = y*z*(1-c)+x*s;
    res[7]  = 0;

    res[8]  = x*z*(1-c)+y*s;
    res[9]  = y*z*(1-c)-x*s;
    res[10] = z*z*(1-c)+c;
    res[11] = 0;

    res[12] = 0;
    res[13] = 0;
    res[14] = 0;
    res[15] = 1;
}
