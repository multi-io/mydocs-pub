#include <stdlib.h>
#include <stdio.h>
#include <math.h>

#include <GL/gl.h>   // OpenGL itself.
#include <GL/glu.h>  // GLU support library.
#include <GL/glut.h> // GLUT support library.

// width of viewport in object coords

// (viewport will display object coord. (0,0,0) at its center, with
// object coord. x axis parallel to viewport x axis, and object
// coord. z axis perpendicular to the viewing plane)
static const GLdouble vpWidthInObjCoords = 100;

// viewport dimensions. updated on window resizes
static unsigned vpWidth, vpHeight;

static void setupObj2ViewportTransformation() {
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    GLdouble vpHeightInObjCoords = vpWidthInObjCoords * vpHeight / vpWidth;
    glOrtho(-vpWidthInObjCoords/2,  //	GLdouble  	left, 
            vpWidthInObjCoords/2,   //    GLdouble  	right, 
            -vpHeightInObjCoords/2, //    GLdouble  	bottom, 
            vpHeightInObjCoords/2,  //    GLdouble  	top, 
            -100, //  GLdouble  	nearVal, 
            100   //  GLdouble  	farVal
            );
    glViewport(0, //GLint x, 
               0, //GLint y, 
               vpWidth, //GLsizei width, 
               vpHeight //GLsizei height
               );
    glDepthRange(0,1);
}

static const GLdouble coil_radius = 15;
static const GLdouble wire_radius = 3;
static const GLdouble coil_height = 40;
static const GLdouble coil_winding_angle_range = 3 * 2 * M_PI;
static const unsigned mesh_count_w = 20;
static const unsigned mesh_count_h = 40 * (coil_winding_angle_range / 2 / M_PI);

static const GLdouble mesh_da_w = 2 * M_PI / (mesh_count_w - 1);
static const GLdouble mesh_da_h = coil_winding_angle_range / (mesh_count_h - 1);
static const GLdouble coil_bottom = -coil_height/2;
static const GLdouble coil_dh = coil_height / mesh_count_h;


static void mesh2objCoord(GLdouble ah, GLdouble aw, GLdouble *x, GLdouble *y, GLdouble *z) {
    *x = coil_radius * cos(ah) + wire_radius * cos(aw) * cos(ah);
    *y = coil_bottom + coil_dh * ah / mesh_da_h + wire_radius * sin(aw);
    *z = coil_radius * sin(ah) + wire_radius * cos(aw) * sin(ah);
}

static void display() {
    glClear(GL_COLOR_BUFFER_BIT);
    glColor3f(1, 0, 0);
    for (unsigned mesh_h = 0; mesh_h < mesh_count_h; mesh_h++) {
        GLdouble ah = mesh_h * mesh_da_h;
        glBegin(GL_TRIANGLE_STRIP);
        for (unsigned mesh_w = 0; mesh_w < mesh_count_w; mesh_w++) {
            GLdouble aw = mesh_w * mesh_da_w;
            double x, y, z;
            mesh2objCoord(ah, aw, &x, &y, &z);
            glVertex3d(x, y, z);
            mesh2objCoord(ah + mesh_da_h, aw, &x, &y, &z);
            glVertex3d(x, y, z);
        }
        glEnd();
    }
    glFlush();
}

static void reshape(int w, int h) {
    vpWidth = w;
    vpHeight = h;
    setupObj2ViewportTransformation();
}

int main(int argc, char **argv) {
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGBA /* | GLUT_DEPTH */);
    glutInitWindowPosition(200,100);
    vpWidth = 800;
    vpHeight = 600;
    glutInitWindowSize(vpWidth, vpHeight);
    setupObj2ViewportTransformation();
    glutCreateWindow("Coil");
    glClearColor(0,0,0,0);
    glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
    glShadeModel(GL_FLAT);
    glutDisplayFunc(display);
    glutReshapeFunc(reshape);
    glutMainLoop();
    return 0;
}
