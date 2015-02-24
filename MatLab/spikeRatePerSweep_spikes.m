function [spikerate centers] = spikeRatePerSweep_spikes(spikes,options)

% NOTE: spiketimes are in relative time (to trial or whatever event), in ms
% options.type = 'bin' % this is the only option right now
% options.binsize % only valid for bin type
% options.woi % only keeps spikes within woi

type =  'bin';
woi = [];
binsize = 0.05;
sweeplength = [];
woi = []; % e.g [-1 1]
filttype = 'flat'; % flat causal filter
nsmooth = 0;
filterlength = 1;
bverbose = 0;
if nargin > 1
    if isfield(options,'nsmooth')
        filterlength = options.nsmooth; % only valid with bin type
    end
    if isfield(options,'filttype')
        filttype = options.filttype; % only valid with bin type
    end
    if isfield(options,'woi')
        woi = options.woi; % only valid with bin type
    end
    if isfield(options,'binsize')
        binsize = options.binsize; % only valid with bin type
    end
   if isfield(options,'sweeplength')
        sweeplength = options.sweeplength; % only valid with bin type
    end
end
extrawoi = 0;
if nsmooth % make woi larger for smoothing
    extrawoi = nsmooth*2;
end

if ~isstruct(spikes)
    %     instead of spikes you can put in
    %     a vector of spiketimes and a vector of trials
    temp.spiketimes = spikes(:,1)';
    temp.sweeps.TrialNumber = unique(spikes(:,2))';
    temp.TrialNumber = spikes(:,2)';
    spikes = temp;
end


spikes.spiketimes = spikes.spiketimes/1000; % convert to sec

if isempty(sweeplength)
    sweeplength = range(spikes.spiketimes); 
end

if isempty(woi)
    woi = [min(spikes.spiketimes) max(spikes.spiketimes)];
end

if ~isempty(spikes.spiketimes) & sum(~isnan(spikes.spiketimes))>50
    switch(type)
        case 'bin'
             
            % % get counts
            
            edges = (woi(1)-binsize*extrawoi):binsize:(woi(2) +binsize*extrawoi);
            
            
            centers = edges + diff(edges(1:2))/2;   % compute center of bins
            
            t = unique(spikes.sweeps.TrialNumber);
            numtrials = length(spikes.sweeps.TrialNumber);
            
            spikerate = zeros(numtrials,length(edges),'single');
            for itrial = 1:numtrials
                ind  = ismember(spikes.TrialNumber,t(itrial)); % ind of spikes in trial
                spiketimes = spikes.spiketimes(ind);
                temp = histc(spiketimes,edges);
                if ~isempty(temp),
                    if filterlength  % ba bootstrap doesn't work with smoothing for now
                        % todo  to have nan support use nanconv: see addmovingavg_dp
                        %     y = smooth(n(1:end-1),3);
                       kernel = getFilterFun(filterlength,filttype);
                        temp = nanconv(temp,kernel,'edge','1d') ;
                        
                        if bverbose
                            s = sprintf('smoothed over %d, %d ms bins',nsmooth, binsize);
                            disp(s);
                        end
                    end
                    spikerate(itrial,:) = temp;
                end
            end
            
        otherwise;
    end
    
    spikerate = spikerate(:,extrawoi+1:end-extrawoi);
    centers = centers(extrawoi+1:end-extrawoi);

else % no spikes set everything to some values that will avoid crasshing
    duration = 1; spikerate = [0 0]; edges = [0 duration];centers = [0 duration]; numtrials = 0;
end
