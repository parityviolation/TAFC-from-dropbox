
%% builddp_video
% CHECK WHAT PART OF THE VIDEO CAN BE ANALYZED

%dataParsed = loadBstruct();
% DIRPATH = 'C:\Users\Bassam\Dropbox\TAFCmice\OpenField\';
DIRPATH = 'F:\TAFCmiceWaiting\OpenField\';

clear cond
%%
clear dataParsed
DIR = 'FI12xArch_121\10162013'
dataParsed.FileName = 'FI12xArch_121_OpenField_10152013_SSAB';
% dataParsed.Animal = input('Enter Animal:','s')
dataParsed.Animal = 'FI12xArch_121';
cond(1).notes  = {'30mW Continuous 15sec stim every sec,+-rand'};

%%

DIR = fullfile(DIRPATH,DIR);

cd(DIR)
filevidtimes = 'vid_time.csv';
fileTTL = 'led_intensity.csv';
fileCM = 'centroidXY.csv';
fileCMAngle = 'centroidOri.csv';
filePixelChange = 'pixel_change_sum.csv';

dataParsed.AnimalSpecies = 'mice';
dataParsed.Protocol = 'OpenField'; % a hack

dataParsed = getFramesTimes(dataParsed,fullfile(DIR,filevidtimes));
dataParsed = addVideoInfo(dataParsed);
frameRate = 90;
dataParsed.video.frameRate = frameRate; %a hack

windowSeparation = 0.300*frameRate;%frames to look for movement for spliting into groups
timeBackControl = 15; %time in seconds to look back for a chunck of time to use as control 

%windowStartEnd = 7; %time in seconds for a window before and after stimulation 
%%


cond(1).event = {};
cond(1).eventdesc = {};
cond(1).eventdesc{1} = 'On';
cond(1).eventdesc{2} = 'Off';
cond(1).color = 'b';
cond(1).desc = 'light';

for icond = 1:length(cond)
    [TTLon TTLoff junk TTLsignal] = getTTLfromAnalog(fullfile(DIR,fileTTL));
    cond(icond).event{1} = TTLon;
    % find first offset that follows an onset
    ind_firstOFF = find(min(TTLoff>min(TTLon)),1,'first');
    ind_firstON = find(max(TTLon<TTLoff(ind_firstOFF)),1,'first');
    cond(icond).Duration = TTLoff(ind_firstOFF) - TTLon(ind_firstON);
    cond(icond).event{2} = TTLon + cond(icond).Duration;
    
    %a hack in case the session started with stimulation and there is no
    %@control@ in the first trial
    cond(icond).event{1} = cond(icond).event{1}(2:end);
    cond(icond).event{2} = cond(icond).event{2}(2:end);
end

%%
cond(2).color = 'k';
cond(2).desc = 'control';
% cond(2).event{1} = cond(1).event{1} +300*30;
% cond(2).event{1} = cond(2).event{1}(cond(2).event{1}<length(dp.video.cm.speed));
fr_noStim = find(~TTLsignal);
cond(2).event{1} = cond(icond).event{1} - (timeBackControl*frameRate);
cond(2).event{2} = cond(icond).event{2} - (timeBackControl*frameRate);

pixelChange = readBonsaiCSVnoTime(filePixelChange);

dataParsed.cond = cond;
dataParsed = addcm(dataParsed,fullfile(DIR,fileCM));
dataParsed.TTL = double(TTLsignal);
dataParsed.video.pixelChangeSum =  pixelChange;

saveBstruct(dataParsed);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SpeedSeparationControl =zeros(length(cond(2).event{1}),windowSeparation+1);
meanSpeedSeparationControl =zeros(length(cond(2).event{1}),1);
SpeedSeparation =zeros(length(cond(2).event{1}),windowSeparation+1);
meanSpeedSeparation =zeros(length(cond(2).event{1}),1);

pixelChange(pixelChange==0)=0.1;

for i=1:length(cond(2).event{1})
SpeedSeparation(i,:) = pixelChange(cond(1).event{1}(i)-windowSeparation:cond(1).event{1}(i));
meanSpeedSeparation(i) = mean(SpeedSeparation(i,:));

SpeedSeparationControl(i,:) = pixelChange(cond(2).event{1}(i)-windowSeparation:cond(2).event{1}(i));
meanSpeedSeparationControl(i) = mean(SpeedSeparationControl(i,:));

end

figure
hist(log(meanSpeedSeparation),300)
title('SpeedSeparation')

figure
hist(log(meanSpeedSeparationControl),300)
title('SpeedSeparationControl')


meanSpeedSeparation2 = [meanSpeedSeparation (1:length(meanSpeedSeparation))'];
sortedmeanSpeedSeparation = sortrows(meanSpeedSeparation2,1);
stopedStim = sortedmeanSpeedSeparation(1:round(length(sortedmeanSpeedSeparation))/2,2);
movingStim = sortedmeanSpeedSeparation(length(stopedStim)+1:length(sortedmeanSpeedSeparation),2);

meanSpeedSeparationControl2 = [meanSpeedSeparationControl (1:length(meanSpeedSeparationControl))'];
sortedmeanSpeedSeparationControl = sortrows(meanSpeedSeparationControl2,1);
stopedControl = sortedmeanSpeedSeparationControl(1:round(length(sortedmeanSpeedSeparationControl))/2,2);
movingControl = sortedmeanSpeedSeparationControl(length(stopedControl)+1:length(sortedmeanSpeedSeparationControl),2);

for i=1:length(stopedStim)
stopedStimPxCh(i,:) = pixelChange(cond(1).event{1}(stopedStim(i))-windowSeparation:cond(1).event{1}(stopedStim(i))+cond(icond).Duration);

end

%plot(mean(log(stopedStimPxCh),1))

for i=1:length(movingStim)
movingStimPxCh(i,:) = pixelChange(cond(1).event{1}(movingStim(i))-windowSeparation:cond(1).event{1}(movingStim(i))+cond(icond).Duration);

end



for i=1:length(stopedControl)
stopedControlPxCh(i,:) = pixelChange(cond(2).event{1}(stopedControl(i))-windowSeparation:cond(2).event{1}(stopedControl(i))+cond(icond).Duration);

end

%plot(mean(log(stopedStimPxCh),1))

for i=1:length(movingControl)
movingControlPxCh(i,:) = pixelChange(cond(2).event{1}(movingControl(i))-windowSeparation:cond(2).event{1}(movingControl(i))+cond(icond).Duration);

end

figure
plot(mean(stopedStimPxCh,1),'b');hold on;
plot(mean(stopedControlPxCh,1),'k');
title('mean stopedStim vs stopedControl')

figure
plot(mean(movingStimPxCh,1),'b');hold on;
plot(mean(movingControlPxCh,1),'k');
title('mean movingStim vs movingControl')


figure
plot(mean(log(stopedStimPxCh),1),'b');hold on;
plot(mean(log(stopedControlPxCh),1),'k');
title('log stopedStim vs stopedControl')

figure
plot(mean(log(movingStimPxCh),1),'b');hold on;
plot(mean(log(movingControlPxCh),1),'k');
title('log movingStim vs movingControl')




