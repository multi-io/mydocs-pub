module A
  module B
    print "B: I am #{self}\n"
    v=42
    require 'scoping_import'
    print "#{__FILE__}: v=#{v}\n"
  end
end

print "X::Y is visible outside the scope 'require' appeared in: #{X::Y}\n"
