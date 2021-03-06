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

void fillTranslation(const GLdouble *a,
                     GLfloat  	tx, 
                     GLfloat  	ty, 
                     GLfloat  	tz,
                     GLdouble *res);

void fillMultiplication(const GLdouble *a, const GLdouble *b, GLdouble *res);

void copyMatrix3D(const GLdouble *src, GLdouble *dest);

void cross(const GLdouble *a, const GLdouble *b, GLdouble *dest);

void multiply(GLdouble s, const GLdouble *v, GLdouble *dest);

GLdouble length(const GLdouble *v);

void norm(const GLdouble *v, GLdouble *dest);

#endif
