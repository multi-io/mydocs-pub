package de.oklischat.ajtest1;

public class VW extends Car {

    private double inspectionDistance = 200;
    private int nDoneInspections = 0;
    
    public VW(String name, double location, double speed) {
        super(name, location, speed);
    }

    public VW(String name) {
        super(name);
    }


    @Override
    public void setLocation(double location) {
        super.setLocation(location);
        double overDist = location - nDoneInspections * inspectionDistance;
        if (overDist > 0) {
            int nNeededInsps = (int)(overDist / inspectionDistance + 1);
            System.out.println("" + this + ": getting " + nNeededInsps + " inspections");
            nDoneInspections += nNeededInsps;
        }
    }
    
    @Override
    public void driveFor(double time) {
        super.driveFor(time);
    }
}
