require "map"

class MyMap
  attr_accessor :backend

  def initialize
    @backend = {"age"=>52, "iq"=>196, "answer"=>42}
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
    run_test_misc_on @m
    # test with backend too to make sure we're compatible to Hash
    run_test_misc_on @m.backend
  end

  def run_test_misc_on(m)
    assert_equal 42, m["answer"]
    assert_nil m["notthere"]

    m.default="DEFAULT"
    assert_equal "DEFAULT", m["notthere"]

    assert_equal "DEFAULT", m.default
    assert_equal "DEFAULT", m.default("foo")

    assert_equal 42, m.fetch("answer")
    assert_raises(IndexError) {m.fetch("notthere")}
    assert_nil m.fetch("notthere",nil)
    o=Object.new; assert_equal o, m.fetch("notthere",o)
    def o.==(x); true; end
    assert_equal o, m.fetch("notthere",o)
    assert_equal "foobar", m.fetch("notthere","foobar")

    assert_equal 3, m.size
    assert_equal 3, m.length

    assert_equal ["age", "answer", "iq"], m.keys.sort
    assert_equal [42, 52, 196], m.values.sort

    assert_equal({52=>"age", 196=>"iq", 42=>"answer"}, m.invert)

    m2 = {"iq"=>75, "answer"=>42, "shoe_size"=>45}
    assert_equal({"age"=>52, "iq"=>75, "answer"=>42, "shoe_size"=>45},
                 m.merge(m2))
    assert_equal({"age"=>52, "iq"=>196, "answer"=>42, "shoe_size"=>45},
                 m.merge(m2){|k,o,n| o})

    assert_equal({"age"=>52, "answer"=>42},
                 m.reject{|k,v| v>100})

    assert_equal([["age",52], ["answer",42]],
                 m.select{|k,v| v<100}.sort_by{|(k,v)|k})

    assert_equal [["age",52], ["answer",42], ["iq",196]], m.sort
    assert_equal [["answer",42], ["age",52], ["iq",196]], m.sort{|(a,b)| a[1]<=>b[1]}

    # this test depends on Hash's implementation for succeeding
    #  (it depends on the assumption that @m.backend.to_s doesn't
    #  change over time)
    assert_equal "answer42iq196age52", m.to_s

    assert m.key?("age")
    assert_equal false, m.key?("notthere")

    assert m.value?(42)
    assert_equal false, m.value?(1234)

    assert_equal [196,"DEFAULT",52], m.values_at("iq","notthere","age")

    assert_equal "iq", m.index(196)
    assert_nil m.index(1234)

    ks=[]; vs=[]
    m.each{|k,v| ks << k; vs << v }
    assert_equal ["age", "answer", "iq"], ks.sort
    assert_equal [42, 52, 196], vs.sort

    ks=[]; vs=[]
    m.each_pair{|k,v| ks << k; vs << v }
    assert_equal ["age", "answer", "iq"], ks.sort
    assert_equal [42, 52, 196], vs.sort

    a=[]
    m.each_key{|x| a << x}
    assert_equal ["age", "answer", "iq"], a.sort

    a=[]
    m.each_value{|x| a << x}
    assert_equal [42, 52, 196], a.sort

    assert_equal false, m.empty?

    eq={"age"=>52, "iq"=>196, "answer"=>42}
    assert_equal eq, m
    eq.default="DEFAULT2"
    assert_equal eq, m   # default value doesn't influence ==
    eq["age"]=53
    assert_not_equal eq, m
    eq["age"]=52
    assert_equal eq, m
    eq.delete "age"
    assert_not_equal eq, m
    eq["age"]=52
    assert_equal eq, m
    eq["foo"]="bar"
    assert_not_equal eq, m
    eq.delete "foo"
    assert_equal eq, m
    eq.delete "iq"
    assert_not_equal eq, m
  end
end
