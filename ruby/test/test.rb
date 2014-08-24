#!/usr/bin/ruby

def test1(n)
  3*n
end


print "#{test1(8)}\n\n"

tm = method(:test1)

print "#{tm.call(5)}\n\n"

print "#{self}\n\n"

print "#{self.class}\n\n"
