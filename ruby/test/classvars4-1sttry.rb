module M

  @@cv = 42

  def self.append_features(base)
    super
    base.extend(ClassMethods)
  end

  module ClassMethods
    def cm2
      puts @@cv
    end
  end

end


class C
  include M
  cm2  # => should print 42, but:
       #   in `cm': uninitialized class variable @@cv in M::ClassMethods (NameError)
end
