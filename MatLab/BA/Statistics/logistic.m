function y = logistic(param,x)
slope = param(1);
bias = param(2);
l = param(3);
u = param(4);

y = l + (u-l)*(exp((x-bias)/slope)./(1+exp((x-bias)/slope)));


