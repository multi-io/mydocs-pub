package de.oklischat.ajtest1;


public class Main {

    /**
     * @param args
     */
    public static void main(String[] args) throws Exception {
        Car c1 = new Car("c1", 0, 15);
        Car c2 = new Car("c2", 0, 25);
        c1.driveFor(10);
        c2.driveFor(10);
        System.out.println("c1: " + c1);
        System.out.println("c2: " + c2);
    }

}
