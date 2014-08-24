module M
  @@cv = 42
  def self.append_features(base)
    super
    base.extend(ClassMethods)
  end
 
  ClassMethods = Module.new do
    def cv
      @@cv
    end

    def cv=(x)
      @@cv=x
    end
  end
end


class C
  include M

  puts cv
  self.cv=23
  puts cv
end


class C2
  include M

  puts self.cv
end


class C3
  include M
end


puts C3.cv  # 42 (should be 23?)

C3.class_eval "self.cv=38"

puts C3.cv
