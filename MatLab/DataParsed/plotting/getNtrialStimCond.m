function [Nvalid N] = getNtrialStimCond(dp)
ncond = unique(dp.stimulationOnCond);

intv = dp.IntervalSet;
N  = zeros(length(intv),length(ncond));
Nvalid  = zeros(length(intv),length(ncond));

for i = 1:length(intv)
    for icond = 1:length(ncond)
        thisdp = filtbdata(dp,0,{'Interval',intv(i),'stimulationOnCond',ncond(icond)});
        N(i,icond) = thisdp.ntrials;
        thisdp = filtbdata(dp,0,{'Interval',intv(i),'stimulationOnCond',ncond(icond),'ChoiceCorrect',[0 1]});
        Nvalid(i,icond) = thisdp.ntrials;
    end
end

