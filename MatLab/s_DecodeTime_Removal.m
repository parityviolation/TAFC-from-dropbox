% Done but doesn't looke good
% Add smoothing of histogram?
% remove units with low rates?
% **add units from different session (can probably combine and put nan on
% trials that are from different session)
clear all
boverlayplot = 0;
selcInterval =2;
mycolor = 'g';
int_list = [0.6    1.05    1.26    1.74    1.95    2.4]*1000;
nTest = 50;
bd = brigdefs;
flist = dirc([fullfile(bd.Dir.spikesStruct,'SertxChR2_179\') '*.mat']);
fname = flist(:,1);
%fname = flist(4)
nfiles = 1:4; %length(fname);
interval = [];
WOI = [0 2400];
binsize = [500 100];

for ifile = nfiles
    
    load(fullfile(bd.Dir.spikesStruct,'SertxChR2_179\',fname{ifile}));
    %int_list = unique(spikes.sweeps.Interval(~isnan(spikes.sweeps.Interval)));
    
    chn = spikes.Analysis.EU(:,1);
    unit = spikes.Analysis.EU(:,2);
    spikes_cor = filtspikes(spikes,1,{},{'ChoiceCorrect',1});
    interval{ifile} = spikes_cor.sweeps.Interval*spikes_cor.sweeps.Scaling;
    alignEvent = 'TrialInit';
    
    bin_end = WOI(1);
    nsteps = (WOI(2)-WOI(1))/binsize(2);
    
    bin_end = linspace(bin_end,WOI(2),nsteps+1);
    bin_start = bin_end-binsize(1);
    
    
    nchn = length(chn);
    nbin = length(bin_start);
    ntrials = spikes_cor.sweeps.ntrials;
    
    spikeCount{ifile} = nan([nchn,nbin,ntrials]);
    
    for ichn=1:nchn
        these_spikes = filtspikes(spikes_cor,0,{'Electrode',chn(ichn),'Unit',unit(ichn)});
        
        [spikeTimeRelativeToEvent trials] = relativeSpiketimes_spikes(these_spikes,alignEvent,[WOI(1) WOI(2)]);
        % TO DO add smoothing of spikerate
        
         
        for itrial = 1:ntrials
            
            if ismember(itrial,trials)
                ind = trials == itrial;
                for ibin = 1:nbin
                    
                    edges = [bin_start(ibin) bin_end(ibin)];
                    if edges(2)>interval{ifile}(itrial) %stop adding spike counts after the time of the second stimulus
                        break;
                    else
                        spikeCount{ifile}(ichn,ibin,itrial) = sum(spikeTimeRelativeToEvent(ind)> edges(1) & spikeTimeRelativeToEvent(ind)<= edges(2) );
                    end
                end
            else
                spikeCount{ifile}(ichn,:,itrial) = 0; % by default there is no spikes
            end
        end
    end
    
    for itest = 1:nTest % multiple test trials (removing each one from the Template)
        for i_int=selcInterval %making a pseudotrial with all cells available
            these_trials = find(ismember(interval{ifile},int_list(i_int)));
            if ~isempty(these_trials)
                indTest = these_trials(randi(length(these_trials)));
                % remove a trial for Testing
                testspikeCount{ifile,i_int,itest} =spikeCount{ifile}(:,:,indTest);
                subspikeCount = spikeCount{ifile};
                subspikeCount(:,:,indTest) =[];
                
            else
                testspikeCount{ifile,i_int,itest} =nan(size(spikeCount{ifile}(:,:,1)));
            end
            
        end
                
        % create pdf histograme for each bin
        nhistbins = 10;
        spikeCountHist{ifile,itest} = zeros([nchn,nbin,nhistbins]);
        centerHist{ifile,itest} = nan([nchn,nbin,nhistbins]);
        for ichn=1:nchn
            for ibin = 1:nbin
                [a x]  = hist(squeeze(subspikeCount(ichn,ibin,:)));
                centerHist{ifile,itest}(ichn,ibin,:) =  x;
                a(a==0) = 1e-5; % zero probablity is a problem=
                a =  a/sum(a); %get pdf for each bin
                spikeCountHist{ifile,itest}(ichn,ibin,:) =a;
            end
        end
    end
    
    
    % sample a trial
    %  Compute the probablity of each time bin at each time bin.
    % smooth it
    % yy2 = smooth([1:nbin),y,0.1,'rloess');
end


% concatenate all
spikeCountHistConc = cell(nTest,1);
centerHistConc = cell(nTest,1);

pseudoTrial = cell(length(int_list),nTest);

% plot the spikeCountHistf

for ifile = nfiles
    for itest = 1:nTest
        spikeCountHistConc{itest} = cat(1,spikeCountHistConc{itest},spikeCountHist{ifile,itest});
        centerHistConc{itest} = cat(1,centerHistConc{itest},centerHist{ifile,itest});
        for i_int=selcInterval %making a pseudotrial with all cells available
            pseudoTrial{i_int,itest} = cat(1,pseudoTrial{i_int,itest}, testspikeCount{ifile,i_int,itest});
            
        end
    end
end


%% Decoding
decodeSpikeCountCode(code)

nbin = code.nbin;
nTest = code.nTest

pseudoTrial = code.pseudoTrial;
clear testTrials;
p = nan(nbin,nbin,nTest);
clear p_thisbin
for iTestTrial = 1:nTest
    iTestTrial
    testTrials(:,:,iTestTrial) = pseudoTrial{selcInterval,iTestTrial};  % randi(ntrials,1,ntest);

    for iTestbin = 1:nbin
        thisTestTrial =  testTrials(:,iTestbin,iTestTrial);
        for ibin = 1:nbin % for each Possible Time in 'Template'
            p_thisbin(ibin) = 1;
            for ichn=1:nchn
                %                 p_thisbin(ibin)  = p_thisbin(ibin) * interp1(squeeze(centerHist(ichn,ibin,:)), squeeze(spikeCountHist(ichn,ibin,:)),thisTestTrial(ichn));
                [~, ind] = min((centerHistConc{iTestTrial}(ichn,ibin,:)-thisTestTrial(ichn)).^2);
                p_thisbin(ibin)  = p_thisbin(ibin) * spikeCountHistConc{iTestTrial}(ichn,ibin,ind(1));
            end
        end
        p(iTestbin,:,iTestTrial) =  p_thisbin ;
        
    end
end

