#!/usr/bin/ruby

class Base
  @@basev = "base"

  def self.basev
    @@basev
  end

  def self.basev=(x)
    @@basev = x
  end

  def ibasev
    @@basev
  end

  def ibasev=(x)
    @@basev = x
  end
end




class Ext <Base
end



b = Base.new
b2 = Base.new

e = Ext.new
e2 = Ext.new


# p b.basev  ## ./classvars.rb:35: undefined method `basev' for #<Base:0x402a67a0> (NoMethodError)
             ##    => can't access class methods via instances


p Base.basev
p b.ibasev
p b2.ibasev
p Ext.basev
p e.ibasev
p e2.ibasev

b.ibasev = "basech1"
p Base.basev
p b.ibasev
p b2.ibasev
p Ext.basev
p e.ibasev
p e2.ibasev

# output: 6 x "base", then 6 x "basech1"
#  => class variables shared among all the hierarchy
