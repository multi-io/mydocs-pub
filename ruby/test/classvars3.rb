module M
  def self.aax=(x)
    @@x=x
  end
end


module M2
  def m2inst_aax
    @@x
  end
end


class C
  include M
  extend M2
end



M.aax=42
p C.m2inst_aax
