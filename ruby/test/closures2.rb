class C

  def initialize
    @x=42
  end

  def cl
    proc {
      print "#{@x}\n"
    }
  end

end




c=C.new
cl=c.cl


cl.call

@x = 23

cl.call


# prints 42\n42\n
