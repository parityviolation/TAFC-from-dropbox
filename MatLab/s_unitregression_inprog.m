figure;
icond = 1;
clear thiscond;
thiscond(icond).spikesf = {'Electrode',Electrode,'Unit',UnitID};
thiscond(icond).sweepsf   = {'PrematureShort',1};
Desc = 'PrematureShort';

alignEvent = 'TrialInit';
event =  'firstSidePokeTime';
%event =  'tone2Time';
clear options
options.WOIsize = 0.2;
% options.WOIoverlap = 0.0;
WOI = [0.2 2.4]*1000;
options.beginOfFirstWOI = -WOI(1)/1000;
options.endOfLastWOI = WOI(2)/1000;
options.lockOut =0.0;
options.bplot =1;
% options.binsize = 0.05;
% options.alignEvent = alignEvent;
% todo ad percentile bins to below
% [r p] = corrSpikerateVsEventTime_spikes(spikesNoW,event,cond,options);

nEventBins =3;
options.binsize = 15;
options.nsmooth = 8;
options.bootstrap = 0;
options.plottype =   {'psth'  'rasterplot'};
options.sortSweepsByARelativeToB= {event,alignEvent};
options.dpFieldsToPlot = {event,'TrialInit'};
options.alignEvent = alignEvent;
options.bsave = 1;
options.bprctile = 1;

 h = psthByEventBin_spikes(spikesNoW,event,nEventBins,thiscond,WOI,options);
 title(Desc);

