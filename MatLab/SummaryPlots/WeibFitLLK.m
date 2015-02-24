function [llk] = WeibFitLLK(param, data, free_parameters, number_fits)
%         data{icond} = [this_dpC.Interval' this_dpC.ChoiceLeft'];
% column 1 is the x to apply in the fitting function.
% column 2 is the binary choice

% todo replace hypn with fixed parameter index
[thrConVec, slopeConVec, lConVec, uConVec] = settingParamsLLKFit(param, free_parameters, number_fits);

% Compute log (P(param,choices)) This is the log of the probability of this sequences of choices 
%(i.e. choice_i for stimulus x_i) given these paramers: 
%     log(  Prod(Weibull(x_i).^choice_i,(1-Weibull(x_i)).^(1-choice_i)))
%     the first term is the probability of all the choices 1 (where 1 could
%     correspond to CORRECT or LEFT).
%     the second term is the probablity of all the choices 0  (where o
%     could correspond to ERROR or RIGHT).
% See Geoffrey M. Boynton's notes for more clarity http://courses.washington.edu/matlab1/Lesson_5.html 

for ifit = 1 : number_fits
    slope = slopeConVec(ifit);
    thr = thrConVec(ifit);
    l = lConVec(ifit);
    u = uConVec(ifit);


    choice = data{ifit}(:,2);
    x = data{ifit}(:,1);
    llk(ifit) = nansum(choice.*log(Weibull([slope thr l u],x))...
                  +(1-choice).*log(1-Weibull([slope thr l u],x)));
end


llk = - nansum(llk);

% x = [0:0.001:1];    
% plot(x,Weibull([1.5 0.5 0.2 0.8],x))
