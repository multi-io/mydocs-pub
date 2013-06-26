package de.olafklischat.gwttest.gwteditors.client;

import com.google.gwt.core.client.GWT;
import com.google.gwt.uibinder.client.UiBinder;
import com.google.gwt.uibinder.client.UiField;
import com.google.gwt.user.client.ui.Composite;
import com.google.gwt.user.client.ui.ListBox;
import com.google.gwt.user.client.ui.Widget;

public class AppUI extends Composite {

    private static AppUIUiBinder uiBinder = GWT.create(AppUIUiBinder.class);

    interface AppUIUiBinder extends UiBinder<Widget, AppUI> {
    }

    @UiField
    ListBox listBox;

    public AppUI() {
        initWidget(uiBinder.createAndBindUi(this));
    }
    
    public void setNames(String... names) {
        for (String name : names) {
            listBox.addItem(name);
        }
    }

}
