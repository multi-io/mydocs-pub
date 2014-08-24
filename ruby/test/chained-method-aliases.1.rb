class C

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

  wrapper = :wr1
  action = :meth

  wrapped_method = "_meth_doit"
  alias_method wrapped_method.intern, :meth

  class_eval <<-EOS2
         def #{action}
           #{wrapper.to_s}(:#{wrapped_method})
         end
  EOS2


end



C.new.meth
