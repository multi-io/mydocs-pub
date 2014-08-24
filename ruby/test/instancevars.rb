class B
  def bb
    @b
  end

  def bb=(x)
    @b=x
  end
end


class C <B
  def cb
    @b
  end

  def cb=(x)
    @b=x
  end
end


module M
  def mb
    @b
  end

  def mb=(x)
    @b=x
  end
end



class X <C
  include M
end


c=C.new
c.bb = 1
c.cb = 2

x=X.new
x.bb = 1
x.cb = 2
x.mb = 3

print <<-EOS
#{c.bb}
#{c.cb}
#{x.bb}
#{x.cb}
#{x.mb}
EOS


# prints:
#
# 2
# 2
# 3
# 3
# 3
#
# => all instance variables of all inherited/included classes/modules
#    share one namespace
