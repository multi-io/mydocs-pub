package de.oklischat.ajtest1;


public aspect SetterLogging {

    pointcut setterCall(Car car, double value): call(void Car.setLocation(double)) && target(car) && args(value);

    after(Car car, double value) returning: setterCall(car, value) {
        System.out.println("" + car + " now @" + value);
    }
}
