function error = sse_psy3(param,xaxis,data)
% Summed squared error between the n-by-1 vector data and the output of the
% sigmoid function defined by the 4-by-1 vector param given the n-by-1
% vector xaxis as input. The form of the sigmoid function is the following:
% y = param(3) + (1-param(3)-param(4))*(exp((x-param(2))/param(1))./(1+exp((x-param(2))/param(1))));
x = xaxis;
a = param(1);
b = 0.5;
%         y = (exp((x-b)/a)./(1+exp((x-b)/a)));
l = param(2);
u = param(3);
y = l + (1-l-u)*(exp((x-b)/a)./(1+exp((x-b)/a)));
error = sum(sqrt((y-data).^2));
end