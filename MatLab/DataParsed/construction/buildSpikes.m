function spikes  = buildSpikes(nevfilename,savefileFooter)

% filename =  'E:\Bass\ephys\copy\022714\datafile002-01.nev';
% function spikes = buildSpikes(nevfilename,savefileFooter
if nargin < 3
    savefileFooter = '';
end

% get behavior data
dp = builddp(1,1);
sweeps = createSweeps(dp);

% get ephys data
dnev = openNEV(nevfilename, 'report','overwrite');
dt = 1/double(dnev.MetaTags.SampleRes);

% figure out relative time of behavior and ephys data
    % get Ephys.trialAvail
trailAvailEphys = dnev.Data.SerialDigitalIO.TimeStampSec*1000; %dnev.Data.SerialDigitalIO.TimeStamp*dt
trailAvailEphys = trailAvailEphys(2:end); % if recording is started before behavior, then there will be one extra sync from when behavior started BUt before the real TrialAvail
INTERTRIALINTERVAL = 9*1000;
    % find out of syncs match
nTrialsAvailEphys = length(trailAvailEphys);
nTrialsAvailEphysAndBehavior = min(length(dp.TrialAvail),nTrialsAvailEphys);

if 1 % check for consistency of timing Between arduion and Ephys
    timeDiff = diff(dp.TrialAvail(1:nTrialsAvailEphysAndBehavior))-diff(trailAvailEphys(1:nTrialsAvailEphysAndBehavior));
    figure
    subplot(1,2,1)
    plot(timeDiff)
    ind = find(timeDiff > 100);
    hold all; plot(ind,timeDiff(ind),'.r')
    
    xlabel('trial')
    ylabel('TimeDiff = diff(Behavior) - diff(Ephys) (ms)')
    title('TimeDiff TrialAvail Arduino - Cerebus')
    
    subplot(1,2,2)
    plot(diff(dp.TrialAvail(1:nTrialsAvailEphysAndBehavior)),timeDiff,'.')
    xlabel('diff(Behavior) i.e trial Length (ms)')
    ylabel('TimeDiff (ms)')
    [B,BINT] = regress(timeDiff',diff(dp.TrialAvail(1:nTrialsAvailEphysAndBehavior))');
    
    sweeps.arduinoTimeScalar = 1+B;
    sweeps.ephysTimeScalar = 1-B;
    title(['TimeArduino = ' num2str(sweeps.arduinoTimeScalar,'%1.6f') ' x TimeCerebus']);
    if any(timeDiff> 100)
        warning('There may be a Syncing problem between Behavior and Ephys');
        keyboard
    end
end

sweeps.TrialAvailEphys = trailAvailEphys; % ms
sweeps.nTrialsAvailEphysAndBehavior = nTrialsAvailEphysAndBehavior;
sweeps.nTrialsAvailEphys = nTrialsAvailEphys;

% create spikes

[LOADPATH fname] = fileparts(nevfilename);
spikes = ss_default_params_custom_Cerebus(1/dt);
spikes.info.spikesfile = fullfile(LOADPATH,'spikes',['spikes_' strrep(fname,'.','_') '_' savefileFooter '.mat']);
parentfolder(fileparts(spikes.info.spikesfile) ,1)
spikes.info.nev = dnev.MetaTags;
spikes.waveforms = dnev.Data.Spikes.Waveform';
spikes.Electrode = dnev.Data.Spikes.Electrode;
spikes.Unit = dnev.Data.Spikes.Unit;
spikes.info.detect.dur = dnev.MetaTags.DataDurationSec*1000;
% get spiketimes relative to the beginning of the trial
% Zero Time in trial is time of sync
spikes.spiketimes = double(dnev.Data.Spikes.TimeStamp)*dt*1000;
spikes.TrialNumber = zeros(size(spikes.spiketimes),'int16');
spikes.spiketimes_inTrial = zeros(size(spikes.spiketimes));

tempTrialAvail = [sweeps.TrialAvailEphys sweeps.TrialAvailEphys(end)+INTERTRIALINTERVAL];% add end to the last trial
% label the trial of each spike
for itrial = 1:sweeps.nTrialsAvailEphysAndBehavior
    spikesInTrial = tempTrialAvail(itrial) <= spikes.spiketimes ...
        & spikes.spiketimes < tempTrialAvail(itrial+1);
    spikes.TrialNumber(spikesInTrial) = int16(itrial);
    spikes.spiketimes_inTrial(spikesInTrial) = spikes.spiketimes(spikesInTrial) - tempTrialAvail(itrial);
    
end

spikes.spiketimes_inTrial = spikes.spiketimes_inTrial*sweeps.arduinoTimeScalar;% convert time to time in Arudino
%  Use arduino time as real time (probably not as robust as  Cerebus but since we are using it for video timing too...)
%
spikes.sweeps = sweeps;