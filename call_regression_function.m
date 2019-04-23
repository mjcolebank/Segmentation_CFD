function [f_opt,res] = call_regression_function(call,X,Y)

exp_f = @(pars,x) pars(1).*exp(pars(2).*x);
rat_f = @(pars,x)pars(1)./(x + pars(2));
power_f = @(pars,x) pars(1).*x.^pars(2);
poly1 = @(pars,x) pars(1) + pars(2).*x;
poly2 = @(pars,x) pars(1) + pars(2).*x + pars(3).*x.^2;
poly3 = @(pars,x) pars(1) + pars(2).*x + pars(3).*x.^2 + pars(4).*x.^3;


if call == 1
    f = @(q,x) exp_f(q,x);
    x0 = [1 -1];
elseif call == 2
    f = @(q,x) rat_f(q,x);
    x0 = [0 0];
elseif call == 3
    f = @(q,x) power_f(q,x);
    x0 = [1 -1];
elseif call == 4
    f = @(q,x) poly1(q,x);
    x0 = [1 -1];
elseif call == 5
    f = @(q,x) poly2(q,x);
    x0 = [1 -1 -1];
elseif call == 6
    f = @(q,x) poly3(q,x);
    x0 = [1 -1 -1 -1];
else
    error('No Function Available\n');
end
N = length(X);
Q = length(x0);
J = @(q) (1./(N-Q)).*sum( (Y - f(q,X)).^2);
[par_opt,cost] = fminsearch(J,x0);
res = (Y - f(par_opt,X));
f_opt = @(x) f(par_opt,x);



% f = @(pars) sum( (R(:,2) -  power_f(R(:,1),pars)).^2);
% residual_r = @(pars) (R(:,2) -  power_f(R(:,1),pars));
% res2_r = @(pars) (residual_r(pars) - power_f(residual_r(pars),pars));
% f1_res = @(pars) sum( (residual_r(pars) - power_f(residual_r(pars),pars)).^2);
% [X,FVAL] = fminsearch(f,[-2 0.1]);
% [Xres,FVAL] = fminsearch(f1_res,[-2 0.1]);
end
