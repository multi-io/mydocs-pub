#infinite streams, 1st try (using Enumerable)


class AllNats
  include Enumerable

  def each
    x=0
    while 1
      yield(x)
      x += 1
    end
  end

end


class TakeN
  include Enumerable

  def initialize(n,input)
    @n = n
    @input = input
  end

  def each
    i=0
    @input.each \
    { | x |
      yield(x) if i<@n
      i += 1
      # runs infinitely...
      # need a way to "abort" blocks...
      # Enumerables have no "cursor"
    }
  end

end



