% Add ChoiceMissLeft
% Add ChoiceMissRight
dp = thisAnimal;
for idp = 1:length(dp)
    dp(idp).ChoiceMissLeft = zeros(size(dp(idp).TrialInit));
    dp(idp).ChoiceMissRight = zeros(size(dp(idp).TrialInit));
    
    dp(idp).ChoiceMissLeft(dp(idp).ChoiceMiss==1 & dp(idp).Interval<0.5) = 1;
    dp(idp).ChoiceMissRight(dp(idp).ChoiceMiss==1 & dp(idp).Interval>0.5) = 1;
    
end



icondfilter = 1;
fld(1).fldname = 'Interval';
fld(1).desc = 'ChoiceMissRight';
fld(1).condfilter(icondfilter).desc  = 'Stim';
fld(1).condfilter(icondfilter).fsweep = {'stimulationOnCond',[1 2 3],'ChoiceMissLeft',[1]};
fld(1).condfilter(icondfilter).fsweepTrial = {};
fld(1).condfilter(icondfilter).scolor = 'b';

icondfilter = 2;
fld(1).condfilter(icondfilter).desc  = 'Ctrl';
fld(1).condfilter(icondfilter).fsweep = {'stimulationOnCond',[0],'ChoiceMissLeft',[1]};
fld(1).condfilter(icondfilter).fsweepTrial = {};
fld(1).condfilter(icondfilter).scolor = 'k';

icondfilter = 1;
fld(2).fldname = 'Interval';
fld(2).desc = 'ChoiceMissRight';
fld(2).condfilter(icondfilter).desc  = 'Stim';
fld(2).condfilter(icondfilter).fsweep = {'stimulationOnCond',[1 2 3],'ChoiceMissRight',[1]};
fld(2).condfilter(icondfilter).fsweepTrial = {};
fld(2).condfilter(icondfilter).scolor = 'b';

icondfilter = 2;
fld(2).condfilter(icondfilter).desc  = 'Ctrl';
fld(2).condfilter(icondfilter).fsweep = {'stimulationOnCond',[0],'ChoiceMissRight',[1]};
fld(2).condfilter(icondfilter).fsweepTrial = {};
fld(2).condfilter(icondfilter).scolor = 'k';

options.bsave = 1;
options.bSplitByInterval =0;
options.plottype = 'pdf';
plotdpFieldDistribution_cond(dp,cond,fld,options);
