#!/usr/bin/ruby

INTERVAL=200
N_INTERVALS=5_000_000

found=0
begin
  last=0; count=0;
  while num=STDIN.readline.to_i
    new=num/INTERVAL
    if new==last then
      count+=1
    else
      last=new
      found+=1 if count==1
      count=1
    end
  end
rescue EOFError
end
found+=1 if count==1

puts found.to_f/N_INTERVALS
