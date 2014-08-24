# 17:15 < multi_io> could it be that class methods defined in modules are not 
#                   inherited by classes which include that module?
# 17:15 < multi_io> s/in modules/in a module/
# 17:15 < chris2> multi_io: correct
# 17:16 < multi_io> chris2: hm. Is there a special reason for that?
# 17:16 < chris2> probably, but i dont know

module M
    
  def self.cm1
    p ">>cm1"
  end


  ## this is the workaround
  def self.append_features(base) #:nodoc:
    super
    base.extend(ClassMethods)
  end

  module ClassMethods
    def cm2
      p ">>cm2"
    end
  end

end


class B
  def self.cm3
    p ">>cm3"
  end
end



class C < B
  include M

  cm2   # works
  cm3   # works
  cm1   # doesn't work ("undefined local variable or method `cm1' for C:Class")
end
