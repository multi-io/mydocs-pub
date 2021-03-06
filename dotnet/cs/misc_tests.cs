using System;
using System.Collections.Generic;


namespace oklischat.cstest {

    public class Test {
        void inc(ref int i) {
            i++;
        }

        void partest(int i, params object[] ds) {
            Console.Out.Write("i={0}\n", i);
            Console.Out.Write("{0} ds:\n", ds.Length);
            foreach (object d in ds) {
                Console.Out.Write("{0}\n", d);
            }
        }


//         //error CS0504: The constant `oklischat.cstest.Test.cj' cannot be marked static
//         // ("static" is implicit for constants)
//         static const int ci = 42;
//         static const int cj = ci + 5;

//         //error CS0236: A field initializer cannot reference the nonstatic field, method, or property `oklischat.cstest.Test.ci'
//         int ci = 42;
//         int cj = ci + 5;


        const int ci = 42;
        const int cj = ci + 5;

        //boxing.cs(34,21): error CS8025: Parsing error
//         const int cf(int i) {
//             return i+10;
//         }

//         const int ck = cf(cj);

        //error CS0106: The modifier `readonly' is not valid for this item
//         readonly int rf(int i) {
//             return i+10;
//         }


        public delegate void MyEventType(int arg1, double arg2);

        public event MyEventType myevt;


        public void handler(/*const (unspported)*/ int arg1, double arg2) {
            Console.Out.Write("handler, args={0} {1}\n", arg1, arg2);
        }

        public Test() {
            int i = 42;
            object io = (object)i;
            int j = (int)io;

            i++;
            Console.Out.Write("{0} {1}\n", i,j);
            inc(ref i);
            Console.Out.Write("{0} {1}\n", i,j);
            i*=i; i*=i; /*checked {*/ i*=i; /*}*/
            Console.Out.WriteLine("i enlarged: {0}", i);

            partest(42,3.5,6.7,7.6,"hello");
            partest(42,new object[]{3.5,6.7,7.6},"hello");

            Console.Out.Write("cj={0}\n", cj);

            const int ci=23;
            Console.Out.WriteLine("ci={0}\n", ci);

            Console.Out.Write("explicit delegate call...\n");
            MyEventType methPointer = new MyEventType(handler);
            methPointer(100,33.332);

            Console.Out.Write("call via event...\n");
            myevt += new MyEventType(handler);
            myevt += new MyEventType(handler);
            myevt += new MyEventType(handler);
            OtherClass oc = new OtherClass();
            myevt += new MyEventType(oc.OtherHandler);

            myevt += delegate(int i, double d) {
                Console.Out.Write("anon delegate, args={0} {1}\n", i, d);
            };

            myevt(42, 23.55);

            closureTest();
            enumTest();
        }


        public delegate int Getter();  //QU: how to get rid of this
                                       //declaration and define
                                       //delegate types in-place?

        public Getter getIncrementor() {
            int i=0;
            return delegate {
                return i++;
            };
        }
        
        public void closureTest() {
            Getter incr1 = getIncrementor();
            Getter incr2 = getIncrementor();
            Console.Out.Write("next={0}\n", incr1());
            Console.Out.Write("next={0}\n", incr1());
            Console.Out.Write("next={0}\n", incr2());
            Console.Out.Write("next={0}\n", incr2());
            Console.Out.Write("next={0}\n", incr2());
            Console.Out.Write("next={0}\n", incr2());
            Console.Out.Write("next={0}\n", incr1());
        }


        public IEnumerable<int> SomeNumbers() {
            yield return 42; yield return 23; yield break;
        }

        public void enumTest() {
            foreach (int i in SomeNumbers()) { Console.WriteLine("{0}",i); }
        }


        public static void Main(string[] args) {
            new Test();
        }

    }


    public class OtherClass {
        public void OtherHandler(int arg1, double arg2) {
            Console.Out.Write("OtherHandler, args={0} {1}\n", arg1, arg2);
        }
    }
}
