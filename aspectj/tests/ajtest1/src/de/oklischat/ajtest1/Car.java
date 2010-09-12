package de.oklischat.ajtest1;


public class Car {

    private String name;
    private double location, speed;
    
    public Car(String name) {
        this(name, 0, 10);
    }
    
    public Car(String name, double location, double speed) {
        setName(name);
        setLocation(location);
        setSpeed(speed);
    }


    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }

    public double getLocation() {
        return location;
    }
    
    public void setLocation(double location) {
        this.location = location;
    }
    
    public double getSpeed() {
        return speed;
    }
    
    public void setSpeed(double speed) {
        this.speed = speed;
    }

    public void driveFor(double time) {
        setLocation(getLocation() + getSpeed() * time);
    }

    @Override
    public String toString() {
        return "[car " + name + " @" + location + " going " + speed + "]";
    }
}
