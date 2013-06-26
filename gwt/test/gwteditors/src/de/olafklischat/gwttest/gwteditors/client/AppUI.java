package de.olafklischat.gwttest.gwteditors.client;

import com.google.gwt.core.client.GWT;
import com.google.gwt.dom.client.Element;
import com.google.gwt.dom.client.SpanElement;
import com.google.gwt.uibinder.client.UiBinder;
import com.google.gwt.uibinder.client.UiField;
import com.google.gwt.user.client.ui.UIObject;

public class AppUI extends UIObject {

    private static AppUIUiBinder uiBinder = GWT.create(AppUIUiBinder.class);

    interface AppUIUiBinder extends UiBinder<Element, AppUI> {
    }

    @UiField
    SpanElement nameSpan;

    public AppUI() {
        setElement(uiBinder.createAndBindUi(this));
    }
    
    public void setName(String name) {
        nameSpan.setInnerText(name);
    }

}
