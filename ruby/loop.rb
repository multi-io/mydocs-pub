def loop(initializer, iterator, continue_test, body)
  initializer.call
  while continue_test.call
    body.call
    iterator.call
  end
end

i=0
loop proc{i=0}, proc{i+=1}, proc{i<10}, proc{
  print i
}
