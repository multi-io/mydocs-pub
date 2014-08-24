#p(members,limit,intervalsize) =
#  intervalsize * members/limit * (1-(members-1)/(limit-1)) * (1-(members-1)/(limit-2)) ... * (1-(members-1)/(limit-intervalsize+1))

#  =

#    intervalsize * members/limit * PI_{i=1..intervalsize-1} (1-(members-1)/(limit-i))


# probability that exactly one number occurs in an interval of size
# intervalsize in a sampling with parameters members and limit
def p(members,limit,intervalsize)
  (1...intervalsize).inject(intervalsize * members/limit){|x,i|
    x * (1-(members-1)/(limit-i))
  }
end



def p_n(members,limit,intervalsize,n_intervals)
  # p(members,limit,intervalsize) * p(members-1,limit-intervalsize,intervalsize) * ...
  res = 1
  (0..n_intervals).each do |n|
    res *= p(members-n,limit-n*intervalsize,intervalsize)
  end
  res
end
