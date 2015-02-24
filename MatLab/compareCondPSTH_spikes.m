function [statTest WOIcenters endWOIs] = compareCondPSTH_spikes(spikes,event,cond,options)
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
if ~isfield(options,'test')
    options.test = 'ranksum';
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


ncond = length(cond); % only works for 2 conditions right now

if 1 % even WOI across range
    beginlastOfWOI = endOfLastWOI - WOIsize;
    beginWOIs = [beginOfFirstWOI:WOIoverlap:beginlastOfWOI];
end
endWOIs = beginWOIs+WOIsize;
WOIcenters = beginWOIs+WOIsize/2;
nWOI = length(beginWOIs);

try
for icond = 1:ncond
    thesespikes = filtspikes(spikes,0,cond(icond).spikesf,cond(icond).sweepsf);
    
    this_sweep = thesespikes.sweeps;
    nsweep = this_sweep.ntrials;
    
    % % % %COMPUTE  the avg rate in each WOI
    trialLength = endOfLastWOI+WOIsize;
    keepSpikeWindow = [0 trialLength]*1000;                 %  ms will only get events in this window around  alignEvent for further analysis
    [spikeTimeRelativeToEvent trials] = relativeSpiketimes_spikes(thesespikes,alignEvent,keepSpikeWindow);
    [spikerate centers] = spikeRatePerSweep_spikes([spikeTimeRelativeToEvent trials] ,tempoptions);
    
    cond(icond).avgRate = zeros(nsweep,nWOI,'single');    
    for iWOI = 1:nWOI  % Get spikerate for each sweep
        indInBin = centers>beginWOIs(iWOI) & centers<=(beginWOIs(iWOI)+WOIsize);
        cond(icond).avgRate(:, iWOI) = avgfun(spikerate(:,indInBin)');
    end
    
    % % % % %REMOVE (set to NAN) extra WOI where EVENT has already occured
    % % for each sweep, and each WOI, check that EVENT (e.g.
    % % firstSidePoke) occurs after the begining of the NEXT WOI + lockOut
    % this_sweep = addTimeRelativeTo(this_sweep,event,alignEvent,this_sweep.ephysTimeScalar);
    % event_fldname = [event{:} '_EphysRelativeTime_' alignEvent];
    % eventTime = repmat(this_sweep.(event_fldname)',1,nWOI-1)/1000;
    % bIncludeSweepWOI = eventTime >= repmat(beginWOIs(2:end),nsweep,1)+lockOut ;
    %
    %
    % avgRate(~bIncludeSweepWOI) = NaN;
end
% do regression for each WOI
% stats = nan(1,nWOI);

% TO DO ADD multiple test ADD ANOVA
for itest = 1:length(options.test)
    thisTest = options.test{itest};
    statTest(itest).p = nan(1,nWOI);
    statTest(itest).test = thisTest;
    for iWOI = 1:nWOI  % Get spikerate for each sweep
        for icond =1 : ncond
            temp = cond(icond).avgRate(:,iWOI);
            dist{icond} = temp(~isnan(temp));
        end
        
        if ~isempty(dist{1})&~isempty(dist{2})
            switch(statTest)
                case 'ranksum'                   
                    statTest(itest).p(iWOI) = ranksum(dist{1},dist{2});
                case 'kstest'                   
                    [~, statTest(itest).p(iWOI)] = kstest2(dist{1},dist{2});
            end
            
        end
    end
end

catch ME
    getReport(ME)
end



