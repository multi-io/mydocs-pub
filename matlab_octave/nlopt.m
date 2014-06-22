#!/usr/bin/octave --persist
# -*- octave -*-

# generic (non-linear) numerical optimization of a function of 2 parameters

1;

global M = [3;2]

function phi = phi(x)
  global M
  phi = -exp(-sum((x - M).^2));
endfunction


##plot it -- incredibly convoluted

# nested function -- only works when copied & pasted into the command line???
function plotR2_R = plotR2_R(func, domain)
  #ezmesh(funcmesh, [0 5])  #error
  #ezmesh('funcmesh', [0 5])  #error
  #ezmesh(@funcmesh, domain) #error ("handles to nested functions are not yet supported")
  ezmesh(@(x,y) funcmesh(func, x, y), domain)
endfunction

# private to plotR2_R -- nested only works on command line??
function funcmesh = funcmesh(func, xs, ys)
  funcmesh = ones([size(xs,1), size(xs,2)]);
  for m = 1:size(xs,1)
    for n = 1:size(xs,2)
      funcmesh(m,n) = func([xs(m,n); ys(m,n)]);
    endfor
  endfor
endfunction


plotR2_R(@phi, [0 5 0 5])

