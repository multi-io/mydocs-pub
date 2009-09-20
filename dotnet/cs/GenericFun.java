import java.awt.Component;
import javax.swing.JPanel;

public class GenericFun<T> {

    private final T param;
    private GenericFun(final T param){
        this.param=param;
    }

    @Override
    public String toString(){
        return toString(getClass().getTypeParameters())
            +" = "+param.getClass();
    }
    
    private String toString(final Object[] objects){
        final StringBuilder b = new StringBuilder(200);
        for(final Object o : objects){
            if(b.length()>0){b.append(", ");}
            b.append(o);
        }
        return b.toString();
    }
    
    public static void main(final String[] args){
        System.out.println(new GenericFun<Component>(new JPanel()));
    }
}
