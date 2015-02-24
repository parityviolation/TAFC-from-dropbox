function performSummary = getPerformance(gendp)


if nargin<1
    dp = custom_parsedata();
else
    dp = custom_parsedata(gendp);
end

nTrials = NaN;
nVaildTrials = NaN;                             % n trials that are not premature where applicable
nRewards = NaN;
fracValidReward = NaN;                          % nReward/nValidTrials
nPremature = NaN;
trialPerSec = nanmedian(dp.timeToTrialInit)/1000;
biasLeft = NaN;
sessionDurationHr =  (dp.RawData(end,2) -  dp.RawData(1,2))/1000/60/60; % hours
nStimuli = NaN;


nTrials  = dp.totalTrials;

if ~isempty(nTrials)
    
    if strfind('TAFC',dp.Protocol)
        nVaildTrials = sum(~isnan(dp.ChoiceCorrect));
        nRewards = nansum(dp.ChoiceCorrect==1 & dp.RwdMiss==0);
        
        if any(dp.PrematureFixation)
            nPremature = nansum(dp.PrematureFixation);
        else
            nPremature = nansum(dp.Premature);
        end
        
        fracValidReward = nRewards/nVaildTrials;
        % probability of choosing LEFT
        %         leftLC/LC * leftRC/RC - rightLC/LC * rightRC/RC
        LeftCorrect = sum(dp.Interval>0.5);
        LeftChoiceLeftCorrect    =    sum( dp.Interval>0.5& dp.ChoiceLeft==1) ;
        RightChoiceLeftCorrect    =    sum( dp.Interval>0.5& dp.ChoiceLeft==0) ;
        
        RightCorrect = sum(dp.Interval<0.5);
        LeftChoiceRightCorrect    =    sum( dp.Interval<0.5& dp.ChoiceLeft==1) ;
        RightChoiceRightCorrect    =   sum ( dp.Interval<0.5& dp.ChoiceLeft==0) ;
        
        biasLeft = (LeftChoiceLeftCorrect/LeftCorrect *LeftChoiceRightCorrect/RightCorrect) - ...
            (RightChoiceLeftCorrect/LeftCorrect *RightChoiceRightCorrect/RightCorrect);
        
        
        nStimuli = length(dp.IntervalSet);
%         stimuli =         nStimuli = length(dp.IntervalSet);

    elseif strcmp('MATCHING',dp.Protocol)
        nVaildTrials = nTrials;
        fracValidReward = nRewards/nVaildTrials;
        nRewards = nansum(dp.Rewarded == 1);
        % n Trials choice Left WHEN Right was high  -
        % n Trials choice Right WHEN Left was high  -
        biasLeft =  nansum(dp.ProbRwdLeft<dp.ProbRwdRight & dp.ChoiceLeft==1)...
            - nansum(dp.ProbRwdLeft>dp.ProbRwdRight & dp.ChoiceLeft==0);
    end
    
    
    
else
    disp('no trials found')
end

performSummary.nTrials  = nTrials;
performSummary.nVaildTrials =nVaildTrials;
performSummary.fracValidReward = fracValidReward;                          % nReward/nValidTrials
performSummary.nRewards = nRewards;
performSummary.nPremature = nPremature;
performSummary.trialPerSec =trialPerSec;
performSummary.sessionDurationHr = sessionDurationHr; % hours
performSummary.biasLeft = biasLeft;
performSummary.nStimuli = nStimuli;
