module Enumerable
  def mymap(&block)
    slf = self
    Class.new {
      include Enumerable
      define_method(:each) {
        slf.each do |elt|
          out = block.call(elt)
          puts "#{elt} => #{out}"
          yield(out)
        end
      }
    }.new
  end
end
