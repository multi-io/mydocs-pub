package de.oklischat.ajtest1;

import java.beans.PropertyChangeListener;

public interface PropEvtMethods {

    public void addPropertyChangeListener(PropertyChangeListener listener);

    public void addPropertyChangeListener(String propertyName, PropertyChangeListener listener);

}
