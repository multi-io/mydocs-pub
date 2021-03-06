#!/usr/bin/ruby -w

# a new space rocket is built and test-flown N_TRIES
# times. N_TRIES*OBSERVED_RATE of those flights succeed, the others
# fail. So the "observed success rate" of this rocket is
# OBSERVED_RATE, the *real success rate* is unknown. How would the
# expected value of the real success rate be distributed based on this
# data?

N_TRIES=10
OBSERVED_RATE=8.0/10

def rates_generator_coroutine
  cont = callcc{|mycont| return mycont}
  while true
    real_rate = rand
    successes = 0
    N_TRIES.times {
      if rand < real_rate
        successes += 1
      end
    }
    if (successes.to_f/N_TRIES - OBSERVED_RATE).abs < 0.0001
      # print "datapoint: #{real_rate}\n"
      cont = callcc{|mycont| cont.call(real_rate,mycont)}
    end
  end
end


@cont = rates_generator_coroutine

next_sample = proc {
  rate,@cont = callcc{|mycont|@cont.call(mycont)}
  rate
}


# print "sample1: #{next_sample.call}\n"
# print "sample2: #{next_sample.call}\n"
# print "sample3: #{next_sample.call}\n"


require "rands"

plotRandHistogram(calcRandHistogram(next_sample,0.0,1.0,100,5000), (ARGV[0] or nil))
