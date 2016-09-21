package oklischat.gradle;

import oklischat.gradle.multiprjtest.common.WiseCracker;
import oklischat.gradle.multiprjtest.calc.Calculator;
import org.apache.log4j.Logger;

public class HW {

    static final Logger log = Logger.getLogger(HW.class);

    public static void main(String[] args) throws Exception {
        System.out.println("xport=" + System.getProperty("xport"));
        System.out.println("HW! " + WiseCracker.getWisdom());
        System.out.println("  direct calc: 1+1=" + Calculator.add(1,1));
        log.info("direct log4j (which is a dependency of calc)");
    }

}
