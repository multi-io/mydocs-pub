#!/usr/bin/ruby

include Math

# Numerische Berechnung des (Flächen-)Integrals einer Fkt. f: IR²=>IR
#   über einen zusammenhängenden, in kartesischen Koord. angeg. Bereich
#   A(x0,x1,y0f,y1f) := { (x,y) | x0<x<x1 \and y0f(x)<y<y1f(x) }
def numint_area_cartesian(f,x0,x1,y0f,y1f,nstepsx=500,nstepsy=500)
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



# dito, Fläche aber diesmal in Polarkoordinaten:
#  A(r0,r1,phi0,phi1) := { (x,y) | r0<sqrt(x**2+y**2)<r1 \and phi0<atan2(y,x)<phi1 }
#  default: r0=0, phi0=0, phi1=2*PI (Kreisfläche mit Radius r1)
def numint_area_polar(f,r1,r0=0.0,phi0=0.0,phi1=2*PI,nstepsr=500,nstepsphi=500)
  res=0.0; r=r0; dr=(r1-r0)/nstepsr
  nstepsr.times{
    phi=phi0; dphi=(phi1-phi0)/nstepsphi
    nstepsphi.times{
      res += f.call(r*cos(phi),r*sin(phi))*r*dphi*dr
      phi += dphi
    }
    r += dr
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

  int_cartesian = numint_area_cartesian(f,x0,x1,y0f,y1f)
  int_polar = numint_area_polar(f,R)
  print "ideal: #{PI/2*R**4}, found (cartesian): #{int_cartesian}, found (polar): #{int_polar}\n"
end
