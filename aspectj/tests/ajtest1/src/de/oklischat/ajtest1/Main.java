package de.oklischat.ajtest1;

import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;


public class Main {

    private static PropertyChangeListener loggingPCL = new PropertyChangeListener() {
        
        @Override
        public void propertyChange(PropertyChangeEvent evt) {
            System.out.println("PropChangeEvt: src=" + evt.getSource() + ", prop=" + evt.getPropertyName() +
                               ", old=" + evt.getOldValue() + ", new=" + evt.getNewValue());
        }
    };
    
    /**
     * @param args
     */
    public static void main(String[] args) throws Exception {
        Car c1 = new Car("c1", 0, 15);
        c1.addPropertyChangeListener(loggingPCL);
        Car c2 = new VW("vw2", 0, 25);
        c2.addPropertyChangeListener(loggingPCL);
        c1.driveFor(10);
        c2.driveFor(10);
        c1.setLocation(500);
        c1.driveFor(20);
        c2.setSpeed(-4);
        c2.driveFor(12);
        System.out.println("c1: " + c1);
        System.out.println("c2: " + c2);
    }

}
