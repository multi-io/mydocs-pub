require 'gplot/Gnuplot'
include Gnuplot


# gnuplot dataset for displaying a real function
class FunctionDataSet < DataSet

  def initialize (f, x0, x1, opts={"with"=>"lines"}, nsteps=1000)
    super("'-'", opts)
    @f = f
    @x0 = x0
    @x1 = x1
    @nsteps = nsteps
    @dx = (x1-x0)/nsteps
  end

  def writeData (f)
    # TODO: catch errors (undefinednesses)
    @nsteps.times { |i|
      x = @x0 + @dx*i
      y = @f.call(x)
      f.writeln(x.to_s + " " + y.to_s)
    }
  end
end
