#!/usr/bin/octave --persist
# -*- octave -*-

# given viewing angles, compute 2D outline (hexagon) points
function [b,c,d,h,e,f] = bcdhef(phi,alpha)
  sa = sin(alpha);
  ca = cos(alpha);
  sf = sin(phi);
  cf = cos(phi);
  cfsa = cf*sa;
  sfsa = sf*sa;
  W = cf + sf;
  H = sfsa + ca + cfsa;
  b = [-W/2; -H/2 + sfsa];
  c = b + [0; ca];
  d = c + [sf; cfsa];
  h = d + [cf; -sfsa];
  e = h + [0; -ca];
  f = e + [-sf; -cfsa];
endfunction


# intersect 2D line starting at origin in direction angle with line p1---p2
function [x,y,length] = intersect(angle,p1,p2)
  s = sin(angle);
  c = cos(angle);
  dx = p2(1)-p1(1);
  # special cases
  if (norm(c) < eps)
    x = 0;
    y = p1(2) - p1(1)*(p2(2)-p1(2))/dx;
    length = y;
  elseif (norm(dx) < eps)
    x = p1(1);
    y = s/c * x;
    length = norm([x;y]);
  else
    # default case
    A = [-s/c, 1;
         -(p2(2)-p1(2))/dx, 1];
    b = [0;
         p1(2) - p1(1)*(p2(2)-p1(2))/dx];
    xy = A \ b;
    x = xy(1);
    y = xy(2);
    length = norm(xy);
  endif
endfunction

# compute half-diagonal of inscribed square
function D = D(phi,alpha,theta)
  [b,c,d,h,e,f] = bcdhef(phi,alpha);
  [~,~,D1] = intersect(pi/2-theta, d, h);
  [~,~,D2] = intersect(pi/2-theta, h, e);
  [~,~,D3] = intersect(-theta, h, e);
  [~,~,D4] = intersect(-theta, e, f);
  [~,~,D5] = intersect(-theta, f, b);
  D = min([D1,D2,D3,D4,D5]);
endfunction


### plotting

function plot_case(phi,alpha,theta)
  #plot hexagon
  [b,c,d,h,e,f] = bcdhef(phi,alpha);
  plot_closed_curve([b,c,d,h,e,f]);
  hold on;
  #plot inscribed square
  D_ = D(phi,alpha,theta);
  s1 = pol2cart(pi/2-theta, D_)';
  s2 = pol2cart(-theta, D_)';
  s3 = pol2cart(-pi/2-theta, D_)';
  s4 = pol2cart(pi-theta, D_)';
  plot_closed_curve([s1,s2,s3,s4]);
endfunction

function plot_closed_curve(points)
  n = size(points,2);
  xs = ys = [1:(n+1)];
  for i = [1:n]
    xs(i) = points(1,i);
    ys(i) = points(2,i);
  endfor
  xs(n+1) = points(1,1);
  ys(n+1) = points(2,1);
  plot(xs,ys);
end


### maximize D, display result

#the optimizer (sqp) can only minimize
function m = to_minimize(phi_alpha_theta)
  m = -D(phi_alpha_theta(1), phi_alpha_theta(2), phi_alpha_theta(3));
endfunction

# TODO try multiple starting points
phi_alpha_theta_max = sqp([0.1;0.3;0.3], @to_minimize);

phi_max = phi_alpha_theta_max(1);
alpha_max = phi_alpha_theta_max(2);
theta_max = phi_alpha_theta_max(3);

D_max = D(phi_max, alpha_max, theta_max);
printf("Optimal:\n");
printf("alpha = %.6f\n", alpha_max);
printf("phi = %.6f\n", phi_max);
printf("theta = %.6f\n", theta_max);
printf("square side = %.6f\n", sqrt(2)*D_max);

axis "square";
hold on;
plot_case(phi_max, alpha_max, theta_max);
