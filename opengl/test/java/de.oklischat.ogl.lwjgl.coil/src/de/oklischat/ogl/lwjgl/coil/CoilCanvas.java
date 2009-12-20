/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.oklischat.ogl.lwjgl.coil;

import java.awt.event.ComponentEvent;
import java.nio.FloatBuffer;
import java.util.ArrayList;
import java.util.Collection;
import org.lwjgl.LWJGLException;
import org.lwjgl.opengl.AWTGLCanvas;
import static org.lwjgl.opengl.GL11.*;
import static org.lwjgl.opengl.GL12.*;
import static org.lwjgl.opengl.GL13.*;
import static org.lwjgl.opengl.GL14.*;
import static org.lwjgl.opengl.GL15.*;
import static org.lwjgl.opengl.GL20.*;
import static org.lwjgl.opengl.GL21.*;

/**
 *
 * @author olaf
 */
public class CoilCanvas extends AWTGLCanvas {

    public CoilCanvas() throws LWJGLException {
    }

    // this is a least-effort port straight from my C "coil" test app
    // Beware: Very ugly. No typedefs in Java... must use classes eventually
    // TODO: at the very least, (re)use the FloatBuffers a bit more efficiently
    // the people in #lwjgl (on freenode) basically say: never use glPush/PopMatrix, glTranslate/Rotate/MultMatrix etc.,
    //    do all the matrix/vector algebra outside JOGL/LWJGL in Java, copy the result into a
    //    (preferably reused) direct FloatBuffer and glLoadMatrix() that

    // in isometric (glOrtho) projection: width of viewport in world coords
    final float vpWidthInWorldCoords = 100;

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
    final float vpWidthInRadiants = 0.9F;

    public /*static*/ final float[] GLCOLOR_RED = {0.6F,0F,0F,1F};
    public /*static*/ final float[] GLCOLOR_GREEN = {0F,0.6F,0F,1F};
    public /*static*/ final float[] GLCOLOR_BLUE = {0F,0F,0.6F,1F};
    public /*static*/ final float[] GLCOLOR_WHITE = {0.6F,0.6F,0.6F,1F};

    public /*static*/ final float low_shininess[] = {5};
    public /*static*/ final float mid_shininess[] = {20,0,0,0};   // 0,0,0 for FloatBuffer "padding"?
    //20:42 < multi_io> do parameters like GL_SHININESS that only require a single float still need a FloatBuffer
    //          with 4 floats?
    //20:42 < MatthiasM2> multi_io: yes, this makes the checking code in LWJGL a lot easier
    //20:43 < MatthiasM2> and I always use the 16 FloatBuffer anyway
    //20:43 < multi_io> ok

    public /*static*/ final float high_shininess[] = {100};

//        public /*static*/ final FloatBuffer GLCOLOR_RED = FloatBuffer.wrap(new float[]{0.6F,0F,0F,1F});
//        public /*static*/ final FloatBuffer GLCOLOR_GREEN = FloatBuffer.wrap(new float[]{0F,0.6F,0F,1F});
//        public /*static*/ final FloatBuffer GLCOLOR_BLUE = FloatBuffer.wrap(new float[]{0F,0F,0.6F,1F});
//        public /*static*/ final FloatBuffer GLCOLOR_WHITE = FloatBuffer.wrap(new float[]{0.6F,0.6F,0.6F,1F});
//
//        public /*static*/ final FloatBuffer low_shininess = FloatBuffer.wrap(new float[]{5});
//        public /*static*/ final FloatBuffer mid_shininess = FloatBuffer.wrap(new float[]{20});
//        public /*static*/ final FloatBuffer high_shininess = FloatBuffer.wrap(new float[]{100});

    float[] identityTransform = new float[16];

    {
        LinAlg.fillIdentity(identityTransform);
    }

    class Coil {
        float[] locationInWorld = new float[3];
        float rotAngle;   // in degrees
        float rotAngularVelocity;   // in degrees / sec
        float[] color = new float[4];
    };

    Collection<Coil> coils = new ArrayList<Coil>();

    class Viewer {
        float[] worldToEyeCoordTransform = new float[16];
    };

    Viewer theViewer = new Viewer();

    public void init() {
        initCoilsAndViewer();
        setupEye2ViewportTransformation();
        glEnable(GL_DEPTH_TEST);
        glEnable(GL_RESCALE_NORMAL);
        glEnable(GL_LIGHTING);
        glEnable(GL_LIGHT0);
        glEnable(GL_COLOR_MATERIAL);
        glClearColor(0,0,0,0);
        //glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
        //glShadeModel(GL_FLAT);
    }

    private void initCoilsAndViewer() {
        LinAlg.fillIdentity(theViewer.worldToEyeCoordTransform);

        Coil coil1 = new Coil();
        coil1.locationInWorld[0] = 15;
        coil1.locationInWorld[1] = 0;
        coil1.locationInWorld[2] = -70;
        LinAlg.copyArr(GLCOLOR_RED, coil1.color);
        coil1.color[0] = 0.4F;
        coil1.color[1] = 0.0F;
        coil1.color[2] = 0.0F;
        coil1.color[3] = 1.0F;
        coil1.rotAngle = 70;
        coil1.rotAngularVelocity = 0;

        Coil coil2 = new Coil();
        coil2.locationInWorld[0] = -20;
        coil2.locationInWorld[1] = 15;
        coil2.locationInWorld[2] = -110;
        LinAlg.copyArr(GLCOLOR_GREEN, coil2.color);
        coil2.rotAngle = 0;
        coil1.rotAngularVelocity = 40;

        coils.add(coil1);
        coils.add(coil2);
    }

    private void setupEye2ViewportTransformation() {
        System.out.println("projecting to viewport width=" + getWidth() + ", height=" + getHeight());
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
        float nearVal = 3;
        float farVal = 300;
        float vpHeightInRadiants = vpWidthInRadiants * getHeight() / getWidth();
        float right = nearVal * (float) Math.tan(vpWidthInRadiants/2);
        float left = -right;
        float top = nearVal * (float) Math.tan(vpHeightInRadiants/2);
        float bottom = -top;

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
                   getWidth(), //GLsizei width,
                   getHeight() //GLsizei height
                   );
        glDepthRange(0,1);
    }

    // these should be per-coil eventually
    final float coil_radius = 15;
    final float wire_radius = 3;
    final float coil_height = 40;
    final float coil_winding_angle_range = 3 * 2 * (float) Math.PI;
    final float mesh_count_w = 20;
    final float mesh_count_h = 40 * (coil_winding_angle_range / 2 / (float) Math.PI);

    final float mesh_da_w = 2 * (float) Math.PI / (mesh_count_w - 1);
    final float mesh_da_h = coil_winding_angle_range / (mesh_count_h - 1);
    final float coil_bottom = -coil_height/2;
    final float coil_dh = coil_height / (mesh_count_h - 1);


    private void mesh2objCoord(float ah, float aw, float[] result) {
        result[0] = coil_radius * (float)Math.cos(ah) + wire_radius * (float)Math.cos(aw) * (float)Math.cos(ah);
        result[1] = coil_bottom + coil_dh * ah / mesh_da_h + wire_radius * (float)Math.sin(aw);
        result[2] = coil_radius * (float)Math.sin(ah) + wire_radius * (float)Math.cos(aw) * (float)Math.sin(ah);
    }


    private void mesh2normv(float ah, float aw, float[] result) {
        float[] tangv1 = new float[3];
        tangv1[0] = -coil_radius * (float)Math.sin(ah) - wire_radius * (float)Math.cos(aw) * (float)Math.sin(ah);
        tangv1[1] = coil_dh/mesh_da_h;
        tangv1[2] = coil_radius * (float)Math.cos(ah) + wire_radius * (float)Math.cos(ah) * (float)Math.cos(aw);

        float[] tangv2 = new float[3];
        tangv2[0] = - wire_radius * (float)Math.cos(ah) * (float)Math.sin(aw);
        tangv2[1] = wire_radius * (float)Math.cos(aw);
        tangv2[2] = - wire_radius * (float)Math.sin(ah) * (float)Math.sin(aw);

        //cross(tangv1, tangv2, unnormalized);
        float[] unnormalized = LinAlg.cross(tangv2, tangv1, null);

        LinAlg.norm(unnormalized, result);
    }


    private void drawCoil(Coil c) {
        // printf("Drawing coil at %lf, %lf, %lf\n", c.locationInWorld[0], c.locationInWorld[1], c.locationInWorld[2]);
        glPushAttrib(GL_COLOR_BUFFER_BIT|GL_CURRENT_BIT);
        glColorMaterial(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE);
        //glColorMaterial(GL_FRONT_AND_BACK, GL_SPECULAR);
        glMaterial(GL_FRONT_AND_BACK, GL_SPECULAR, FloatBuffer.wrap(GLCOLOR_WHITE));
        glMaterial(GL_FRONT_AND_BACK, GL_SHININESS, FloatBuffer.wrap(mid_shininess));
        glColor4f(c.color[0], c.color[1], c.color[2], c.color[3]);
        for (int mesh_h = 0; mesh_h < mesh_count_h; mesh_h++) {
            float ah = mesh_h * mesh_da_h;
            glBegin(GL_TRIANGLE_STRIP);
            for (int mesh_w = 0; mesh_w < mesh_count_w; mesh_w++) {
                float aw = mesh_w * mesh_da_w;
                float[] objv = new float[3], normv = new float[3];
                mesh2normv(ah, aw, normv);
                mesh2objCoord(ah, aw, objv);
                glNormal3f(normv[0], normv[1], normv[2]);
                glVertex3f(objv[0], objv[1], objv[2]);
                mesh2normv(ah + mesh_da_h, aw, normv);
                mesh2objCoord(ah + mesh_da_h, aw, objv);
                glNormal3f(normv[0], normv[1], normv[2]);
                glVertex3f(objv[0], objv[1], objv[2]);
            }
            glEnd();
        }
        glPopAttrib();
    }

    private boolean contextInitialized = false, resizePending = false;

    @Override
    protected void paintGL() {
        if (!contextInitialized) {
            init();
            contextInitialized = true;
            resizePending = false;
        }
        if (resizePending) {
            setupEye2ViewportTransformation();
            resizePending = false;
        }
        animate();
        // printf("re-displaying...\n");
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        glMatrixMode(GL_MODELVIEW);
        glLoadIdentity();
        glMultMatrix(FloatBuffer.wrap(theViewer.worldToEyeCoordTransform));
        // define light source
        float[] l0Pos = {200, 40, -10, 0};
        glLight(GL_LIGHT0, GL_POSITION, FloatBuffer.wrap(l0Pos));
        // global ambient light
        float ambientLight[] = {1,1,1, 0.1F};
        glLightModel(GL_LIGHT_MODEL_AMBIENT, FloatBuffer.wrap(ambientLight));
        // draw all the coils
        for (Coil c : coils) {
            glPushMatrix();
            glTranslatef(c.locationInWorld[0], c.locationInWorld[1], c.locationInWorld[2]);
            glRotatef(c.rotAngle, 0, 1, 0);
            drawCoil(c);
            glPopMatrix();
        }
        try {
            swapBuffers();
        } catch (LWJGLException ex) {
            throw new RuntimeException(ex);
        }
    }

    private long lastAnimStepTime = -1;

    private void animate() {
        final long now = System.currentTimeMillis();
        if (lastAnimStepTime > 0) {
            float dt = (float) (now - lastAnimStepTime) / 1000;
            for (Coil c : coils) {
                c.rotAngle += dt * c.rotAngularVelocity;
                c.rotAngle -= 360 * (int)(c.rotAngle / 360);
            }
        }
        lastAnimStepTime = now;
    }

    @Override
    public void componentResized(ComponentEvent e) {
        super.componentResized(e);
        if (contextInitialized) {
            //setupEye2ViewportTransformation();
            resizePending = true;
        }
    }

};
