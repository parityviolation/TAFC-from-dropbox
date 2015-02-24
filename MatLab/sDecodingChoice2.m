% Build choice decoder
% put in only spikes only for choice LEFt or RIGHT
%

% INPUT: spikestruct
%        binsize, binoffset
% Create binedges
%
%
bdebug = 0
r = brigdefs;

savepath = 'C:\Users\Behave\Dropbox (Learning Lab)\PatonLab\Paton Lab\Data\TAFCmice\Ephys\InTask\Analysis\SertxChR2_179\DecodingTime'
savename = 'decode_v2_ChoiceCorrect';

p  = fullfile(r.Dir.spikesStruct, 'SertxChR2_179');
% ss = {'SertxChR2_179_D140223F1_spikes'};
d = dirc(fullfile(p,'*.mat'));
spikeStructFile = d(:,1);
spikeStructFile = spikeStructFile(2:end,1);
nfiles = [1:length(spikeStructFile)];

WOIbin_end = [0 2400];
binsize = [500 100];
spkCountEdge = [0:1:25]; % CHANGE.. THIS should be one a unit to unit basis
spkCountSmooth = 10;
NTESTTRIALS = 100;



INTVSET =  round(100*([0.6    1.05    1.26    1.74    1.95    2.4]/3));

clear cond
clear decode
cond(1).sweepf = {'ChoiceCorrect',1};
% cond(2).sweepf = {'ChoiceLeft',1,'ChoiceCorrect',1};


ncond  = length(cond);
ntrials = zeros(1,ncond);



% ReSet
for  intv = 1:length(INTVSET)
    for icond = 1:ncond
        decode(intv,icond).pseudoTrial = [];
        for itestTrial = 1:NTESTTRIALS
            decode(intv,icond).leaveOutTemplate{itestTrial} =[];
        end
    end
end

for ifile =nfiles % loop through sessions
    load(fullfile(r.Dir.spikesStruct, 'SertxChR2_179',spikeStructFile{ifile}))
    EUPlus = spikes.Analysis.EUPlusLabel;
    for iEU = 1:size(EUPlus,1)
        [spikes]= addUnits_spikes(spikes, EUPlus(iEU,:) );
    end
    spikes = rmfield(spikes,'waveforms'); % remove waveforms
    
    % helper create trials x timebin x unit in spikes.sweeps
    [~, spikes, bin_end] = addSpikeCountMatrix_spikes(spikes,WOIbin_end); % takes a long time
    spikeCount = spikes.sweeps.spikeCount;
    
    % spike Count Bin Edges
    temp  = reshape(spikeCount,size(spikeCount,1)*size(spikeCount,2),size(spikeCount,3));
    removeInd = all(isnan(temp));
    temp(:,removeInd) = [];
    spikeCount(:,:,removeInd) = [];
    spikes.sweeps.spikeCount = spikeCount;
    
    % to make spkCountEdges unit specific
    %     spkCountEdge = min(temp,[],1) max(temp,[],1)
    %     nunit(ifile) = size(spikeCount,3);
    %     for iunit = 1
    
    spikes.sweeps.IntervalR = round(spikes.sweeps.Interval*100); % Round
    intvSet = round(spikes.sweeps.IntervalSet*100);
    IND = find(ismember(INTVSET,intvSet));
     
    % declare variable
    for icond = 1:ncond %spkcountbin, timebin, units
        thisFile_spkCntHist_Template{icond} = nan(length(spkCountEdge),size(spikes.sweeps.spikeCount,2),size(spikes.sweeps.spikeCount,3)); 
    end
    for intv = IND %    loop through intervals
        % %         calculate weighting (choice variance or interval)
        thesesweeps = filtbdata(spikes.sweeps,0,{'IntervalR',INTVSET(intv)});
        n = sum(ismember(thesesweeps.ChoiceLeft,[0 1]));
        p = nansum(thesesweeps.ChoiceLeft)/n; % P(long)
        cv = p*(1-p);  % 'choice variance' use to Weight .. ranges 0-0.25
        
        % nan out bins that are after TONE2
        ind = find(bin_end<=INTVSET(intv)/100*spikes.sweeps.Scaling,1,'last');
        thesesweeps.spikeCount(:,ind+1:end,:) = NaN;
        
        for icond = 1:ncond % for LEFT and RIGHT (Template)
            tempthesesweeps = filtbdata(thesesweeps,0,cond(icond).sweepf);
            if tempthesesweeps.ntrials > 1
                % note: there is no normalization here ... what is an N? if we really need one?
                thisFile_spkCntHist_Template{icond} = nansum(cat(4,thisFile_spkCntHist_Template{icond} ,cv * histc(tempthesesweeps.spikeCount,spkCountEdge)),4); % do it this way to ignore nans
            end
        end
    end
    
    
    if bdebug
        figure('Name',spikeStructFile{ifile});
        mycolor = jet(size(spkCountHist,2));
    end
    
    % % PSEUDOTRIALS AND LEAVEoneoutTTEMPLATE
    for intv = IND %    loop through intervals
        thesesweeps = filtbdata(spikes.sweeps,0,{'IntervalR',INTVSET(intv)});
        
        n = sum(ismember(thesesweeps.ChoiceLeft,[0 1]));
        p = nansum(thesesweeps.ChoiceLeft)/n; % P(long)
        cv = p*(1-p); % 'choice variance' use to Weight .. ranges 0-0.25
        
        % nan out bins that are after TONE2
        ind = find(bin_end<=INTVSET(intv)/100*spikes.sweeps.Scaling,1,'last');
        spikes.sweeps.spikeCount(:,ind+1:end,:) = NaN;
        
        for icond = 1:ncond % e.g. for LEFT and RIGHT (Template)
            tempthesesweeps = filtbdata(thesesweeps,0,cond(icond).sweepf);
            if tempthesesweeps.ntrials
                testTrials = randi(tempthesesweeps.ntrials,NTESTTRIALS,1);
                if isempty(decode(intv,icond).pseudoTrial), decode(intv,icond).pseudoTrial =tempthesesweeps.spikeCount(testTrials,:,:);
                else            decode(intv,icond).pseudoTrial = cat(3, decode(intv,icond).pseudoTrial,tempthesesweeps.spikeCount(testTrials,:,:)); end
                
                for iTrial = 1:length(testTrials) % for each test trial
                    temp = cat(1,tempthesesweeps.spikeCount(testTrials(iTrial),:,:),tempthesesweeps.spikeCount(testTrials(iTrial),:,:)); % this is a trick to use histc on a single trial
                    spkCountHist = nansum(cat(4,thisFile_spkCntHist_Template{icond} ,-1*cv * histc(temp,spkCountEdge)/2),4); % Leave trial OUT of  Template by subtracting the trial
                    

                    for iunit = 1:size(spkCountHist,3) % must loops because of smooth function
                        for itimebin = 1:size(spkCountHist,2)
                            thisspkCountHist = spkCountHist(:,itimebin,iunit);
                            thisspkCountHist= smooth(thisspkCountHist,spkCountSmooth,'loess');
                            thisspkCountHist(thisspkCountHist < 0) = 0;
                            thisspkCountHist = thisspkCountHist/sum(thisspkCountHist);
                            thisspkCountHist = thisspkCountHist*0.9 + 1*0.1; % add uniform distribution to remove zeros
                            spkCountHist(:,itimebin,iunit) = thisspkCountHist;
                            
                            if bdebug & iTrial==1 & icond==1 & intv==1
                                nr = 5;               nc = ceil(size(spkCountHist,3)/nr);
                                subplot(nr,nc,iunit)
                                %                                 plot(thisspkCountHist+.5*(itimebin-1),'color',mycolor(itimebin,:)); hold on;
                                plot(thisspkCountHist,'color',mycolor(itimebin,:)); hold on;
                                axis tight
                                set(gca,'Color','none')
                                setTitle(gca,spikes.units.label{iunit})

                            end
                        end
                    end
                    
                     if isempty(decode(intv,icond).leaveOutTemplate{iTrial})
                        decode(intv,icond).leaveOutTemplate{iTrial} =spkCountHist;
                    else
                        decode(intv,icond).leaveOutTemplate{iTrial} = cat(3,decode(intv,icond).leaveOutTemplate{iTrial},spkCountHist);  % concat this file with Across Files Template
                    end
                end
                
           
            end
        end
        
    end
end


save(fullfile(savepath,savename),'decode','cond','WOIbin_end','binsize','spkCountEdge','spkCountSmooth','NTESTTRIALS','nfiles','spikeStructFile',...
    'INTVSET')

s_Decoding2_Part2
        