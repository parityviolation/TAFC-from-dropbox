function this_dpC = addBootStrap(this_dpC,CI)
nboot = 1000;
if nargin < 2
    CI = 0.05; % 95% conf
end
% bootstrap choices
for s = 1:length(this_dpC.IntervalSet)
    s_index = this_dpC.Interval==this_dpC.IntervalSet(s);
    try
        % note this will include preamatures if they exist
        [ci(:,s) bootstat] = bootci(nboot,{@nanmean,[this_dpC.ChoiceLeft(s_index) this_dpC.PrematureLong(s_index)]},'alpha',CI,'type','per');
        m(:,s) = nanmean(bootstat);
    catch
        ci(:,s) = NaN;
        m(:,s) = NaN;
    end
    
end
this_dpC.fracLongCI=ci;
this_dpC.fracLongMean=m;

