package de.oklischat.swt.test.browser;

import java.awt.GraphicsDevice;
import java.awt.GraphicsEnvironment;

import org.eclipse.swt.SWT;
import org.eclipse.swt.browser.Browser;
import org.eclipse.swt.browser.LocationEvent;
import org.eclipse.swt.browser.LocationListener;
import org.eclipse.swt.graphics.Point;
import org.eclipse.swt.graphics.Rectangle;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Text;

public class App {

	public static void main(String[] args) throws Exception {
        Display display = new Display();
		new App(display).run();
        display.dispose();
	}

	private final Display display;
	
	private Text addressBar;
	private Browser browser;
	private Label statusLine;

	public App(Display display) {
		this.display = display;
	}

	public void run() throws Exception {
        Shell parent = new Shell(display);
        parent.setText("SWT Browser test");
        //parent.setSize(900, 600);

        //center(parent);
        parent.setBounds(getFormFrameBounds());

        GridLayout gl = new GridLayout();
		gl.numColumns = 1;
		parent.setLayout(gl);

		GridData gd = new GridData();
		gd.horizontalAlignment = SWT.FILL;
		gd.grabExcessHorizontalSpace = true;
		gd.grabExcessVerticalSpace = false;
		addressBar = new Text(parent, SWT.SINGLE | SWT.BORDER);
		addressBar.setLayoutData(gd);

		gd = new GridData();
		gd.horizontalAlignment = SWT.FILL;
		gd.grabExcessHorizontalSpace = true;
		gd.verticalAlignment = SWT.FILL;
		gd.grabExcessVerticalSpace = true;
		browser = new Browser(parent, SWT.WEBKIT | SWT.BORDER);
		//browser = new Browser(parent, SWT.BORDER);
		//browser = new Browser(parent, SWT.MOZILLA | SWT.BORDER);
		browser.setLayoutData(gd);
		
		gd = new GridData();
		gd.horizontalAlignment = SWT.FILL;
		gd.grabExcessHorizontalSpace = true;
		gd.grabExcessVerticalSpace = false;
		statusLine = new Label(parent, SWT.LEFT | SWT.SHADOW_ETCHED_IN);
		statusLine.setLayoutData(gd);

		addressBar.addListener(SWT.DefaultSelection, new Listener() {
			@Override
			public void handleEvent(Event event) {
				String address = addressBar.getText();
				if (!(address.startsWith("http://") || address.startsWith("https://"))) {
					address = "http://" + address;
				}
				browser.setUrl(address);
			}
		});
		
		browser.addLocationListener(new LocationListener() {
			
			@Override
			public void changing(LocationEvent event) {
				statusLine.setText("loading " + event.location + " ...");
			}
			
			@Override
			public void changed(LocationEvent event) {
				if (event.top) {
					addressBar.setText(event.location);
				}
				statusLine.setText("Done.");
			}
		});

        parent.open();

        while (!parent.isDisposed()) {
          if (!display.readAndDispatch()) {
            display.sleep();
          }
        }
    }

    public void center(Shell shell) {
        Rectangle bds = shell.getDisplay().getBounds();
        Point p = shell.getSize();
        int nLeft = (bds.width - p.x) / 2;
        int nTop = (bds.height - p.y) / 2;
        shell.setBounds(nLeft, nTop, p.x, p.y);
    }

    private Rectangle getFormFrameBounds() {
        GraphicsDevice[] screens = GraphicsEnvironment.getLocalGraphicsEnvironment().getScreenDevices();
        int nScreens = screens.length;
    	java.awt.Rectangle b = screens[nScreens-1].getDefaultConfiguration().getBounds();
        java.awt.Rectangle awtBounds;
        if (nScreens > 1) {
        	awtBounds = b;
        } else {
        	awtBounds = new java.awt.Rectangle(b.x + b.width / 4, b.y + b.height / 4, b.width / 2, b.height / 2);
        }
        System.out.println("frame bounds: " + awtBounds);
        return new Rectangle(awtBounds.x, awtBounds.y, awtBounds.width, awtBounds.height);
    }
}
