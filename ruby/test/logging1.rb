def addLoggingTo(klass)
  methods = klass.instance_methods(true)
  methods -= ::Kernel.instance_methods
  methods |= ["to_s","to_a","inspect","==","=~","==="]
  for method in methods
    klass.class_eval <<-EOS
        alias_method :#{method}_orig, #{method}

        def #{method}(*args, &block)
          begin
	    print "LOG: calling #{method} on #{self} with arguments ";
            result = self.__send__(:#{method}_orig, *args, &block)
            print "LOG: result of calling #{method} on #{self} with arguments  was #{result}"
            return result
	  rescue
            $@[0,2] = nil
            raise
	  end
	end
	EOS
  end
end
