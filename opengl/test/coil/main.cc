#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <string.h>
#include <sys/time.h>
#include <time.h>

#include <vector>

#include <GL/gl.h>   // OpenGL itself.
#include <GL/glu.h>  // GLU support library.
#include <GL/glut.h> // GLUT support library.

#include "linalg.h"

using namespace std;

// viewport dimensions. updated on window resizes
static unsigned vpWidth, vpHeight;

typedef GLdouble Point3D[3];    // {x,y,z}

typedef GLfloat GlColor[4];    // {r,g,b,a}

static const GlColor GLCOLOR_RED     = {0.6,0,0,1};
static const GlColor GLCOLOR_GREEN   = {0,0.6,0,1};
static const GlColor GLCOLOR_BLUE    = {0,0,0.6,1};
static const GlColor GLCOLOR_WHITE   = {0.6,0.6,0.6,1};

static const GLfloat low_shininess[] = {5};
static const GLfloat mid_shininess[] = {20};
static const GLfloat high_shininess[] = {100};

static Matrix3D identityTransform;

struct Coil {
    Point3D locationInWorld;
    GLdouble rotAngle;   // in degrees
    GLdouble rotAngularVelocity;   // in degrees / sec
    GlColor color;
};

static vector<Coil> coils;

struct Viewer {
    Matrix3D worldToEyeCoordTransform;
};

static Viewer theViewer;


static void initCoilsAndViewer() {
    // wanted to misuse current OGL matrix stack for matrix operations,
    // but glGetDoublev() doesn't do anything.
    // < AlastairLynn> you really should avoid glGet. It can cause pipeline stalls
    
    fillIdentity(theViewer.worldToEyeCoordTransform);

    Coil coil1;
    coil1.locationInWorld[0] = 15;
    coil1.locationInWorld[1] = 0;
    coil1.locationInWorld[2] = -70;
    memcpy(coil1.color, GLCOLOR_RED, sizeof(coil1.color));
    coil1.color[0] = 0.4;
    coil1.color[1] = 0.0;
    coil1.color[2] = 0.0;
    coil1.color[3] = 1.0;
    coil1.rotAngle = 70;
    coil1.rotAngularVelocity = 40;

    Coil coil2;
    coil2.locationInWorld[0] = -20;
    coil2.locationInWorld[1] = 15;
    coil2.locationInWorld[2] = -110;
    memcpy(coil2.color, GLCOLOR_GREEN, sizeof(coil1.color));
    coil2.rotAngle = 0;
    coil2.rotAngularVelocity = 0;

    coils.push_back(coil1);
    coils.push_back(coil2);
}


// in isometric (glOrtho) projection: width of viewport in world coords
static const GLdouble vpWidthInWorldCoords = 100;

// in perspective (glFrustum) projection: angular width of viewport in radiants
/*
05:31 < multi_io> what angular resolution (angle per pixel) do you usually choose for perspective (glFrustum) projections?
05:32 < multi_io> or do you choose a specific angular width and height of the viewport?
05:41 < SolraBizna> the latter
05:50 < multi_io> ok
05:51 < multi_io> what would be a common value for that? Are there any conventions/standards?
05:51 < SolraBizna> at least one OpenGL reference recommends calculating the actual angular width of the window from the perspective of the person using 
                    the computer
05:52 < SolraBizna> in practice, values between 30 and 60 work pretty well

(0.9 rad = 51.... degrees)
 */
static const GLdouble vpWidthInRadiants = 0.9;

static void setupEye2ViewportTransformation() {
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();

    /*
    // isometric projection
    GLdouble vpHeightInObjCoords = vpWidthInWorldCoords * vpHeight / vpWidth;
    glOrtho(-vpWidthInWorldCoords/2,  //	GLdouble  	left, 
            vpWidthInWorldCoords/2,   //    GLdouble  	right, 
            -vpHeightInObjCoords/2, //    GLdouble  	bottom, 
            vpHeightInObjCoords/2,  //    GLdouble  	top, 
            -1000, //  GLdouble  	nearVal, 
            1000   //  GLdouble  	farVal
            );
    */

    // perspective projection
    GLdouble nearVal = 3;
    GLdouble farVal = 300;
    GLdouble vpHeightInRadiants = vpWidthInRadiants * vpHeight / vpWidth;
    GLdouble right = nearVal * tan(vpWidthInRadiants/2);
    GLdouble left = -right;
    GLdouble top = nearVal * tan(vpHeightInRadiants/2);
    GLdouble bottom = -top;

    glFrustum(left,
              right,
              bottom,
              top,
              nearVal,
              farVal
              );

    // eye coord -> viewport transformation
    glViewport(0, //GLint x, 
               0, //GLint y, 
               vpWidth, //GLsizei width, 
               vpHeight //GLsizei height
               );
    glDepthRange(0,1);
}

// these should be per-coil eventually
static const GLdouble coil_radius = 15;
static const GLdouble wire_radius = 3;
static const GLdouble coil_height = 40;
static const GLdouble coil_winding_angle_range = 3 * 2 * M_PI;
static const unsigned mesh_count_w = 20;
static const unsigned mesh_count_h = 40 * (coil_winding_angle_range / 2 / M_PI);

static const GLdouble mesh_da_w = 2 * M_PI / (mesh_count_w - 1);
static const GLdouble mesh_da_h = coil_winding_angle_range / (mesh_count_h - 1);
static const GLdouble coil_bottom = -coil_height/2;
static const GLdouble coil_dh = coil_height / (mesh_count_h - 1);


static void mesh2objCoord(GLdouble ah, GLdouble aw, GLdouble *result) {
    result[0] = coil_radius * cos(ah) + wire_radius * cos(aw) * cos(ah);
    result[1] = coil_bottom + coil_dh * ah / mesh_da_h + wire_radius * sin(aw);
    result[2] = coil_radius * sin(ah) + wire_radius * cos(aw) * sin(ah);
}


static void mesh2normv(GLdouble ah, GLdouble aw, GLdouble *result) {
    Point3D tangv1;
    tangv1[0] = -coil_radius*sin(ah) - wire_radius*cos(aw)*sin(ah);
    tangv1[1] = coil_dh/mesh_da_h;
    tangv1[2] = coil_radius*cos(ah) + wire_radius*cos(ah)*cos(aw);

    Point3D tangv2;
    tangv2[0] = -wire_radius*cos(ah)*sin(aw);
    tangv2[1] = wire_radius*cos(aw);
    tangv2[2] = -wire_radius*sin(ah)*sin(aw);

    Point3D unnormalized;
    //cross(tangv1, tangv2, unnormalized);
    cross(tangv2, tangv1, unnormalized);

    norm(unnormalized, result);
}


static void drawCoil(const Coil &c) {
    // printf("Drawing coil at %lf, %lf, %lf\n", c.locationInWorld[0], c.locationInWorld[1], c.locationInWorld[2]);
    glPushAttrib(GL_COLOR_BUFFER_BIT|GL_CURRENT_BIT);
    glColorMaterial(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE);
    //glColorMaterial(GL_FRONT_AND_BACK, GL_SPECULAR);
    glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, GLCOLOR_WHITE);
    glMaterialfv(GL_FRONT_AND_BACK, GL_SHININESS, mid_shininess);
    glColor3fv(c.color);
    for (unsigned mesh_h = 0; mesh_h < mesh_count_h; mesh_h++) {
        GLdouble ah = mesh_h * mesh_da_h;
        glBegin(GL_TRIANGLE_STRIP);
        for (unsigned mesh_w = 0; mesh_w < mesh_count_w; mesh_w++) {
            GLdouble aw = mesh_w * mesh_da_w;
            Point3D objv, normv;
            mesh2normv(ah, aw, normv);
            mesh2objCoord(ah, aw, objv);
            glNormal3dv(normv);
            glVertex3dv(objv);
            mesh2normv(ah + mesh_da_h, aw, normv);
            mesh2objCoord(ah + mesh_da_h, aw, objv);
            glNormal3dv(normv);
            glVertex3dv(objv);
        }
        glEnd();
    }
    glPopAttrib();
}


static void display() {
    // printf("re-displaying...\n");
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glMultMatrixd(theViewer.worldToEyeCoordTransform);
    // define light source
    GLfloat l0Pos[] = {200, 40, -10, 0};
    glLightfv(GL_LIGHT0, GL_POSITION, l0Pos);
    // global ambient light
    GLfloat ambientLight[] = {1,1,1, 0.1};
    glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambientLight);
    // draw all the coils
    for (vector<Coil>::iterator it = coils.begin(); it != coils.end(); it++) {
        const Coil &c = *it;
        glPushMatrix();
        glTranslated(c.locationInWorld[0], c.locationInWorld[1], c.locationInWorld[2]);
        glRotated(c.rotAngle, 0, 1, 0);
        drawCoil(c);
        glPopMatrix();
    }

    glutSwapBuffers();
}

static void reshape(int w, int h) {
    printf("Reshaping to (%i, %i)\n", w, h);
    vpWidth = w;
    vpHeight = h;
    setupEye2ViewportTransformation();
}

static void keyboardCallback(unsigned char key, int x, int y) {
    printf("keyboardCallback(%c)\n", key);
}

static void specialKeyboardCallback(int key, int x, int y) {
    int modifiers = glutGetModifiers();
    printf("specialKeyboardCallback(key=%i, modifiers=%i)\n", key, modifiers);
    int changed = 0;
    Matrix3D viewerDeltaTransform;
    if (modifiers & GLUT_ACTIVE_CTRL) {
        // translation
        const double stepWidth = 5;
        double tx, ty, tz;
        switch (key) {
        case GLUT_KEY_UP:
            if (modifiers & GLUT_ACTIVE_ALT) {
                tx = 0; ty = -stepWidth; tz = 0;
            } else {
                tx = 0; ty = 0; tz = stepWidth;
            }
            changed = 1;
            break;

        case GLUT_KEY_DOWN:
            if (modifiers & GLUT_ACTIVE_ALT) {
                tx = 0; ty = stepWidth; tz = 0;
            } else {
                tx = 0; ty = 0; tz = -stepWidth;
            }
            changed = 1;
            break;

        case GLUT_KEY_LEFT:
            tx = stepWidth; ty = 0; tz = 0;
            changed = 1;
            break;

        case GLUT_KEY_RIGHT:
            tx = -stepWidth; ty = 0; tz = 0;
            changed = 1;
            break;

        }
        if (changed) {
            printf("translating by (%lf, %lf, %lf)\n", tx, ty, tz);
            fillTranslation(identityTransform, tx, ty, tz, viewerDeltaTransform);
        }
    } else {
        // rotation
        const double angle = 5; // degrees
        double rotAngle;  // degrees
        double rotAxisX, rotAxisY, rotAxisZ;
        switch (key) {
        case GLUT_KEY_UP:
            rotAxisX = 1; rotAxisY = 0; rotAxisZ = 0;
            rotAngle = angle;
            changed = 1;
            break;

        case GLUT_KEY_DOWN:
            rotAxisX = 1; rotAxisY = 0; rotAxisZ = 0;
            rotAngle = -angle;
            changed = 1;
            break;

        case GLUT_KEY_LEFT:
            if (modifiers & GLUT_ACTIVE_ALT) {
                rotAxisX = 0; rotAxisY = 1; rotAxisZ = 0;
            } else {
                rotAxisX = 0; rotAxisY = 0; rotAxisZ = 1;
            }
            rotAngle = -angle;
            changed = 1;
            break;

        case GLUT_KEY_RIGHT:
            if (modifiers & GLUT_ACTIVE_ALT) {
                rotAxisX = 0; rotAxisY = 1; rotAxisZ = 0;
            } else {
                rotAxisX = 0; rotAxisY = 0; rotAxisZ = 1;
            }
            rotAngle = angle;
            changed = 1;
            break;

        }
        if (changed) {
            printf("rotating by %lf around (%lf, %lf, %lf)\n", rotAngle, rotAxisX, rotAxisY, rotAxisZ);
            fillRotation(identityTransform, rotAngle, rotAxisX, rotAxisY, rotAxisZ, viewerDeltaTransform);
        }
    }
    if (changed) {
        Matrix3D newViewerTransform;
        fillMultiplication(viewerDeltaTransform, theViewer.worldToEyeCoordTransform, newViewerTransform);
        copyMatrix3D(newViewerTransform, theViewer.worldToEyeCoordTransform);
        glutPostRedisplay();
    }
}

static struct timeval last_anim_step_time;

static void animate() {
    struct timeval newtime;
    gettimeofday(&newtime, NULL);
    double dt = (double)newtime.tv_sec+(double)newtime.tv_usec/1e6 -
        (double)last_anim_step_time.tv_sec-(double)last_anim_step_time.tv_usec/1e6;
    last_anim_step_time = newtime;
    for (vector<Coil>::iterator it = coils.begin(); it != coils.end(); it++) {
        Coil &c = *it;
        c.rotAngle += dt * c.rotAngularVelocity;
        c.rotAngle -= 360 * (int)(c.rotAngle / 360);
    }
    glutPostRedisplay();
}

int main(int argc, char **argv) {
    fillIdentity(identityTransform);
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA | GLUT_DEPTH);
    glutInitWindowPosition(200,100);
    vpWidth = 800;
    vpHeight = 600;
    glutInitWindowSize(vpWidth, vpHeight);
    glutCreateWindow("Coil");
    initCoilsAndViewer();
    setupEye2ViewportTransformation();
    glEnable(GL_DEPTH_TEST);  // has to be done after glutCreateWindow -- why?
    glEnable(GL_RESCALE_NORMAL);
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);
    glEnable(GL_COLOR_MATERIAL);
    glClearColor(0,0,0,0);
    //glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
    //glShadeModel(GL_FLAT);
    glShadeModel(GL_SMOOTH);
    glutDisplayFunc(display);
    glutReshapeFunc(reshape);
    glutKeyboardFunc(keyboardCallback);
    glutSpecialFunc(specialKeyboardCallback);
    gettimeofday(&last_anim_step_time, NULL);
    glutIdleFunc(animate);
    glutMainLoop();
    return 0;
}


// TODO: proper classes for Point3D, Matrix3D, Coil, Viewer; move
// stuff into methods

// TODO: try performance gain achieved by switching to
// single-precision floats
