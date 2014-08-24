require "map"

class MyMap
  def get_mapped_value(key)
    case key
      when "age"; 52
      when "iq"; 196
      when "answer"; 42
    else raise IndexError, "no such key: #{key}"
    end
  end

  def each
    yield("age", 52)
    yield("iq", 196)
    yield("answer",42)
  end

  include Map
end

m=MyMap.new
m["iq"]      # => 196
m.index(196) # => "iq"
m.keys       # => ["age", "iq", "answer"]
m.values     # => [52, 196, 42]
m.to_a       # => [["age", 52], ["iq", 196], ["answer", 42]]
m.reject{|k,v| v>100} # => {"answer"=>42, "age"=>52}

# etc.
