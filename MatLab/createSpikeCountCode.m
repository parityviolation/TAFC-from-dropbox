function code = createSpikeCountCode(sweepf,selcLabel,labelType)
% BA SS
% makes a distribution of spike counts (spikeCountHistConc) for each time bin (centerHistConc)
% during the task.
% and a set of pseudoTrials (that is trials treating sessions as if they
% were simultaneously recorded)

% Add smoothing of histogram?
% remove units with low rates?
% **add units from different session (can probably combine and put nan on
% trials that are from different session)

bdebugplot = 1;
if nargin <1
    sweepf = {'ChoiceCorrect',1};
end
if nargin <2
    selcLabel =2;
end
if nargin <3
    labelType = 'interval';
end
boverlayplot = 0;
PRELOCKOUT =  200; % period before tone (or whatever interval corresponds to) to exclude from decoder

int_list = [0.6    1.05    1.26    1.74    1.95    2.4]*1000;
nTest = 50;
% % file info hardcoded for now
bd = brigdefs;
flist = dirc([fullfile(bd.Dir.spikesStruct,'SertxChR2_179\') '*.mat']);
fname = flist(:,1);
nfiles = [3 :5]; % 1:length(fname);

interval = [];
WOI = [0 2400];
binsize = [500 100];

for ifile = nfiles
    
    load(fullfile(bd.Dir.spikesStruct,'SertxChR2_179\',fname{ifile}));
    %int_list = unique(spikes.sweeps.Interval(~isnan(spikes.sweeps.Interval)));
    spikes.sweeps.IntervalSet*spikes.sweeps.Scaling
    chn = cell2mat(spikes.Analysis.EUPlusLabel(:,1));
    unit = cell2mat(spikes.Analysis.EUPlusLabel(:,2));
    spikes_cor = filtspikes(spikes,1,{},sweepf);
    interval{ifile} = spikes_cor.sweeps.Interval*spikes_cor.sweeps.Scaling;
    switch(labelType)
        case 'interval'
            trialLabel{ifile} = spikes_cor.sweeps.Interval*spikes_cor.sweeps.Scaling;
        case 'side'
            trialLabel{ifile} = spikes_cor.sweeps.ChoiceLeft;
    end
    alignEvent = 'TrialInit';
    
    bin_end = WOI(1);
    nsteps = (WOI(2)-WOI(1))/binsize(2);
    
    bin_end = linspace(bin_end,WOI(2),nsteps+1);
    bin_start = bin_end-binsize(1);
    
    
    nchn = length(chn);
    nbin = length(bin_start);
    ntrials = spikes_cor.sweeps.ntrials;
    chnExclude = [];
    
    spikeCount{ifile} = nan([nchn,nbin,ntrials]);
    spikeCountAll{ifile} = nan([nchn,nbin,ntrials]);
    
    for ichn=1:nchn
        these_spikes = filtspikes(spikes_cor,0,{'Electrode',chn(ichn),'Unit',unit(ichn)});
        
        [spikeTimeRelativeToEvent trials] = relativeSpiketimes_spikes(these_spikes,alignEvent,[bin_start(1) bin_end(end)]);
        % TO DO add smoothing of spikerate
        
        % Exclude units with rate less than MIN_SPIKE_RATE
        MIN_SPIKE_RATE = 1;
        
        if length(spikeTimeRelativeToEvent)>sum(WOI)/1000*MIN_SPIKE_RATE*ntrials
            for itrial = 1:ntrials
                
                if ismember(itrial,trials)
                    ind = trials == itrial;
                    for ibin = 1:nbin
                        edges = [bin_start(ibin) bin_end(ibin)];
                        if edges(2)>interval{ifile}(itrial)-PRELOCKOUT %stop adding spike counts after the time of the second stimulus
                            spikeCountAll{ifile}(ichn,ibin,itrial) = sum(spikeTimeRelativeToEvent(ind)> edges(1) & spikeTimeRelativeToEvent(ind)<= edges(2) );
                        else
                            spikeCount{ifile}(ichn,ibin,itrial) = sum(spikeTimeRelativeToEvent(ind)> edges(1) & spikeTimeRelativeToEvent(ind)<= edges(2) );
                            spikeCountAll{ifile}(ichn,ibin,itrial) = sum(spikeTimeRelativeToEvent(ind)> edges(1) & spikeTimeRelativeToEvent(ind)<= edges(2) );
                        end
                    end
                else
                    spikeCount{ifile}(ichn,:,itrial) = 0; % by default there is no spikes
                    spikeCountAll{ifile}(ichn,ibin,itrial) = 0;
                end
            end
        else % exclude units that don't have MIN_SPIKE_RATE
            spikeCount{ifile}(ichn,:,:) = NaN;
            spikeCountAll{ifile}(ichn,:,:) = NaN;
            chnExclude(end+1) = ichn ; % exclude this channel
        end
    end
    nchn = nchn-length(chnExclude);
     spikeCountAll{ifile}(chnExclude,:,:) = [];
     spikeCount{ifile}(chnExclude,:,:) = [];
    
    for itest = 1:nTest % multiple test trials (removing each one from the Template)
        for iLabel=1:length(selcLabel) %making a pseudotrial with all cells available
            
            switch(labelType)
                case 'interval'
                    these_trials = find(ismember(round( trialLabel{ifile}),round(int_list(selcLabel(iLabel)))));
                    if ~isempty(these_trials)
                        indTest = these_trials(randi(length(these_trials)));
                       
                        testspikeCount{ifile,iLabel,itest} =spikeCountAll{ifile}(:,:,indTest); % Test Trial includes spikes past the interval
                        subspikeCount= spikeCount{ifile};
                        subspikeCount(:,:,indTest) =[];  % remove a trial for Testing
                    else
                        testspikeCount{ifile,iLabel,itest} =nan(size(spikeCount{ifile}(:,:,1)));
                        subspikeCount = spikeCount{ifile};
                    end
                    
                case 'side'
                    these_trials = find(ismember(round( trialLabel{ifile}),selcLabel(iLabel)));
                    % in this case we need 2 different templates/classifies
                    % one for each side
                    if ~isempty(these_trials)
                        ind = randi(length(these_trials));
                        indTest = these_trials(ind);
                        these_trials(ind) = [];                        % remove a trial for Testing
                        testspikeCount{ifile,iLabel,itest} =spikeCount{ifile}(:,:,indTest); % Test Trial includes spikes past the interval
                        subspikeCount= spikeCount{ifile}(:,:,these_trials);
                    else
                        testspikeCount{ifile,iLabel,itest} =nan(size(spikeCount{ifile}(:,:,1)));
                        subspikeCount = spikeCount{ifile};
                    end

            end
           
            
            
            % create pdf histograme for each bin
             if bdebugplot & iLabel==1 & itest==1                 
                 h.fig(ifile) = figure('Name',['file' num2str(ifile) fname{ifile}],'Position',[36          51        1854         927],'Visible','off');
             end
             nhistbins = 10;
            spikeCountHist{ifile,iLabel,itest} = zeros([nchn,nbin,nhistbins]);
            centerHist{ifile,iLabel,itest} = nan([nchn,nbin,nhistbins]);
            mycolor  = jet(nbin);
            nc = 8;
            nr = ceil(nchn/nc);
            chnExclude = [];
            for ichn=1:nchn
%                 any(isnan(squeeze(subspikeCount(ichn,:,1))))
%                 if any(isnan(squeeze(subspikeCount(ichn,:,1))))
%                     spikeCountHist{ifile,iLabel,itest}(:,:,:) = NaN;
%                 else
                    for ibin = 1:nbin
                        if all(isnan(squeeze(subspikeCount(ichn,ibin,:))))
                            break
                        end
                        [a x] = hist(squeeze(subspikeCount(ichn,ibin,:)));
                        centerHist{ifile,iLabel,itest}(ichn,ibin,:) =  x;
                        a(a==0) = 1e-5; % zero probablity is a problem=
                        a =  a/sum(a); %get pdf for each bin
                        spikeCountHist{ifile,iLabel,itest}(ichn,ibin,:) =a;
                        % WHAT do these distributions look like?
                        if bdebugplot & iLabel==1 & itest==1
                            subplot(nr,nc,ichn)
                            line(x,a+.3*ibin,'color',mycolor(ibin,:));
                        end
                    end
%                 end
            end
            if bdebugplot & iLabel==1 & itest==1, set(h.fig(ifile)  ,'Visible','on') ;                       end
          
            
        end
        
        % TO DO add decoding like below
        % yy2 = smooth([1:nbin),y,0.1,'rloess');
    end
end

% concatenate all
spikeCountHistConc = cell(length(selcLabel),nTest,1);
centerHistConc = cell(length(selcLabel),nTest,1);
pseudoTrial = cell(length(selcLabel),nTest);

% plot the spikeCountHistf

for ifile = nfiles
    for itest = 1:nTest
        for iLabel=1:length(selcLabel) %making a pseudotrial with all cells available
            spikeCountHistConc{iLabel,itest} = cat(1,spikeCountHistConc{iLabel,itest},spikeCountHist{ifile,iLabel,itest});
            centerHistConc{iLabel,itest} = cat(1,centerHistConc{iLabel,itest},centerHist{ifile,iLabel,itest});
            pseudoTrial{iLabel,itest} = cat(1,pseudoTrial{iLabel,itest}, testspikeCount{ifile,iLabel,itest});          
        end
    end
end

code.WOI = WOI;
code.binsize = binsize;
code.selcLabel = selcLabel;
code.int_list = int_list;
code.filelist = flist(nfiles);code.nbin = nbin;
code.nchn = nchn;
code.nTest = nTest;
code.spikeCountHistConc =spikeCountHistConc;
code.centerHistConc = centerHistConc;
code.pseudoTrial = pseudoTrial;
code.sweepf = sweepf;
code.bin_end = bin_end;