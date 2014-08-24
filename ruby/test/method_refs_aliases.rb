#!/usr/bin/ruby

class C

  def m1
    print "m1\n"
  end

  def m2
    print "m2, calling m1\n"
    m1
  end
end



c=C.new

c.m2



class C

  def m1
    print "m1 rewritten\n"
  end


  def m3
    print "m3, calling m1_old\n"
    m1_old
  end
    
end

c.m2


# output so far:
#
# m2, calling m1
# m1
# m2, calling m1
# m1 rewritten
#
# => method reference (from m2 to m1) is "by name",
#    not "by code reference", unless m1 was
#    somehow replaced "in place"

begin
  c.m3
rescue => detail
  print detail.message+":\n"+detail.backtrace.join("\n")+"\n"
end

class C

  alias_method :m1_old, :m1

  def m1
    print "m1 new, calling m1 old\n"
    m1_old
  end

end


c.m2

c.m3

# further output:
#
# m3, calling m1_old
# undefined local variable or method `m1_old' for #<C:0x402a5e90>:
# ./method_aliases.rb:32:in `m3'
# ./method_aliases.rb:52
# m2, calling m1
# m1 new, calling m1 old
# m1 rewritten
# m3, calling m1_old
# m1 rewritten
#
# => definetely rules out the "by code reference" hypothesis
