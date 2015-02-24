function spikes  = buildSpikes2(nevfilename,savefileFooter,spikes,buildoptions)
% filename =  'E:\Bass\ephys\copy\022714\datafile002-01.nev';
% function spikes = buildSpikes(nevfilename,savefileFooter
if nargin < 2
    savefileFooter = '';
end

bAppend = 0 ;
if ~isempty(spikes)
    spikesIn = spikes; % this is stupid should find a way ot concatenate if spikes is toobig
    clear spikes
    bAppend = 1;
end

if ~exist('buildoptions','var')
    buildoptions.bNoWaveforms = 0;
end
if ~isfield( buildoptions,'bNOVideo'),  buildoptions.bNOVideo = 1; end
if ~isfield( buildoptions,'bRecomputeDp'),  buildoptions.bRecomputeDp = 0; end

bNOVideo =  buildoptions.bNOVideo;
bRecomputeDp =buildoptions.bRecomputeDp ;
% get behavior data
dp = builddp(bRecomputeDp,bNOVideo);

% get ephys data
dnev = openNEV(nevfilename, 'report','overwrite');
if isempty(dnev)
    error([nevfilename '  No Nev file found'])
end
dt = 1/double(dnev.MetaTags.SampleRes);

% figure out relative time of behavior and ephys data
    % get Ephys.trialAvail
trailAvailEphys = dnev.Data.SerialDigitalIO.TimeStampSec*1000; %dnev.Data.SerialDigitalIO.TimeStamp*dt
% warning(' Check Ephys is aligned to Behavior data')

if 0 % code to offset behavior trials 
    offsetBehavior = 33;
    dp = filtbdata(dp,0,{'TrialNumber',[offsetBehavior:sweeps.ntrials]})
end
sweeps = createSweeps(dp);

% % % THIS assumes there are more TTLs on EPhys than Behavior. 
% % % IT DOESN NOT work if the opposite is true
% Since there are sometimes extra TTLs on the Ephys BEFORE the part of the
% file that is synchronized to Behavior this code find the best offset to
% make the sync match
for iOffset_TAE = 1:length(trailAvailEphys)
    thisTrialAE = trailAvailEphys(iOffset_TAE:end);
    thisTrialAE = thisTrialAE - trailAvailEphys(1);
    this_nTrialsAvailEphysAndBehavior = min(length(dp.TrialAvail),length(thisTrialAE));
    delta(iOffset_TAE) = sum(abs((dp.TrialAvail(1:this_nTrialsAvailEphysAndBehavior)-dp.TrialAvail(1)) - thisTrialAE(1:this_nTrialsAvailEphysAndBehavior)));
end
[~,selectedOffset ] = min(delta);

if selectedOffset == length(trailAvailEphys)
    keyboard % something is wrong the best match is on the last trial
end

INTERTRIALINTERVAL = 9*1000;

trailAvailEphys = trailAvailEphys(selectedOffset:end); % if recording is started before behavior, then there will be one extra sync from when behavior started BUt before the real TrialAvail
    % find out of syncs match
nTrialsAvailEphys = length(trailAvailEphys);
nTrialsAvailEphysAndBehavior = min(length(dp.TrialAvail),nTrialsAvailEphys);

timeDiff = diff(dp.TrialAvail(1:nTrialsAvailEphysAndBehavior))-diff(trailAvailEphys(1:nTrialsAvailEphysAndBehavior));
if any(timeDiff> 100) & selectedOffset==1 % for some reason sometimes this is wrong by 1 HACKED to fix
    selectedOffset = 2;
    trailAvailEphys = trailAvailEphys(selectedOffset:end); % if recording is started before behavior, then there will be one extra sync from when behavior started BUt before the real TrialAvail
    % find out of syncs match
    nTrialsAvailEphys = length(trailAvailEphys);
    nTrialsAvailEphysAndBehavior = min(length(dp.TrialAvail),nTrialsAvailEphys);
end
timeDiff = diff(dp.TrialAvail(1:nTrialsAvailEphysAndBehavior))-diff(trailAvailEphys(1:nTrialsAvailEphysAndBehavior));

if 1 % check for consistency of timing Between arduion and Ephys

    figure
    subplot(1,3,1)
    plot(dp.TrialAvail(1:nTrialsAvailEphysAndBehavior)-dp.TrialAvail(1))
    hold all
    plot(trailAvailEphys(1:nTrialsAvailEphysAndBehavior)-trailAvailEphys(1))
    legend({'Arduino','Ephys'})
    xlabel('Trial')
    ylabel('Time')
 
    subplot(1,3,2)
    plot(timeDiff)
    ind = find(timeDiff > 100);
    hold all; plot(ind,timeDiff(ind),'.r')
    
    xlabel('trial')
    ylabel('TimeDiff = diff(Behavior) - diff(Ephys) (ms)')
    title('TimeDiff TrialAvail Arduino - Cerebus')
    
    subplot(1,3,3)
    plot(diff(dp.TrialAvail(1:nTrialsAvailEphysAndBehavior)),timeDiff,'.')
    xlabel('diff(Behavior) i.e trial Length (ms)')
    ylabel('TimeDiff (ms)')
    [B,BINT] = regress(timeDiff',diff(dp.TrialAvail(1:nTrialsAvailEphysAndBehavior))');
    
    sweeps.arduinoTimeScalar = 1+B;
    sweeps.ephysTimeScalar = 1-B;
    title(['TimeArduino = ' num2str(sweeps.arduinoTimeScalar,'%1.6f') ' x TimeCerebus']);
    if any(timeDiff> 100)
        warning('There may be a Syncing problem between Behavior and Ephys');
        keyboard % could be that the selectedOffset Is WRONG 
    end
end

sweeps.TrialAvailEphys = trailAvailEphys; % ms
sweeps.nTrialsAvailEphysAndBehavior = nTrialsAvailEphysAndBehavior;
sweeps.nTrialsAvailEphys = nTrialsAvailEphys;

% create spikes

[LOADPATH fname] = fileparts(nevfilename);
spikes                      = ss_default_params_custom_Cerebus(1/dt);

spikes.info.spikesfile      = fullfile(LOADPATH,'spikes',['spikes_' strrep(fname,'.','_') '_' savefileFooter '.mat']);
parentfolder(fileparts(spikes.info.spikesfile) ,1)
spikes.info.nev             = dnev.MetaTags;
if ~buildoptions.bNoWaveforms
    spikes.waveforms            = dnev.Data.Spikes.Waveform';
end
spikes.Electrode            = dnev.Data.Spikes.Electrode;
spikes.Unit                 = dnev.Data.Spikes.Unit;
spikes.info.detect.dur      = dnev.MetaTags.DataDurationSec*1000;
spikes.assigns = uint16(spikes.Electrode*100)+uint16(spikes.Unit ); % this field is used by ultamegasort functions

% get spiketimes relative to the beginning of the trial
% Zero Time in trial is time of sync
spikes.spiketimes           = double(dnev.Data.Spikes.TimeStamp)*dt*1000;
spikes.unwrapped_times = spikes.spiketimes/1000;
spikes.TrialNumber          = zeros(size(spikes.spiketimes),'int16');
% spikes.spiketimes_inTrial   = zeros(size(spikes.spiketimes));
clear dnev;

tempTrialAvail = [sweeps.TrialAvailEphys sweeps.TrialAvailEphys(end)+INTERTRIALINTERVAL];% add end to the last trial
% label the trial of each spike
for itrial = 1:sweeps.nTrialsAvailEphysAndBehavior
    spikesInTrial = tempTrialAvail(itrial) <= spikes.spiketimes ...
        & spikes.spiketimes < tempTrialAvail(itrial+1);
    spikes.TrialNumber(spikesInTrial) = int16(itrial);
%     spikes.absolute_trial=  spikes.TrialNumber;
%     spikes.spiketimes_inTrial(spikesInTrial) = spikes.spiketimes(spikesInTrial) - tempTrialAvail(itrial);
    
end

% spikes.spiketimes_inTrial   = spikes.spiketimes_inTrial*sweeps.arduinoTimeScalar;% convert time to time in Arudino
% %  Use arduino time as real time (probably not as robust as  Cerebus but since we are using it for video timing too...)
% %

if bAppend
   spikesIn.sweeps = rmfield(spikesIn.sweeps,'stats');
    sweeps = concdp(spikesIn.sweeps,sweeps);
    
    [p name]  = fileparts(spikes.info.spikesfile);
    spikesIn.info.spikesfile = fullfile(p,[name '_multiple.mat']);
    
    spikesIn.info.nev(end+1)             = spikes.info.nev;
    if isfield(spikesIn,'waveforms')
        spikesIn.waveforms            = [spikesIn.waveforms; spikes.waveforms];
    end
    spikesIn.Electrode            = [spikesIn.Electrode spikes.Electrode];
    spikesIn.Unit                 = [spikesIn.Unit spikes.Unit];
    spikesIn.info.detect.dur      = spikesIn.info.detect.dur + spikes.info.detect.dur;
    spikesIn.spiketimes           = [spikesIn.spiketimes spikes.spiketimes]; 
    spikesIn.TrialNumber          =  [spikesIn.TrialNumber spikes.TrialNumber+max(spikesIn.TrialNumber)]; 
    disp(['concatenating ' spikes.info.spikesfile 'to spikes'] )
    
    spikesIn.nTrialsAvailEphysAndBehavior = [ spikesIn.nTrialsAvailEphysAndBehavior spikes.nTrialsAvailEphysAndBehavior]; % BA untested 5/29/14
    spikesIn.nTrialsAvailEphys = [ spikesIn.nTrialsAvailEphys spikes.nTrialsAvailEphys]; % BA untested 5/29/14
    spikes = spikesIn;
    
end

spikes.sweeps = sweeps;

