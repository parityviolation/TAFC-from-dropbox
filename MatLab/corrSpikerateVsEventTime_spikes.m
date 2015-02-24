function [r p WOIcenters endWOIs] = corrSpikerateVsEventTime_spikes(spikes,event,cond,options)
% BA 050112
%  % event: a fieldname in spikes.sweeps this the event being studied it occurs the last WOI. (see lockOut)

% bplot = 1;

if nargin <3  | isempty(cond)
    cond.spikesf = {};
    cond.sweepsf   = {};
end


if nargin <4
    if ~exist('options','var')
        options = struct();
    end
end

if ~iscell(event) event = mat2cell(event); end

if ~isfield(options,'alignEvent')
    options.alignEvent = 'TrialInit';end % nbins to smooth with causal filter
alignEvent = options.alignEvent ;


% % % % Spike rate paramters
if ~isfield(options,'nsmooth')
    options.nsmooth = 5;end % nbins to smooth with causal filter
if ~isfield(options,'nsmooth')
    options.binsize = 0.001;end

tempoptions = options;

if ~isfield(options,'avgfun')
    options.avgfun = @nanmean;end
avgfun = options.avgfun;

% % % % WOI Paramteres
if ~isfield(options,'WOIsize')
    options.WOIsize = 0.4;end
WOIsize =  options.WOIsize;
if ~isfield(options,'WOIoverlap')
    options.WOIoverlap = 0.0;end
WOIoverlap =  options.WOIoverlap;

if ~isfield(options,'beginOfFirstWOI')
    options.beginOfFirstWOI = 0;end
beginOfFirstWOI =  options.beginOfFirstWOI;

if ~isfield(options,'endOfLastWOI')
    options.endOfLastWOI = 2.4;end
endOfLastWOI =  options.endOfLastWOI;

if ~isfield(options,'lockOut')
    options.lockOut =0.1;end  % time before endWOIevent that will not be included in the WOI (e.g to exclude premotor activity)
lockOut =  options.lockOut;

if ~isfield(options,'bplot')
    options.bplot =1;end  % time before endWOIevent that will not be included in the WOI (e.g to exclude premotor activity)
bplot = options.bplot;

if ~isfield(options,'bsave')
    options.bsave = 1;
end



if 1 % even WOI across range
    beginlastOfWOI = endOfLastWOI - WOIsize;
    beginWOIs = [beginOfFirstWOI:WOIoverlap:beginlastOfWOI];
end
endWOIs = beginWOIs+WOIsize;
WOIcenters = beginWOIs+WOIsize/2;
nWOI = length(beginWOIs);

spikes = filtspikes(spikes,0,cond(1).spikesf,cond(1).sweepsf);

this_sweep = spikes.sweeps;
nsweep = this_sweep.ntrials;

% % % %COMPUTE  the avg rate in each WOI
trialLength = endOfLastWOI+WOIsize;
keepSpikeWindow = [0 trialLength]*1000;                 %  ms will only get events in this window around  alignEvent for further analysis
[spikeTimeRelativeToEvent trials] = relativeSpiketimes_spikes(spikes,alignEvent,keepSpikeWindow);
[spikerate centers] = spikeRatePerSweep_spikes([spikeTimeRelativeToEvent trials] ,tempoptions);

avgRate = zeros(nsweep,nWOI,'single');
for iWOI = 1:nWOI  % Get spikerate for each sweep
    indInBin = centers>beginWOIs(iWOI) & centers<=(beginWOIs(iWOI)+WOIsize);
    avgRate(:, iWOI) = avgfun(spikerate(:,indInBin)');
end

% % % %REMOVE (set to NAN) extra WOI where EVENT has already occured
% for each sweep, and each WOI, check that EVENT (e.g.
% firstSidePoke) occurs after the begining of the NEXT WOI + lockOut
this_sweep = addTimeRelativeTo(this_sweep,event,alignEvent,this_sweep.ephysTimeScalar);
event_fldname = [event{:} '_EphysRelativeTime_' alignEvent];
eventTime = repmat(this_sweep.(event_fldname)',1,nWOI-1)/1000;
bIncludeSweepWOI = eventTime >= repmat(beginWOIs(2:end),nsweep,1)+lockOut ;


avgRate(~bIncludeSweepWOI) = NaN;
if bplot
    h.fig = figure('Name','Event Window Spike Correlation','Position',[12    75   227   855 ]);
end
% do regression for each WOI
r = nan(1,nWOI);
p = nan(1,nWOI);
for iWOI = 1:nWOI  % Get spikerate for each sweep
    ind = ~isnan(avgRate(:,iWOI))& ~isnan(eventTime(:,1));
    if sum(ind)>4;
        [R,P] = corrcoef(eventTime(ind,1),avgRate(ind,iWOI));
        r(iWOI) = R(1,2);
        p(iWOI) = P(1,2);
        
        if bplot
            subplot(nWOI,1,iWOI)
            line(avgRate(ind,iWOI),eventTime(ind,1),'Linestyle','none','marker','.')
            [~,m,b] = regression(avgRate(ind,iWOI),eventTime(ind,1),'one');
            x = [min(avgRate(ind,iWOI)) max(avgRate(ind,iWOI))];
            hl = line(x,m*x+b);
            sleg = [' r = ' num2str(r(iWOI),'%1.2f') ' p_B = ' num2str(p(iWOI)*nWOI,'%1.1g')];
            %         hleg = legend(hl,sleg);
            %         defaultLegend(hleg,'Best',6);
            setTitle(gca,['W:[' num2str([beginWOIs(iWOI) beginWOIs(iWOI)+WOIsize],' %1.1f') '] ' sleg],7);
            %
        end
    end
end

if bplot
    [~,~,unitDesc] = getEletrodeUnit_spike(cond.spikesf); % Test then copy to the other function
    
    
    if ~isfield(options,'savefile')
        options.savefile = ['D' spikes.sweeps.Date unitDesc cond.sweepsf{1}];
    end
    
    sAnn = [spikes.sweeps.Animal ' ' options.savefile];
    plotAnn(sAnn);
    
    if options.bsave
        r = brigdefs;
        sAnimal = spikes.sweeps.Animal;
        savepath = fullfile(r.Dir.EphysFigs,sAnimal,[event{1} '_WindCorr']);
        parentfolder(savepath,1);
        export_fig(h.fig,fullfile(savepath,options.savefile),'-pdf')
        saveas(h.fig,fullfile(savepath,options.savefile))
        disp([ 'saved to ' fullfile(savepath,options.savefile)])
    end
end

