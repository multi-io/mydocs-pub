# provides Map functionality (mapping keys to values) in terms of a
# method get_mapped_value(key) and - optionally - each{|k,v|..} in the
# class this module is included in.
#
# get_mapped_value(key) should return the value belonging to key, or
# raise IndexError if there's no such value in the map.
#
# if you want methods like keys, values, each_key, each_value, empty?
# etc. to work, you also have to provide a method "each{|k,v|..}" that
# calls the given block with all key-value pairs of the map
# consecutively. In that case, you may also include Enumerable (which
# also relies on "each").
#
# a test for this module is in map_test.rb
module Map
  # this particular implementation of Map is still (to a lesser
  # extent) vulnerable to the fragile base class problem because the
  # methods call each other (so the behaviour is
  # implementation-dependent if the user decides to override some
  # methods). A really correct implementation would probably call only
  # get_mapped_value and each from all its methods (or use "internal"
  # helper methods that must not be overridden)


  # hmm...we need a default value to be compatible with Hash#[],
  # Hash#indices etc.
  def default(key=nil)
    @map_mixin_default_value
  end

  def default=(x)
    @map_mixin_default_value=x
  end


  def [](k)
    begin
      get_mapped_value(k)
    rescue IndexError
      default
    end
  end

  def fetch(k,dflt=nil)
    begin
      get_mapped_value(k)
    rescue IndexError
      return dflt if dflt
      return yield(k) if block_given?
      raise
    end
  end

  def has_key?(k)
    begin
      get_mapped_value(k)
      return true
    rescue IndexError
      return false
    end
  end

  alias_method :include?, :has_key?
  alias_method :key?, :has_key?
  alias_method :member?, :has_key?


  def values_at(*keys)
    keys.map {|k| self[k] }
  end

  # two deprecated aliases...
  alias_method :indexes, :values_at
  alias_method :indices, :values_at



  def self.included(mod)
    begin
      mod.module_eval "alias_method :each_pair, :each"
    rescue NameError
      # mod doesn't define each. Not an error (but the methods below
      # won't work).
    end
  end

  def each_key
    each{|(k,v)| yield k}
  end

  def each_value
    each{|(k,v)| yield v}
  end

  def empty?
    each{ return false }
    true
  end

  def has_value?(value)
    each{|(k,v)| return true if value==v }
    false
  end

  alias_method :value?, :has_value?

  def index(value)
    each{|(k,v)| return k if value==v }
    nil
  end

  def keys
    result=[]
    each{|(k,v)| result << k }
    result
  end

  def values
    result=[]
    each{|(k,v)| result << v }
    result
  end

  def invert
    result={}
    each{|(k,v)| result[v]=k }
    result
  end

  def merge(other)
    result=to_hash
    other.each do |(k,v)|
      result[k] = if key? k
                    if block_given?
                      yield(k,self[k],v)
                    else
                      v
                    end
                  else
                    result[k]=v
                  end
    end
    result
  end

  def reject
    result={}
    each{|(k,v)| result[k]=v unless yield(k,v) }
    result
  end

  def select
    result=[]
    each{|(k,v)| result << [k,v] if yield(k,v) }
    result
  end

  def to_hash
    result={}
    each{|(k,v)| result[k]=v }
    result
  end

  def to_a
    result=[]
    each{|(k,v)| result << [k,v] }
    result
  end

  def to_s
    self.to_a.join
  end

  def sort(&block)
    to_a.sort(&block)
  end

  def length
    result=0
    each{|(k,v)| result += 1 }
    result
  end

  alias_method :size, :length


  def ==(other)
    # TODO
  end

end
