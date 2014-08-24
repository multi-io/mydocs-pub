// this program crashes in some Linux OGL implementations
// (reproduced on Ubuntu 9.10 / 32-bit, Intel GMA)

#include <GL/gl.h>
#include <GL/glu.h>
#include <GL/glut.h>

int main(int argc, char **argv) {
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA | GLUT_DEPTH);
    glutInitWindowPosition(200,100);
    glutInitWindowSize(500, 400);
    glMatrixMode(GL_PROJECTION);
    return 0;
}
