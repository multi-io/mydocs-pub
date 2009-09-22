#ifndef LINALG_H
#define LINALG_H

#include <GL/gl.h>

typedef GLdouble Matrix3D[16];  // column-major, as OpenGL functions expect it

void fillZeros(GLdouble *m);

void fillIdentity(GLdouble *m);

#endif
