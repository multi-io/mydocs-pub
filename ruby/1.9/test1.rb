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



class Node
  def initialize(reader)
    @reader = reader
    class << self
      alias_method :default_xml_to_obj, :xml_to_obj
      def xml_to_obj(obj,xml)
        begin
          @reader.call(obj,xml)
        rescue ArgumentError
          @reader.call(obj,xml,self.method(:default_xml_to_obj))
        end
      end
    end
  end
  def xml_to_obj(obj,xml)
    puts "default xml_to_obj"
  end
end


n = Node.new proc{|obj,xml,default|
  puts "overridden reader, calling default..."
  default.call(obj,xml)
}


n.xml_to_obj "foo", "bar"
