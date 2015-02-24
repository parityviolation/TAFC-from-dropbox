function [ microstim, bases ] = microstimuli_13(num_bases, gamma, time, sigma)


%   Detailed explanation goes here

microstim_u =1-linspace(0,1,num_bases);%1-[0:.01:1];
%sigmas = microstim_u/5 +.03;
sigmas = sigma*ones(1,length(microstim_u));


trace = gamma.^(time);
%trace = 1- time/length(time)
ys = trace;
bases = zeros(length(microstim_u), length(ys));
%figure

for t = 1:length(microstim_u)
    for k = 1:length(ys)
        %
        bases(t,k) = (1/sqrt(2*pi))*exp(-(ys(k)-microstim_u(t))^2/(2*sigmas(t)^2));
    end
    %plot(ys,bases(t,:));
    hold on
end

microstim = zeros(size(bases));

for h = 1:length(microstim_u)
     microstim(h,:) = bases(h,:).*trace;
end


%end

