#(potentially) infinite streams, 2nd try

# stream with cursor
# subclasses must define hasNext(), next()
# call Enumerable methods (like this one) for finite streams only!
module Stream
  include Enumerable

  # excute block for each element of the stream
  def each
    while self.hasNext()
      yield(self.next())
    end
  end

end


class NatsStream
  include Stream

  def initialize
    @val=-1
  end

  def hasNext
    1
  end

  def next
    @val += 1
    @val
  end

end


class TakeNStream
  include Stream

  def initialize(n, str)
    @n = n
    @pos = 0
    @str = str
  end

  def hasNext
    @pos < @n
  end

  def next
    @pos += 1
    @str.next
  end

end


# should probably be applied to infinite streams only
class FilterStream
  include Stream

  def initialize(str, ffunc)
    @str = str
    @ffunc = ffunc
  end

  def hasNext
    # impossible to tell for sure
    # (@str might haveNext, none of which satisfy ffunc
    # @str.hasNext
    1
  end

  def next
    
  end

end
