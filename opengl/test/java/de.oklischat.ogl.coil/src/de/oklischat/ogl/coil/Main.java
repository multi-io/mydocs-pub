package de.oklischat.ogl.coil;

import java.awt.Color;
import java.awt.Frame;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.media.opengl.GLAutoDrawable;
import javax.media.opengl.GLCapabilities;
import javax.media.opengl.GLEventListener;
import javax.media.opengl.GLProfile;
import javax.media.opengl.awt.GLCanvas;
import javax.swing.SwingUtilities;

/**
 *
 * @author olaf
 */
public class Main {

    public Main() {
        Frame frame = new Frame("Coil");
        frame.setSize(300, 300);
        frame.setBackground(Color.WHITE);
        //GLCanvas canvas = GLDrawableFactory.getFactory(GLProfile.get(GLProfile.GL2)).createGLCanvas(new GLCapabilities(null));
        GLCapabilities caps = new GLCapabilities(GLProfile.get(GLProfile.GL2));
        GLCanvas canvas = new GLCanvas(caps);
        canvas.addGLEventListener(glEventListener);
        frame.add(canvas);
        frame.setSize(800, 600);
        frame.setVisible(true);
		frame.addWindowListener(new WindowAdapter() {
            @Override
			public void windowClosing(WindowEvent e) {
				System.exit(0);
			}
		});
    }

    protected GLEventListener glEventListener = new GLEventListener() {

        @Override
        public void init(GLAutoDrawable glAutoDrawable) {
        }

        @Override
        public void dispose(GLAutoDrawable glAutoDrawable) {
        }

        @Override
        public void display(GLAutoDrawable glAutoDrawable) {
        }

        @Override
        public void reshape(GLAutoDrawable glAutoDrawable, int x, int y, int width, int height) {
        }
    };


    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        SwingUtilities.invokeLater(new Runnable() {
            @Override
            public void run() {
                try {
                    new Main();
                } catch (Exception ex) {
                    Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
                    System.exit(1);
                }
            }
        });
    }

}
