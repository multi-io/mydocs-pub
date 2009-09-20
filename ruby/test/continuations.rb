#!/usr/bin/ruby

def walk tree
  tree.each do |elt|
    if Enumerable===elt
      walk elt
    else
      callcc{|c| throw :elt_found,[elt,c]}
    end
  end
end


elt,c = catch(:elt_found) do
  walk [5,7,[3,[8,3,4,],8,5,6],[1,0,7,[[3,4,8],6,4,5],5,2],5,[1,6,7]]
  nil
end
if c
  puts elt
  c.call
end
