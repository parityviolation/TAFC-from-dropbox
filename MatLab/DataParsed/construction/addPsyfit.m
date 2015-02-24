function dp = addPsyfit(dp)

trial_stimCond = dp.stimulationOnCond;

trial_stimCond(isnan(trial_stimCond))=0;

condLabel = unique(trial_stimCond);
ncond = length(condLabel);
for  icond = 1:ncond
    trial_thisCond = find(trial_stimCond==condLabel(icond));
    dp1 = filtbdata_trial(dp,trial_thisCond)   ;
    fit(icond) = ss_psycurve(dp1,false,true);
end
        
       
dp.analysis.psy.condLabel = condLabel;
dp.analysis.psy.fit = fit;
    disp('******** adding Psych Fit ');


