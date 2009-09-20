class Array
  def each_pair &block
    case self.length
    when 0,1
      raise "array too short for that"
    when 2
      block.call(self)
    else
      tail = self[1..-1]
      tail.each {|x| block.call [self[0],x] }
      tail.each_pair &block
    end
  end
end
