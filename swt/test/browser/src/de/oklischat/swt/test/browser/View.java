package de.oklischat.swt.test.browser;

import org.eclipse.swt.SWT;
import org.eclipse.swt.browser.Browser;
import org.eclipse.swt.browser.LocationEvent;
import org.eclipse.swt.browser.LocationListener;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.Text;
import org.eclipse.ui.part.ViewPart;

public class View extends ViewPart {
	public static final String ID = "de.oklischat.swt.test.browser.view";

	private Text addressBar;
	private Browser browser;
	private Label statusLine;

	public View() {
		System.out.println("View ctor");
	}
	
	/**
	 * This is a callback that will allow us to create the viewer and initialize
	 * it.
	 */
	public void createPartControl(Composite parent) {
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
	}

	/**
	 * Passing the focus request to the viewer's control.
	 */
	public void setFocus() {
		addressBar.setFocus();
	}
}