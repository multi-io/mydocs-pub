#!/usr/bin/ruby


def print_module(mod)
  mod.instance_methods.each {|m|
    print "#{mod}.#{m}\n"
  }
  (mod.methods - (mod.ancestors - [mod]).map{|a|a.methods}.flatten).each {|m|
    print "#{mod}.#{m}    (class method)\n"
  }
end

def print_all_modules
  ObjectSpace.each_object(Module) {|mod|
    print_module(mod)
  }
end

def print_modules(name_match=nil)
  name_match = /#{name_match}/ if name_match.kind_of? String
  ObjectSpace.each_object(Module) {|mod|
    print_module(mod) if (if name_match then mod.name =~ name_match else yield(mod) end)
  }
end



if __FILE__ == $0
  print_all_modules
end
