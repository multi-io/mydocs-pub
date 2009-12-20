package de.oklischat.ogl.lwjgl.coil;

import java.awt.Color;
import java.awt.Frame;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.SwingUtilities;
import org.lwjgl.opengl.Display;

/**
 *
 * @author olaf
 */
public class Main {

    public Main() throws Exception {
        Frame frame = new Frame("Coil");
        frame.setBackground(Color.WHITE);
        //ContextAttribs cattrs = new ContextAttribs().withDebug(true).with...;
        //GLEventHandler canvas = new GLEventHandler(cattrs);  // need to do this for OpenGL >= 3.0
        final CoilCanvas canvas = new CoilCanvas();
        frame.add(canvas);
        frame.setSize(800, 600);
        frame.setBackground(Color.black);
        frame.setVisible(true);
        //final Animator anim = new Animator(canvas);  // TODO
        //anim.start();
        final Thread animThread = new Thread(new Runnable() {
            @Override
            public void run() {
                while (true) {
                    canvas.repaint();
                    Display.sync(60);
                }
            }
        });
        animThread.setDaemon(true);
        animThread.start();
		frame.addWindowListener(new WindowAdapter() {
            @Override
			public void windowClosing(WindowEvent e) {
                //anim.stop();
				System.exit(0);
			}
		});
    }


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
