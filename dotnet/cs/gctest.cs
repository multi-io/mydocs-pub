using System;
using System.Threading;

namespace oklischat.cstest {

    public class C: IDisposable {
        
        public void Dispose() {
            Console.WriteLine("Dispose()...");
            Dispose(true);
            GC.SuppressFinalize(this);
            Console.WriteLine("Dispose() done");
        }

        void Dispose(bool disposing) {
            Console.WriteLine("Dispose({0})",disposing);
        }

        ~C() {
            Console.WriteLine("~C()");
        }
    }

    public class GCTest {
        public static void Main(string[] args) {
            using (C c = new C()) {
                Console.WriteLine("using c...");
            }
            Console.WriteLine("using c done.");


            Console.WriteLine("collecting...");
            GC.Collect();
            Thread.Sleep(500);
            Console.WriteLine("done.");
        }
    }
}
