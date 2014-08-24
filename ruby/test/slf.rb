#!/usr/bin/ruby

print "self=#{self}\n"
print "self.type=#{self.type}\n"
print "self.type.type=#{self.type.type}\n"

# print "self.name=#{self.name}\n" # undefined method `name' for #<Object:0x...> (NameError)


class C

  print "in class C:\n"
  print "self=#{self}\n"
  print "self.type=#{self.type}\n"
  print "self.type.type=#{self.type.type}\n"

  print "self.name=#{self.name}\n"
  print "self.name.type=#{self.name.type}\n"

end
