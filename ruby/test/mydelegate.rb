# call includeDelegationTo(delegate_class)
# from inside a class body to add methods
# with signatures of delegate_class's methods
# to that class. The generated implementations
# delegate the method calls to a delegator object
# obtained by calling get_delegate (which
# subclasses must define)
def includeDelegationTo(delegate_class)
  methods = delegate_class.instance_methods(true)
  methods -= ::Kernel.instance_methods
  methods |= ["to_s","to_a","inspect","==","=~","==="]
  for method in methods
    self.class_eval <<-EOS
        def #{method}(*args, &block)
          begin
            get_delegate.__send__(:#{method}, *args, &block)
	  rescue
            $@[0,2] = nil
            raise
	  end
	end
	EOS
  end
end
