package oklischat.gradle.multiprjtest.calc;

import org.apache.log4j.Logger;

public class Calculator {

    static final Logger log = Logger.getLogger(Calculator.class);

    public static int add(int x, int y) {
        log.info("adding: " + x + " + " + y);
        return x+y;
    }
}
