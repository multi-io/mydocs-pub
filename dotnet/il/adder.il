//add two numbers 1 and 3
.assembly hello {}
.assembly extern mscorlib {}
.class public hello 
{
    .method static public void main() {
         .entrypoint
        .maxstack 2
        .locals(int32 V_0, int32 V_1) //declare two local variables
        ldc.i4.1 //put number  1 on the stack
        ldc.i4.3 //put number 3 on the stack
         add //add takes care of the second value on the local stack
         call void [mscorlib]System.Console::WriteLine(int32)
        ret
     }
}
