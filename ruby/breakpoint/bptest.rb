#!/usr/bin/ruby -w
# start client with something like:
#  ruby -r/home/olaf/wind/providerxmls/providerxmls/config/environment.rb /usr/lib/ruby/gems/1.8/gems/rails-0.9.1/lib/breakpoint_client.rb

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
