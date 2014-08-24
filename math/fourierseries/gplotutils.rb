require 'gplot/Gnuplot'
include Gnuplot


# gnuplot dataset for displaying a real (Ruby) function f:Float->Float
class RealFunction < DataSet

  def initialize (f, x0, x1, opts=nil, nsteps=1000)
    opts ||= {}
    opts["with"] ="lines" unless opts.include? "with"
    super("'-'", opts)
    @f = f
    @x0 = x0
    @x1 = x1
    @nsteps = nsteps
    @dx = (x1-x0)/nsteps
  end

  def writeData (f)
    # TODO: if f is undefined for all x in [@x0,some_x], then
    #       [@x0,some_x] isn't included in the plot at all.
    #       This *might* be undesired.
    firsterr = true
    @nsteps.times { |i|
      x = @x0 + @dx*i
      begin
	y = @f.call(x)
	f.writeln(x.to_s + " " + y.to_s)
	firsterr = true
      rescue StandardError
	# only one empty line for "unplottet" intervals (see gnuplot documentation)
	f.writeln("") if (firsterr)
	firsterr = false
      end
    }
  end
end
