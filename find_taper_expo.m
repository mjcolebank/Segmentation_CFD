function [r_top, taper] = find_taper_expo(radii,leng)
m = length(radii);
x_eval = 0:leng/(m-1):leng;
f = @(x) x(1).*exp(-x(2).*x_eval);
cost = @(x) sum( (radii-f(x)).^2);
x0 = [0.4, 0.02];
[x,fval] = fminsearch(cost,x0);
r_top = x(1);
taper = x(2);
end
