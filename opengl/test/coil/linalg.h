#ifndef LINALG_H
#define LINALG_H

#include <GL/gl.h>

typedef GLdouble Matrix3D[16];  // column-major, as OpenGL functions expect it

void fillZeros(GLdouble *m);

void fillIdentity(GLdouble *m);

/**
 * Like glRotated with a being the previous and res becoming the
 * following top-of-stack
 */
void fillRotation(const GLdouble *a,
                  GLfloat  	angle, 
                  GLfloat  	x, 
                  GLfloat  	y, 
                  GLfloat  	z,
                  GLdouble *res);

#endif
