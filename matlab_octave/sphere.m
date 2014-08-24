#!/usr/bin/octave --persist
# -*- octave -*-

R = 5;
meshN = 50;

xs = ys = zs = ones(meshN,meshN);

for m = [1:meshN]
  for n = [1:meshN]
    phi=2*pi*(m-1)/(meshN-1);
    th=pi*(n-1)/(meshN-1)-pi/2;
    xs(m,n)=R*cos(phi)*cos(th);
    ys(m,n)=R*sin(phi)*cos(th);
    zs(m,n)=R*sin(th);
  endfor
endfor

mesh(xs,ys,zs)
