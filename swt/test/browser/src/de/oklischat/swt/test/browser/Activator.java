package de.oklischat.swt.test.browser;

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
import org.osgi.framework.BundleActivator;
import org.osgi.framework.BundleContext;

/**
 * The activator class controls the plug-in life cycle
 */
public class Activator implements BundleActivator {

	// The plug-in ID
	public static final String PLUGIN_ID = "de.oklischat.swt.test.browser"; //$NON-NLS-1$

	// The shared instance
	private static Activator plugin;
	
	private Text addressBar;
	private Browser browser;
	private Label statusLine;

	/**
	 * The constructor
	 */
	public Activator() {
	}

    @Override
	public void start(BundleContext context) throws Exception {
		plugin = this;

        Display display = new Display();
        
        Shell parent = new Shell(display);
        parent.setText("SWT Browser test");
        parent.setSize(900, 600);

        center(parent);

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

        display.dispose();
        
        //shutdown OSGI container --
        // see http://stackoverflow.com/questions/1916432/best-way-to-shutdown-an-osgi-container-specifically-equinox
        context.getBundle(0).stop();
    }

    public void center(Shell shell) {
        Rectangle bds = shell.getDisplay().getBounds();
        Point p = shell.getSize();
        int nLeft = (bds.width - p.x) / 2;
        int nTop = (bds.height - p.y) / 2;
        shell.setBounds(nLeft, nTop, p.x, p.y);
    }

    @Override
	public void stop(BundleContext context) throws Exception {
		plugin = null;
	}

	/**
	 * Returns the shared instance
	 *
	 * @return the shared instance
	 */
	public static Activator getDefault() {
		return plugin;
	}

}
