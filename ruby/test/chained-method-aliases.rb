class C

  def self.uniquely_alias_method(m)
    namebase = m.to_s; n=1
    begin
      name = "_#{namebase}_#{n}".intern
      n += 1
    end while method_defined?(name)
    alias_method name, m
    name
  end

  def meth
    puts "m"
  end

  def wr1(wrapped_action)
    puts "wr1 in"
    self.send wrapped_action
    puts "wr1 out"
  end

  def wr2(wrapped_action)
    puts "wr2 in"
    self.send wrapped_action
    puts "wr2 out"
  end

  wrapped_method = uniquely_alias_method :meth

  class_eval <<-EOS
    def meth
      wr1(:#{wrapped_method})
    end
  EOS

  wrapped_method = uniquely_alias_method :meth

  class_eval <<-EOS
    def meth
      wr2(:#{wrapped_method})
    end
  EOS


end



C.new.meth
