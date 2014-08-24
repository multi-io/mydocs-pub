class ArrayView

  includeDelegationTo Array

  def initialize(array)
    @model = array
  end


  def printView
    print ">>> VIEW:\n  "
    @model.each {|elem| print "#{elem} "}
    print "\n"
  end

  def get_delegate
    @model
  end

end
