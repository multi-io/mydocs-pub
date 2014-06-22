#!/usr/bin/octave --persist
# -*- octave -*-

# generic (non-linear) numerical optimization of a function of 2 parameters

1;

global M = [3 2]

function phi = phi(x)
  global M
  phi = -exp(-sum((x - M).^2));
endfunction


##plot it -- incredibly convoluted


# nested function -- only works when copied & pasted into the command line???
function plotR2_R = plotR2_R(func, xrange, yrange)

  function funcmesh = funcmesh(x, y)
    funcmesh = ones([size(x,1), size(x,2)]);
    for m = 1:size(x,1)
      for n = 1:size(x,2)
        funcmesh(m,n) = func([x(m,n), y(m,n)]);
      endfor
    endfor
  endfunction

  #ezmesh(funcmesh, [0 5])  #error
  #ezmesh('funcmesh', [0 5])  #error
  #ezmesh(@funcmesh, xrange, yrange) #error ("handles to nested functions are not yet supported")
  ezmesh(@(x,y) funcmesh(x,y), xrange, yrange)

endfunction


plotR2_R(@phi, [0 5], [0 5])  #error

