def tonum(numstr,base)
  if (numstr=="")
    0
  else
    numstr.downcase!
    least = digit2num(numstr[-1])
    least + base * tonum(numstr[0...(numstr.length-1)],base)
  end
end



def tobase(num,base)
  return "-"+tobase(-num,base) if num<0
  if (num==0)
    ""
  else
    tobase(num/base,base) + num2digit(num%base)
  end
end


def digit2num(digitchar)
  if (digitchar < "0"[0] or digitchar > "9"[0])
    10 + digitchar - "a"[0]
  else
    digitchar - "0"[0]
  end
end


def num2digit(num)
  if (num>=0 and num<=9)
    (num+"0"[0]).chr
  else
    (num-10+"a"[0]).chr
  end
end


#####

for name,base in [["bin",2],["oct",8],["dec",10],["hex",16]]

eval <<EOS
  def #{name}2num(val)
    tonum(val,#{base})
  end

  def to#{name}(num)
    tobase(num,#{base})
  end
EOS

end


def baseconvert(numstr,srcbase,targetbase)
  tobase(tonum(numstr,srcbase),targetbase)
end
