clear cond
cond.condGroup = {[1 2 3]}; % group Stimulations conditions accordingly
cond.condGroupDescr = '[1 2 3]';

options.savefileHeader = 'PreMatureTrials';
bRemoveFirstInterval =1; % there are lots of chices long at short timescales which messes up the pschcurve
cond(1).filter = {'stimulationOnCond',0,'Premature', 1,'controlLoop',0};
cond(1).trialRelativeSweepfilter = {-1,'Premature', 0};
cond(1).color = 'k';
cond(1).desc = 'ctrl';

cond(2).filter = {'stimulationOnCond',[1 2 3],'Premature', 1,'controlLoop',0};
cond(2).trialRelativeSweepfilter = {-1,'Premature', 0};
cond(2).color = 'b';
cond(2).desc = 'stim';

dpC =concdp(thisAnimal);
dpPM= prematurePsycurvHelper(dpC);
if bRemoveFirstInterval
    dpPM = filtbdata(dpPM,0,{'Interval',dpPM.IntervalSet(2:end)});
    dpPM.IntervalSet = dpPM.IntervalSet(2:end);
end
plotMLEfit(dpPM,cond,fitFunction,free_parameters,options)