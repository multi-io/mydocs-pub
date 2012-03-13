package oklischat.gradle;

import oklischat.gradle.multiprjtest.common.WiseCracker;
import oklischat.gradle.multiprjtest.calc.Calculator;

public class HW {

    public static void main(String[] args) throws Exception {
        System.out.println("HW! " + WiseCracker.getWisdom());
        System.out.println("  direct calc: 1+1=" + Calculator.add(1,1));
    }

}
