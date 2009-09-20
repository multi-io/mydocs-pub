#!/usr/bin/ruby

require 'thread'

#M=Mutex.new

threads = (0...7).map do
  Thread.new { sleep rand; load "threads_mod.rb" }
end

threads.each{|t| t.join}
