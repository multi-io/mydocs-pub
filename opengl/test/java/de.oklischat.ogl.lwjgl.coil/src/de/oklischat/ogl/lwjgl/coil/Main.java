package de.oklischat.ogl.lwjgl.coil;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.FlowLayout;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.util.ArrayList;
import java.util.Collection;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JToolBar;
import javax.swing.SwingUtilities;
import org.lwjgl.opengl.Display;

/**
 *
 * @author olaf
 */
public class Main {

    public Main() throws Exception {
        final Collection<Component> canvasses = new ArrayList<Component>();
        int nFrames = 3;
        for (int i = 0; i < nFrames; i++) {
            JFrame frame = new JFrame("Coil");
            JToolBar toolbar = new JToolBar();
            toolbar.setFloatable(false);
            JComboBox cb = new JComboBox(new Object[]{"foo","bar","baz","quux"});
            toolbar.add(cb);
            frame.add(cb, BorderLayout.NORTH);
            //ContextAttribs cattrs = new ContextAttribs().withDebug(true).with...;
            //GLEventHandler canvas = new GLEventHandler(cattrs);  // need to do this for OpenGL >= 3.0
            final CoilCanvas canvas = CoilCanvas.create();
            canvasses.add(canvas);
            frame.add(canvas, BorderLayout.CENTER);
            frame.setSize(800, 600);
            frame.setBackground(Color.black);
            frame.setVisible(true);
            frame.addWindowListener(new WindowAdapter() {
                @Override
                public void windowClosing(WindowEvent e) {
                    //anim.stop();
                    System.exit(0);
                }
            });
        }
        //final Animator anim = new Animator(canvas);  // TODO
        //anim.start();
        final Thread animThread = new Thread(new Runnable() {
            @Override
            public void run() {
                while (true) {
                    for (Component c : canvasses) {
                        c.repaint();
                    }
                    Display.sync(60);
                }
            }
        });
        animThread.setDaemon(true);
        animThread.start();
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
