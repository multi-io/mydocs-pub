# Ruby 1.8 -> 1.9 incompatibilities found during xml-mapping adaption to Ruby 1.9
 
puts "$: includes '.': #{$:.include? '.'}"

require 'rubygems/package_task'

$:
begin
  puts "foo"
rescue Exception
  puts "exception: #{e}"
end


# [[1,4,5],[2,8,10]].each {|(x,)| puts x}  #1.8 only
[[1,4,5],[2,8,10]].each {|x| puts x[0]}

snippet=">foo< >bar< >baz<"

#snippet.scan(/>(.*?)</) do |(switch,)|   #1.8 only
#  case switch
snippet.scan(/>(.*?)</) do |switches|
  case switches[0]
  when "foo"
    puts "foo found"
  when "baz"
    puts "baz found"
  end
end


#require 'company'  # works in 1.8 only. In 1.9, '.' isn't included in $" (see above).
require './company'

class B
  def initialize
    puts "B#initialize"
    Object.send(:remove_const, "Company")
    # $".delete "./company.rb"  # works in 1.8 only. In 1.9, $" contains absolute paths.
    $".delete_if{|name| name =~ %r!/company.rb$!}
    require './company'

    c = Company.new
    c.foo
  end
end

B.new


class Calltest
  def foo
    puts "Calltest#foo"
  end

  def redefine_foo
    class << self
      alias_method :default_foo, :foo
      def foo
        puts "redefined Calltest#foo; calling original..."
        self.method(:default_foo).call
      end
    end
  end

end


ct = Calltest.new
ct.foo
ct.redefine_foo
ct.foo



p = proc{|a,b,c| puts "p(#{a} #{b} #{c})"} #creates a lambda in 1.8, Proc in 1.9
# a Proc can be called with any number of arguments, a lambda can't

# => 2nd and 3rd call fail (ArgumentError) in 1.8
begin
  p.call 1,2,3
  p.call 1,2
  p.call 1,2,3,4
rescue ArgumentError => e
  puts "ArgumentError: #{e}"
end

l = lambda{|a,b,c| puts "l(#{a} #{b} #{c})"} #creates a lambda in 1.8 and 1.9

# => 2nd and 3rd call fail in 1.8 and 1.9
begin
  l.call 1,2,3
  l.call 1,2
  l.call 1,2,3,4
rescue ArgumentError => e
  puts "ArgumentError: #{e}"
end

p2 = Proc.new{|a,b,c| puts "p2(#{a} #{b} #{c})"} #creates a Proc in 1.8 and 1.9

# => all calls work in 1.8 and 1.9
begin
  p2.call 1,2,3
  p2.call 1,2
  p2.call 1,2,3,4
rescue ArgumentError => e
  puts "ArgumentError: #{e}"
end


### one codebase that works with procs and lambdas...

class Calltest2
  def initialize(overridden_foo)
    @overridden_foo = overridden_foo
    class << self
      alias_method :default_foo, :foo
      def foo(a,b)
        begin
          @overridden_foo.call(a,b,self.method(:default_foo))
        rescue ArgumentError  # thrown if the @overridden_foo is a lambda (i.e. no Proc) with !=3 args (e.g. proc{...} in ruby1.8)
          @overridden_foo.call(a,b)
        end
      end
    end
  end
  def foo(a,b)
    puts "default foo"
  end
end


ct2 = Calltest2.new proc{|a,b,default|
  puts "overridden foo " + (default ? ", calling default" : "")
  if default
    default.call(a,b)
  end
}


ct2.foo "foo", "bar"


ct22 = Calltest2.new proc{|a,b|
  puts "ct22 overridden foo, not calling default"
}


ct22.foo "foo", "bar"
