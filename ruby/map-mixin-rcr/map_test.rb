require "map"

class MyMap
  def initialize
    @backend = {"age"=>7, "iq"=>196, "answer"=>42}
  end

  def get_mapped_value(key)
    @backend.fetch(key)
  end

  def each
    @backend.each{|k,v| yield(k,v) }
  end

  include Map
end




require "test/unit"

class XmlMappingTest < Test::Unit::TestCase

  def setup
    @m=MyMap.new
  end

  def test_misc
    assert_equal 42, @m["answer"]
    assert_nil @m["notthere"]

    @m.default="DEFAULT"
    assert_equal "DEFAULT", @m["notthere"]

    assert_equal 3, @m.size
    assert_equal 3, @m.length

    assert_equal ["age", "answer", "iq"], @m.keys.sort
    assert_equal [7, 42, 196], @m.values.sort

    assert @m.key?("age")
    assert_equal false, @m.key?("notthere")

    assert_equal [196,"DEFAULT",7], @m.indexes("iq","notthere","age")

    assert_equal "iq", @m.index(196)
    assert_equal "DEFAULT", @m.index(1234)

    ks=[]; vs=[]
    @m.each{|k,v| ks << k; vs << v }
    assert_equal ["age", "answer", "iq"], ks.sort
    assert_equal [7, 42, 196], vs.sort

    ks=[]; vs=[]
    @m.each_pair{|k,v| ks << k; vs << v }
    assert_equal ["age", "answer", "iq"], ks.sort
    assert_equal [7, 42, 196], vs.sort
  end
end
