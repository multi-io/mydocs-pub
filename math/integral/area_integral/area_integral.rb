#!/usr/bin/ruby
# Numerische Berechnung des (Flächen-)Integrals einer Fkt. f: IR²=>IR
#   über einen zusammenhängenden, in kartesischen Koord. angeg. Bereich
#   A(x0,x1,y0f,y1f) := { (x,y) | x>x0 \and x<x1 \and y>y0f(x) \and y<y1f(y) }

include Math

def numint_area_cartesian(f,x0,x1,y0f,y1f,nstepsx=1000,nstepsy=1000)
  res=0.0; x=x0; dx=(x1-x0)/nstepsx
  nstepsx.times{
    y0=y0f.call(x); y1=y1f.call(x); dy=(y1-y0)/nstepsy
    y=y0
    nstepsy.times{
      res += f.call(x,y)*dx*dy
      y += dy
    }
    x += dx
  }
  res
end





if __FILE__ == $0

  ## Beispiel: Volumen unter Paraboloid f(x,y)=(x+y)**2
  ##           über Kreisfläche {(x,y) | x**2+y**2 < R**2}
  ##
  ##           Wahrer Wert: PI/2*R**4

  f = proc{|x,y| (x+y)**2}
  R=3.0
  x0=-R
  x1=R
  y0f=proc{|x| -sqrt(R**2-x**2) }
  y1f=proc{|x|  sqrt(R**2-x**2) }

  int = numint_area_cartesian(f,x0,x1,y0f,y1f)
  print "ideal: ",PI/2*R**4,", found: ",int,"\n"
end
