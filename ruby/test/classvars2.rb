#!/usr/bin/ruby

module M

  def self.aax=(x)
    @@x=x
  end

  def self.aax
    @@x
  end


  def minst_aax=(x)
    @@x=x
  end

  def minst_aax
    @@x
  end
end


class C
  include M


  def cinst_aax=(x)
    @@x=x
  end

  def cinst_aax
    @@x
  end
end


M.aax=42
c=C.new
p c.cinst_aax   # 42
p c.minst_aax   # 42


## however (comment out the above and comment in the following):

#c=C.new
#c.cinst_aax=42
#p c.cinst_aax   # 42
#p c.minst_aax   # classvars2.rb:19:in `minst_aax': uninitialized class variable @@x in M (NameError)


## => class variables only visible downwards from the point where they
## were defined
