#!/usr/bin/ruby

# like closures-scope.rb, but creates the proc using "eval"
#  (for testing whether this works -- so one could generate the
#  ruby code dynamically)


n=10

p=proc{0}
(0..n).each do |x|
  pprev = p
  p = eval "proc{ x + pprev.call }"
end

print p.call
