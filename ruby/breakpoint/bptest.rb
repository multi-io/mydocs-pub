#!/usr/bin/ruby -w

require "/home/olaf/wind/providerxmls/providerxmls/config/environment"
require 'breakpoint'

Breakpoint.activate_drb


class Person

  def initialize(name)
    @name=name
  end

  def getname(lala)
    breakpoint("Person#getname")
    @name
  end

end



print "press key...\n"; readline

p=Person.new("Hugo")

print "name=#{p.getname('foo')}\n"
