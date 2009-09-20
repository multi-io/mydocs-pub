include Math

PIx2 = 2*PI


# angles. base unit: rad
deg=PI/180.0
arcmin=deg/60.0
arcsec=arcmin/60.0

# velocities. base unit: meters/sec
c=299792458.0

# times. base unit: second
min=60.0
hr=60*min
day=24*hr
year=365*day

# distances. base unit: meter
m=1.0
cm=1e-2
mm=1e-3
um=1e-6
nm=1e-9
km=1000.0
ly=c*year
au=149.6e6*km
pc=au/arcsec

r_earth=6371*km

r_sun=1.392e6*km/2

rrad_sun=r_sun/au

def sterad_circle(rrad)
  2*PI*(1-cos(rrad))
end


# area of right-angled spherical triangle with legs l1,l2
def sterad_triangle_rangled(l1,l2)
  beta=acot(sin(l1)/tan(l2))
  gamma=acot(sin(l2)/tan(l1))
  beta+gamma-PI/2
end

# spherical rectangle
def sterad_rect(s1,s2)
  4*sterad_triangle_rangled(s1/2,s2/2)+4*sterad_triangle_rangled(s2/2,s1/2)
end

# http://en.wikipedia.org/wiki/Angular_resolution
def telescope_resolution(d, lambda=625e-9)
  1.22*lambda/d
end


def telescope_diameter(angular_res, lambda=625e-9)
  1.22*lambda/angular_res
end


def cot(x)
  tan(PI/2-x)
end

def asin(x)
  atan2(x, sqrt(1.0-x*x))
end

def acos(x)
  atan2(sqrt(1.0-x*x), x)
end

def acot(x)
  PI/2-atan(x)
end


# [h,min,sec] => Bogenmass
def hms2rad(hms)
  h,m,s = hms
  PIx2 * (h/24.0 + m/(24.0*60) + s/(24.0*60*60))
end

# umgekehrt
def rad2hms(rad)
  h = rad.abs/PIx2*24.0
  m = (h-h.floor)*60
  s = (m-m.floor)*60
  if rad > 0 then
    [h.floor,m.floor,s]
  else
    [-h.floor,-m.floor,-s]
  end
end


def h2hms(h)
  m = (h.abs-h.abs.floor)*60
  s = (m-m.floor)*60
  if h > 0 then
    [h.abs.floor,m.floor,s]
  else
    [-h.abs.floor,-m.floor,-s]
  end
end

def hms2h(hms)
  h,m,s = hms
  h + m/60.0 + s/(60.0*60.0)
end


# [Grad,min,sec] => Bogenmass
def dms2rad(dms)
  d,m,s = dms
  PIx2 * ( d/360.0 + m/(360.0*60) + s/(360.0*60*60))
end

# umgekehrt
def rad2dms(rad)
  d = rad.abs/PIx2*360.0
  m = (d-d.floor)*60
  s = (m-m.floor)*60
  if rad>0 then
    [d.floor,m.floor,s]
  else
    [-d.floor,-m.floor,-s]
  end
end

def rad2deg(rad)
  rad/PI*180
end



module Enumerable
  def sum
    inject(0) {|x,y|x+y}
  end

  def prod
    inject(1) {|x,y|x*y}
  end
end


# stochastics

def fac(x)
  res=1
  (1..x).each{|i| res*=i}
  res
end


def over(x,y)
  # fac(x)/fac(x-y)/fac(y)
  ((x-y+1)..x).prod / fac(y)
end
