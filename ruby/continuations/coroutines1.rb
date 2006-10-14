#!/usr/bin/ruby -w

def generator
  cont = callcc{|mycont| return mycont}

  cont = callcc{|mycont| cont.call(5, mycont)}
  cont = callcc{|mycont| cont.call(10,mycont)}
  cont = callcc{|mycont| cont.call(15,mycont)}
  cont = callcc{|mycont| cont.call(20,mycont)}
  cont = callcc{|mycont| cont.call(25,mycont)}
  print "PLING!\n"
end


cont = generator
unless cont
  print "PLONG!\n"
  exit
end

rate,cont = callcc{|mycont|cont.call(mycont)}
print "value1: #{rate}\n"

rate,cont = callcc{|mycont|cont.call(mycont)}
print "value2: #{rate}\n"

rate,cont = callcc{|mycont|cont.call(mycont)}
print "value3: #{rate}\n"

rate,cont = callcc{|mycont|cont.call(mycont)}
print "value4: #{rate}\n"

rate,cont = callcc{|mycont|cont.call(mycont)}
print "value5: #{rate}\n"

rate,cont = callcc{|mycont|cont.call(mycont)}
print "value6: #{rate}\n"

rate,cont = callcc{|mycont|cont.call(mycont)}
print "value7: #{rate}\n"

# $ ./coroutines1.rb
# value1: 5
# value2: 10
# value3: 15
# value4: 20
# value5: 25
# PLING!
# PLONG!
# $
