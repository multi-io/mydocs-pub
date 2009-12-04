package de.oklischat.ogl.coil;

/**
 *
 * @author olaf
 */
public class LinAlg {

    // float[]s representing matrices are column-major, as OpenGL functions expect it

    // this is a least-effort port straight from my C linalg.cc
    // Beware: Very ugly. No typedefs in Java...

    public static void fillZeros(float[] arr) {
        for (int i=0; i<arr.length; i++) {
            arr[i] = 0;
        }
    }

    public static void fillIdentity(float[] m) {
        fillZeros(m);
        m[0] = 1;
        m[5] = 1;
        m[10] = 1;
        m[15] = 1;
    }


    /**
     * res := a * (rotation matrix defined by angle, x, y, z)
     */
    public static void fillRotation(float[] a,
                                    float  	angle,
                                    float  	x,
                                    float  	y,
                                    float  	z,
                                    float[] res) {
        // (straight from http://www.opengl.org/sdk/docs/man/xhtml/glRotate.xml)
        float aRad = angle * (float)Math.PI / 180;
        float c = (float) Math.cos(aRad);
        float s = (float) Math.sin(aRad);

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


    public static void fillTranslation(float[] a,
                                       float   tx,
                                       float   ty,
                                       float   tz,
                                       float[] res) {
        float[] tm = new float[16];
        fillIdentity(tm);
        tm[12] = tx;
        tm[13] = ty;
        tm[14] = tz;
        fillMultiplication(a, tm, res);
    }

    public static void fillMultiplication(float[] a, float[] b, float[] res) {
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


    public static float[] copyArr(float[] src, float[] dest) {
        if (dest == null) {
            dest = new float[src.length];
        }
        System.arraycopy(src, 0, dest, 0, src.length);
        return dest;
    }


    public static float[] cross(float[] a, float[] b, float[] dest) {
        if (dest == null) {
            dest = new float[a.length];
        }
        dest[0] = -a[2] * b[1] + a[1] * b[2];
        dest[1] = a[2] * b[0] - a[0] * b[2];
        dest[2] = -a[1] * b[0] + a[0] * b[1];
        return dest;
    }


    public static float[] multiply(float s, float[] v, float[] dest) {
        if (dest == null) {
            dest = new float[v.length];
        }
        dest[0] = s * v[0];
        dest[1] = s * v[1];
        dest[2] = s * v[2];
        return dest;
    }


    public static float length(float[] v) {
        return (float) Math.sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]);
    }


    public static float[] norm(float[] v, float[] dest) {
        if (dest == null) {
            dest = new float[v.length];
        }
        float l = length(v);
        multiply(1.0F/l, v, dest);
        return dest;
    }

}
