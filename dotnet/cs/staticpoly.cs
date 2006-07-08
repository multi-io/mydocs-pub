using System;

// C#-Generics haben keinen "statischen Polymorphismus" im C++-Sinn:

namespace oklischat.cstest {

    public interface FooHoster {
        void foo();
    }

    public class FooHosterImpl1: FooHoster {
        public void foo() {
            Console.Out.Write("foo called on {0}\n", this);
        }
    }

    public class FooCaller<T> where T: FooHoster {  //ohne das Constraint (where T: FooHoster) compilierts net
                                                    //(error CS0117: `T' does not contain a definition for `foo')
        private T t;

        public FooCaller(T t) {
            this.t = t;
        }

        public void callfoo() {
            t.foo();
        }
    }

    public class StaticPoly {
        public static void Main(string[] args) {
            FooHosterImpl1 fh = new FooHosterImpl1();
            FooCaller<FooHosterImpl1> fc = new FooCaller<FooHosterImpl1>(fh);
            fc.callfoo();
        }
    }
}


//Grund wahrscheinlich: Implementation von staischem Polymorphismus
//wäre nur möglich mit Laufzeit-"Code-Bloat" (Codegenerierung für
//jedes T, mit dem FooCaller<T> instanziiert wird). C# generiert aber
//nur einmal Code für alle Instanziierungen von FooCaller<T> mit
//_Referenztypen_ T. Dieser Code müsste den t.foo()-Aufruf dann über
//Reflection implementieren (da über T nix bekannt wäre), was nicht
//getan wird.
