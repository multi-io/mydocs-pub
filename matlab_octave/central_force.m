#!/usr/bin/octave --persist
# -*- octave -*-

# movement of a satellite around a mass that increases linearly with time

hour = 3600;
day = 24 * hour;
year = 365 * day;

global G = 6.67e-11

## central mass

#sun
#global M0 = 1.985e30  #sun
#global M0_inc = M0/5/year  #...increases by 1/5th M0 per year

#earth
global M0 = 5.975e24  #earth
global M0_inc = M0/5/day  #...increases by 1/5th M0 per day

## satellite

#earth in solar orbit
#global x0 = [0; 150e9] 
#global v0 = [30000; 0]

#(initially) geostationary satellite in earth orbit
global x0 = [0; (6300+36000)*1000] 
global v0 = [2 * pi * norm(x0) / day; 0]

## simulation time
global T = 5 * day
global n_steps = 3000


function M = M(t)
  global M0
  global M0_inc
  M = M0 + M0_inc * t;
end

function g = g(x,t)
  global G
  nx = norm(x);
  g = - x * G * M(t) / (nx^3);
endfunction


##solve

#??
function va = va(XV,t)
  x = XV(1:2);
  v = XV(3:4);
  va = [v; g(x,t)];
endfunction

ts = linspace(0, T, n_steps);

xsvs = lsode('va', [x0;v0], ts);

plot(xsvs(:,1), xsvs(:,2));
