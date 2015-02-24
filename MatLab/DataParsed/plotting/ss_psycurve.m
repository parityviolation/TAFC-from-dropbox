function varargout = ss_psycurve(varargin)
% [fit h] = ss_psycurve(dp,plot,fitPsy,hAx)
% data is the output of parsedata(). |plot| and |fitPsy| are booleans determining
% whether to plot a graph|fitPsy the data. psyc is a n-by-1 vector with the
% proportion of long reports for the stimuli given by the n-by-1 vector
% stimSet. param_fit is a 4-by-1 vector with the parameters of a sigmoidal
% fitPsy of the data.

%% Form of psychometric function to be fit
%     function error = sse_psy(param)
%         x = stimSet;
%         a = param(1);
%         b = param(2);
%         %         y = (exp((x-b)/a)./(1+exp((x-b)/a)));
%         l = param(3);
%         u = param(4);
%         y = l + (1-l-u)*(exp((x-b)/a)./(1+exp((x-b)/a)));
%         error = sum(weights.*sqrt((y-psyc).^2));
%     end

%% Input arguments
dataParsed = varargin{1};
if nargin < 2
    plotb = true;
else
    plotb = varargin{2};
end

if nargin < 3
    fitPsy = true;
else
    fitPsy = varargin{3};
end

if nargin <4
    hAx = gca;
else
    hAx = varargin{4};
end

IntervalSet = dataParsed.IntervalSet;
valid = ~isnan(dataParsed.ChoiceLeft);
choiceLong = dataParsed.ChoiceLeft(valid)==1;
IntervalVector = dataParsed.Interval(valid);

psyc = zeros(size(IntervalSet));
n = nan(size(IntervalSet));

for s = 1:length(IntervalSet)
    s_index = IntervalVector==IntervalSet(s);
    ntrials(s) = sum(s_index);
    nlong(s) = nansum(choiceLong(s_index));
    n(1,s) = length(s_index);
end
psyc = nlong./ntrials;

param_fit = NaN;
slope = NaN;
quality = NaN;
if fitPsy
    
    weights = sqrt((ntrials)/sqrt(sum(ntrials)));
    
    %-- Sigmoid: 4 parameters (slope, bias, lower and upper asymptotes)--%
    param_init = [.2 .5 min(psyc) max(psyc)];
    
    [param_fit, quality, ~, ~] = fminsearch(@(param) sse_psy4(param,IntervalSet,psyc,weights), param_init);
    
    x = linspace(0,1,100);
    a = param_fit(1);
    b = param_fit(2);
    %     b = 0.5;
    l = param_fit(3);
    u = param_fit(4);
    y = l + (u-l)*(exp((x-b)/a)./(1+exp((x-b)/a)));
    %     y = b + (exp((x-.5)/a)./(1+exp((x-.5)/a)));
    slope = (y(51)-y(50))/(x(51)-x(50));
    % param_fit(end,5) = sse_psy(fmin_outp');
end

fit.psyc = psyc;
fit.nvalidtrials = ntrials;
fit.nchoiceLong = nlong;
fit.x = IntervalSet;
fit.param = param_fit;
fit.slope = slope;
fit.quality = quality;


h = [];
% Plot
if plotb
    brawdataplot = 1;
    h = plotpsycurve(fit,hAx,brawdataplot);
end



varargout{1} = fit;
varargout{2} = h;
end