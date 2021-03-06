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
    // res := a * (rotation matrix defined by angle, x, y, z)
    // (straight from http://www.opengl.org/sdk/docs/man/xhtml/glRotate.xml)
    GLdouble aRad = angle * M_PI / 180;
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


void fillTranslation(const GLdouble *a,
                     GLfloat  	tx, 
                     GLfloat  	ty, 
                     GLfloat  	tz,
                     GLdouble *res) {
    Matrix3D tm;
    fillIdentity(tm);
    tm[12] = tx;
    tm[13] = ty;
    tm[14] = tz;
    fillMultiplication(a, tm, res);
}

void fillMultiplication(const GLdouble *a, const GLdouble *b, GLdouble *res) {
    for (int rr = 0; rr < 4; rr++) {
        for (int rc = 0; rc < 4; rc++) {
            int ri = rc * 4 + rr;
            res[ri] = 0;
            for (int i = 0; i < 4; i++) {
                res[ri] += a[i * 4 + rr] * b[rc * 4 + i];
            }
        }
    }
}


void copyMatrix3D(const GLdouble *src, GLdouble *dest) {
    for (int i = 0; i < 16; i++) {
        dest[i] = src[i];
    }
}


void cross(const GLdouble *a, const GLdouble *b, GLdouble *dest) {
    dest[0] = -a[2] * b[1] + a[1] * b[2];
    dest[1] = a[2] * b[0] - a[0] * b[2];
    dest[2] = -a[1] * b[0] + a[0] * b[1];
}


void multiply(GLdouble s, const GLdouble *v, GLdouble *dest) {
    dest[0] = s * v[0];
    dest[1] = s * v[1];
    dest[2] = s * v[2];
}


GLdouble length(const GLdouble *v) {
    return sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]);
}


void norm(const GLdouble *v, GLdouble *dest) {
    GLdouble l = length(v);
    multiply(1.0/l, v, dest);
}
