#!/usr/bin/octave --persist
# -*- octave -*-

# generic (non-linear) numerical optimization of a function of 2 parameters

global M = [3 2]

function phi = phi(x)
  global M
  phi = -exp(-sum((x - M).^2));
endfunction


##plot it -- incredibly convoluted

#ezmesh('phi', [0 5])  #error

function phimesh = phimesh(x, y)
  phimesh = ones([size(x,1), size(x,2)]);
  for m = 1:size(x,1)
    for n = 1:size(x,2)
      phimesh(m,n) = phi([x(m,n), y(m,n)]);
    endfor
  endfor
endfunction

#ezmesh(phimesh, [0 5])  #error
#ezmesh('phimesh', [0 5])  #error

ezmesh(@(x,y) phimesh(x,y), [0 5])
