function error = sse_psy4(param,xaxis,data,weights)
% Summed squared error between the n-by-1 vector data and the output of the
% sigmoid function defined by the 4-by-1 vector param given the n-by-1
% vector xaxis as input. The form of the sigmoid function is the following:
% y = param(3) + (1-param(3)-param(4))*(exp((x-param(2))/param(1))./(1+exp((x-param(2))/param(1))));
if nargin<4
    weights = ones(size(data));
end
x = xaxis;
a = param(1);
b = param(2);
%         y = (exp((x-b)/a)./(1+exp((x-b)/a)));
l = param(3);
u = param(4);
y = l + (u-l)*(exp((x-b)/a)./(1+exp((x-b)/a)));
error = sum(weights.*sqrt((y-data).^2));
end