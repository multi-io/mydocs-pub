interface Func {
    public int run(int param);
}

public class closures3 {

    public static Func accum(int start) {
        final int[] curr = {start};
        return new Func() {
                public int run(int param) {
                    curr[0] += param;
                    return curr[0];
                }
            };
    }

    public static void main(String[] args) {
        Func acc1 = accum(0);

        System.out.println("a1 "+acc1.run(3));
        System.out.println("a1 "+acc1.run(5));

        Func acc2 = accum(10);

        System.out.println("a2 "+acc2.run(1));

        System.out.println("a1 "+acc1.run(2));

        
        System.out.println("a2 "+acc2.run(7));
        
        System.out.println("a1 "+acc1.run(10));
        
        System.out.println("a2 "+acc2.run(4));
    }

}
