module M
  @@cv = 42
  def self.append_features(base)
    super
    base.extend(ClassMethods)
  end
 
  ClassMethods = Module.new do
    def cm
      puts @@cv
    end
  end
end
 
class C
  include M
  cm
end
