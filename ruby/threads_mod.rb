#M.synchronize do
#Mutex.new.synchronize do


($m||=Mutex.new).synchronize do

  puts "#{Thread.current}: start"
  sleep 0.3
  puts "#{Thread.current}: stop"

end
