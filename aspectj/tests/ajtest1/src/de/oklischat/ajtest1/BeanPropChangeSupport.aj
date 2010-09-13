package de.oklischat.ajtest1;

import java.beans.PropertyChangeListener;
import java.beans.PropertyChangeSupport;
import java.lang.reflect.InvocationTargetException;


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


    pointcut setterExecution(Object target, Object newVal): execution(void *.set*(..)) && target(target) && args(newVal); // && @withincode(FiresPropChangeEvent);
    //pointcut setterExecution(): execution(void *.set*(..));
    //pointcut setterExecution(): call(void *.set*(..));


    void around(Object target, Object newVal): setterExecution(target, newVal) {
        String setterName = thisJoinPointStaticPart.getSignature().getName();
        String getterName = "get" + setterName.substring(3);
        String propName = setterName.substring(3,4).toLowerCase() + setterName.substring(4);
        Object oldValue;
        try {
            oldValue = target.getClass().getMethod(getterName).invoke(target);  //use direct field access instead?
        } catch (IllegalArgumentException e) {
            throw new RuntimeException(e.getLocalizedMessage(), e);
        } catch (SecurityException e) {
            throw new RuntimeException(e.getLocalizedMessage(), e);
        } catch (IllegalAccessException e) {
            throw new RuntimeException(e.getLocalizedMessage(), e);
        } catch (InvocationTargetException e) {
            throw new RuntimeException(e.getLocalizedMessage(), e);
        } catch (NoSuchMethodException e) {
            throw new RuntimeException(e.getLocalizedMessage(), e);
        }
        proceed(target, newVal);
        ((Car)target).firePropertyChange(propName, oldValue, newVal);
    }
}
