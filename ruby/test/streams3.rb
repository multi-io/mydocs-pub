class Stream

  attr_accessor :head, :tail

  def initialize(*args)
    @head,@tail = args
    @empty = args.empty?
  end

  def empty?
    @empty
  end

  def to_a
    if empty?
      []
    else
      [@head] + @tail.to_a
    end
  end

  def filter(&pred)
    if empty?
      self
    else
      if pred.call(head)
        Stream.new @head, @tail.filter(&pred)
      else
        @tail.filter(&pred)
      end
    end
  end

  def take n
    if 0==n
      Stream.new
    else
      Stream.new @head, @tail.take(n-1)
    end
  end

end


def nats_from n
  Stream.new n, nats_from(n+1)
end

Nats = nats_from 0

Evens = Nats.filter{|x| x%2==0}
Odds  = Nats.filter{|x| x%2==1}
