def cltest
  a=7
  geta = proc { a }
  print "cltest-1 - #{geta.call}\n"
  a=12
  print "cltest-2 - #{geta.call}\n"
  geta
end


print "main - #{cltest.call}\n"
