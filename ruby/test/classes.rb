def callf(obj)
  obj.f
end

def runtest

  s = "hello"
  class <<s
    def f
      "I am s.f"
    end
  end

  callf(s)
end



# error: "class definition in method body"
# def defclass
#   class DefdClass
#     def f
#       "DefdClass.f"
#     end
#   end
# end



class CDefsTest

  def initialize
    def self.m
      "CDefsTest.m"
    end
  end

end


class C1
  class C2
  end
end
# => C1::C2


# error: nested method definition
# def m1
#   def m2
#     "m2"
#   end
#   "m1"
# end

def m3
  def self.m4
    "m4"
  end
  "m3"
end

