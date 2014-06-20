#!/usr/bin/octave --persist

xs=[0:0.1:2*pi];

mxs=[xs' xs' xs'];

mys=[sin(xs') cos(xs') 0.05*(xs').^2];

plot(mxs,mys)
