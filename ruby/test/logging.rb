# include this into classes/modules whose methods should be logged,
#  then call "add_logging" to enable logging for all instance methods
#  defined in that class, or for all methods provided as parameters
module Logging

  def self.included(target_class)
    super
    target_class.extend(ClassMethods)
  end


  module ClassMethods

    def add_logging(methods = self.instance_methods(false))
      for method in methods
        self.module_eval <<-EOS
          alias_method :#{method}_orig, :#{method}
          
          def #{method}(*args, &block)
            call_descr = "#{method} on \#{self} with arguments (\#{args.join(',')})"
            begin
              STDERR.print "LOG: calling \#{call_descr}\n"
              result = self.__send__(:#{method}_orig, *args, &block)
              STDERR.print "LOG: result of calling \#{call_descr} was: \#{result}\n"
              return result
            rescue => err
              STDERR.print "LOG: exception when calling \#{call_descr}:
                            \#{err.message}\n\#{err.backtrace.join('\n')}\n"
              $@[0,2] = nil # restore original stack trace
              raise
            end
          end
        EOS
      end
    end

  end

end
