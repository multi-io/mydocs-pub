#!/usr/bin/ruby

# see: Andrew Tanenbaum, "Computer networks", 3rd edition, p. 78ff

include Math

module Enumerable
  def sum
    inject(0) {|x,y|x+y}
  end
end

# in:
#   f:  Float->Float
#   t0,t1: Float
#   ns: [n1,n2,...nx] (list of Fixnum)
#   nsteps: Fixnum
#
# out: [as,bs,c] where
#   as == [a_n1,a_n2,...a_nx]
#   bs == [b_n1,b_n2,...b_nx]
#   c  == c
#
# s.t.
#   \forall t \in [t0,t1]:
#      f(t) == 0.5c + \sum{n=1}{\inf}{a_n*sin(2*PI*n*(t-t0)/(t1-t0))} + \sum{n=1}{\inf}{b_n*cos(2*PI*n*(t-t0)/(t1-t0))}
#
# nsteps == number of steps for internal numerical integrations
def fourier_analysis(f, t0, t1, ns, nsteps=10000)
  t=t1-t0
  c=2.0/t*numint(f,t0,t1)
  as = ns.map{|n|
    2.0/t * numint(proc{|x|f.call(x)*sin(2*PI*n*(x-t0)/(t1-t0))},
                   t0,t1)
  }
  bs = ns.map{|n|
    2.0/t * numint(proc{|x|f.call(x)*cos(2*PI*n*(x-t0)/(t1-t0))},
                   t0,t1)
  }
  [as,bs,c]
end


def numint(f,x0,x1,nsteps=10000)
  res=0.0; x=x0; dx=(x1-x0)/nsteps
  nsteps.times{
    res += f.call(x)*dx
    x += dx
  }
  res
end



# reverse of "fourier_analysis", i.e. take some coefficients
#  (c, and a_n, b_n for some n's) and an interval [t0,t1], and
#  return the corresponding function (fourier sum), which
#  will be a more or less good approximation of the original
#  function submitted to fourier_analysis to obtain the (as,bs,c).
def fourier_analysis_reverse(ns,as,bs,c, t0, t1)
  proc{|x|
    0.5*c + ns.map{|n| as[n-1]*sin(2*PI*n*(x-t0)/(t1-t0)) +
                       bs[n-1]*cos(2*PI*n*(x-t0)/(t1-t0))
                  }.sum
  }
end


if __FILE__ == $0

  # 01100010
  f=proc{|x|
    xi=x.to_i
    if (xi==1 or xi==2 or xi==6)
      1.0
    else
      0.0
    end
  }

  as,bs,c = fourier_analysis(f, 0.0, 8.0, (1..15))

  fapprox = fourier_analysis_reverse((1...8),as,bs,c, 0.0, 8.0)

  require "gplotutils"
  plot = Plot.new(ARGV[0] || nil)
  plot.title("fourier analysis")
  plot.xlabel("time")
  plot.ylabel("signal")
  plot.draw(FunctionDataSet.new(f,0.0,8.0),
            FunctionDataSet.new(fapprox,0.0,8.0))
  readline
end
