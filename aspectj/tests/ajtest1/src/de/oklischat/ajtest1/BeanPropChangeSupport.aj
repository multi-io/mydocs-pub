package de.oklischat.ajtest1;

import java.beans.PropertyChangeListener;
import java.beans.PropertyChangeSupport;


public aspect BeanPropChangeSupport {

    //TODO: how to use "all classes annotated with @PropChangeEventSupport" rather than Car?

    //the following results in a compiler error in the IDE but works when compiling with ajc on the command line
    // apparently the IDE thinks "this" is the BeanPropChangeSupport instance (hence the error), but ajc correctly takes it as the target Car instance
    //private PropertyChangeSupport Car.propChangeSupport = new PropertyChangeSupport((this instanceof Car));

    private PropertyChangeSupport Car.propChangeSupport = new PropertyChangeSupport(this);

    public void Car.addPropertyChangeListener(PropertyChangeListener listener) {
        this.propChangeSupport.addPropertyChangeListener(listener);
        System.out.println("propChangeEvent added");
    }

    public void Car.addPropertyChangeListener(String propertyName, PropertyChangeListener listener) {
        this.propChangeSupport.addPropertyChangeListener(propertyName, listener);
    }
    
    public void Car.firePropertyChange(String propertyName, Object oldValue, Object newValue) {
        this.propChangeSupport.firePropertyChange(propertyName, oldValue, newValue);
    }


    pointcut setterExecution(Object target): execution(void *.set*(..)) && target(target); // && @withincode(FiresPropChangeEvent);
    //pointcut setterExecution(): execution(void *.set*(..));
    //pointcut setterExecution(): call(void *.set*(..));


    after(Object target) returning: setterExecution(target) {
        //System.out.println("returning JP: " + thisJoinPoint + " on " + target);
        ((Car)target).firePropertyChange(thisJoinPointStaticPart.getSignature().getName(), "old", "new");
    }
}
