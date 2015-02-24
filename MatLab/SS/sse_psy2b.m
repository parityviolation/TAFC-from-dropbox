function error = sse_psy2b(param,xaxis,data)
% Summed squared error between the n-by-1 vector data and the output of the
% sigmoid function defined by the scalar param given the n-by-1
% vector xaxis as input. The form of the sigmoid function is the following:
% y = (exp((x-0.5)/param(1))./(1+exp((x-0.5)/param(1))));
x = xaxis;
a = param(1);
b = param(2);
y = b + (exp((x-0.5)/a)./(1+exp((x-0.5)/a)));
error = sum(sqrt((y-data).^2));
end