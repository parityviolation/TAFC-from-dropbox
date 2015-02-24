icondfilter = 1;
fld(1).fldname = 'ReactionTime';
fld(1).desc = 'RTCorrect';
fld(1).condfilter(icondfilter).desc  = 'Stim Correct';
fld(1).condfilter(icondfilter).fldname  = 'ReactionTime';
fld(1).condfilter(icondfilter).fsweep = {'stimulationOnCond',[1 2 3],'ChoiceCorrect',[1]};
fld(1).condfilter(icondfilter).fsweepTrial = {};
fld(1).condfilter(icondfilter).scolor = 'b';

icondfilter = 2;
fld(1).condfilter(icondfilter).desc  = 'Ctrl Correct';
fld(1).condfilter(icondfilter).fsweep = {'stimulationOnCond',[0],'ChoiceCorrect',[1]};
fld(1).condfilter(icondfilter).fsweepTrial = {};
fld(1).condfilter(icondfilter).scolor = 'k';

icondfilter = 1;
fld(2).fldname = 'ReactionTime';
fld(2).desc = 'RTError';
fld(2).condfilter(icondfilter).desc  = 'Stim Error';
fld(2).condfilter(icondfilter).fsweep = {'stimulationOnCond',[1 2 3],'ChoiceCorrect',[0]};
fld(2).condfilter(icondfilter).fsweepTrial = {};
fld(2).condfilter(icondfilter).scolor = 'b';

icondfilter = 2;
fld(2).condfilter(icondfilter).desc  = 'Ctrl Error';
fld(2).condfilter(icondfilter).fsweep = {'stimulationOnCond',[0],'ChoiceCorrect',[0]};
fld(2).condfilter(icondfilter).fsweepTrial = {};
fld(2).condfilter(icondfilter).scolor = 'k';

options.bsave = 1;
options.bSplitByInterval =1;
options.plottype = 'cdf';
  plotdpFieldDistribution_cond(thisAnimal,cond,fld,options);
