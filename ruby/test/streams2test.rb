require 'streams2'

class TestStream
  include Stream

  def initialize
    @val=1
  end

  def hasNext
    @val < 100
  end

  def next
    tmp = @val
    @val *= 2
    tmp
  end

end
