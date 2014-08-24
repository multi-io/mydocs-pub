#!/usr/bin/ruby
#  problem: singleton can't be dumped (TypeError)
#  possible solution: overriding dump, load, like so:

class C
end

o=C.new
class <<o
  attr_accessor :str
end

o.str = "hello_world"

# o2 = Marshal.load(Marshal.dump(o))   # this would give the above error

class C
  def _dump(depth = -1)
    self.str
  end

  def self._load(str)
    res=C.new
    class <<res
      attr_accessor :str
    end
    res.str = str
    res
  end

end

o2 = Marshal.load(Marshal.dump(o))

p o2.str
