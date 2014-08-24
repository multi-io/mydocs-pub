def foldl(enum, start)
  result = start
  enum.each {|x| result = yield(result,x)}
  result
end

# foldl([4,5,6,7,8], 0){|x,y| x+y}  => 30


def lfoldl(func,start)
  lambda { | enum |
    result = start
    enum.each {|x| result = func.call(result,x)}
    result
  }
end

# lfoldl(lambda{|x,y| x+y}, 0).call([4,5,6,7,8])  => 30


@lmult=lfoldl(lambda{|x,y| x*y}, 1)

# @lmult.call([5,3,5,2,4])  => 600

def lfac(n)
  @lmult.call(1..n)
  # won't work without the "@" in the @lmult identifier??
end

