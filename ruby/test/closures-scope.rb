#!/usr/bin/ruby




n=10

## stack overflow (p calls itself)
# p=proc{0}

# (0..n).each do |x|
#   p = proc{ x +p.call}
# end




# ## works, but clumsy (because of the "superproc")
# p=proc{0}

# def superproc(x,p)
#   proc{ x +p.call}
# end

# (0..n).each do |x|
#   p = superproc(x,p)
# end

p=proc{0}
(0..n).each do |x|
  pprev = p
  p = proc{ x + pprev.call }
end


print p.call
