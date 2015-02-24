function h = psthByEventBin_spikes(spikes,event,nEventBins,cond,WOI,options)
% nEventBins  number of bins to divide event times into
%
% BA 0514
bplotcorrelation =1;

nr =2 ; 
if bplotcorrelation nr = 3; end
colorfun = @hot;
if ~iscell(event) event = mat2cell(event); end

if ~isfield(options,'alignEvent')
    options.alignEvent = 'TrialInit';end % nbins to smooth with causal filter
alignEvent = options.alignEvent ;

if ~isfield(options,'bsave')
    options.bsave = 1;end % nbins to smooth with causal filter

% PSTH parameters
lockoutbeforeEvent = 0*1000; % ms % psth will end at this time before earliest possible event in the next window.

% add eventTime relative to alignEvent (usually TrialInit)
spikes.sweeps = addTimeRelativeTo(spikes.sweeps,event,alignEvent,spikes.sweeps.ephysTimeScalar);
event_fldname = [event{:} '_EphysRelativeTime_' alignEvent];

% find time bins in PSTH based on the temporal distribution of event times
spikesTemp = filtspikes(spikes,0,{},cond.sweepsf);
spikesTemp.sweeps = addTimeRelativeTo(spikesTemp.sweeps,event,alignEvent,spikes.sweeps.ephysTimeScalar);

% create event bins
if isscalar(nEventBins)
    if ~options.bprctile% even sized EventBinsize
        [~, centers] = hist(spikesTemp.sweeps.(event_fldname),nEventBins);
        binwidth = diff(centers(1:2));
        edges = [centers(1):binwidth: centers(end)]-binwidth/2;
        edges(end+1) = edges(end)+binwidth;
    else % use percentile
        p = linspace(0,100,nEventBins+1);
        edges = prctile(spikesTemp.sweeps.(event_fldname),p);
    end
end

% conditions for filtering spike struct on each EventBin
mycolor = colorfun(length(edges)*1.8);
mycolor(1,:) = [];
for ibin= 1:length(edges)-1 % slow
    thiscond(ibin).sweepsf = {cond.sweepsf{:}, event_fldname, @(x) x>= edges(ibin) & x<(edges(ibin+1))};
    thiscond(ibin).spikesf = cond.spikesf ;
    thiscond(ibin).alignEvent= alignEvent; % NOTE Times must be relative to the beginning of the session
    thiscond(ibin).plotparam.scolor = mycolor(ibin,:);
    thiscond(ibin).plotparam.endline = (edges(ibin)-lockoutbeforeEvent)/1000;
    thiscond(ibin).plotparam.endlinedotted = (edges(ibin)-edges(ibin+1))/2/1000;
    sleg{ibin} = num2str(edges(ibin)/1000,'%1.1f');
end

% plot PSTH
psthoptions = options; % for psthCondspikes
psthoptions.bsave = 0; % so we save in this function
hAx(1) = subplot(nr,1,1);
hAx(2) = subplot(nr,1,2);
psthoptions.hAx = hAx;
[h]= psthCondSpikes(spikes,thiscond, WOI,psthoptions);
set(h.hAx(:),'color','none')
if isfield(h,'hAnn'),delete(h.hAnn); end
if bplotcorrelation 
    % plot correlation
    corroptions = options;
    corroptions.binsize = corroptions.binsize /1000;
    corroptions.WOIoverlap = corroptions.binsize;
    corroptions.bplot = 0;
    
    [r p centers endWOIs] = corrSpikerateVsEventTime_spikes(spikes,event,cond,corroptions);
    hAx(3) = subplot(nr,1,3);
    plot(endWOIs,[p; r],'linewidth',1.5)
    sleg = {'p','r'};
    defaultAxes(hAx(3));
    hleg = legend(sleg);
    defaultLegend(hleg);
    set(hAx(3),'color','none')
    
    % highlight signifigance
    r(p > 0.05) = NaN;
    line(endWOIs,r,'linewidth',2.5,'color','g','linestyle','none','marker','.','markersize',10)
    
    setAxEq(hAx,'x')
    h.hleg = [];
    if isfield(h,'hpsth')
        h.hleg = legend(h.hpsth,sleg);
        defaultLegend(h.hleg,'Best',6);
    end
end

[~,~,unitDesc] = getEletrodeUnit_spike(cond.spikesf ); % Test then copy to the other function

if ~isfield(options,'savefile')
    options.savefile = ['D' spikes.sweeps.Date unitDesc cond.sweepsf{1}];
end

sAnn = [spikes.sweeps.Animal  options.savefile];
plotAnn(sAnn);

set(hAx,'color',[1 1 1]*.2);
if options.bsave
    r = brigdefs;
    sAnimal = spikes.sweeps.Animal;
    savepath = fullfile(r.Dir.EphysFigs,sAnimal,[event{1} '_WindPSTH']);
    parentfolder(savepath,1);
    export_fig(h.fig,fullfile(savepath,options.savefile),'-pdf')
    saveas(h.fig,fullfile(savepath,options.savefile))
    disp([ 'saved to ' fullfile(savepath,options.savefile)])
end


