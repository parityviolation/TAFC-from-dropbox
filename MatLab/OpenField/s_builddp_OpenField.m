%% builddp_video
% CHECK WHAT PART OF THE VIDEO CAN BE ANALYZED

%dataParsed = loadBstruct();
% DIRPATH = 'C:\Users\Bassam\Dropbox\TAFCmice\OpenField\';
DIRPATH = 'C:\Users\Behave\Desktop\OpenField\';

clear cond
%%
% clear dataParsed
% DIR = 'Sert_866\05242013'
% dataParsed.FileName = 'Sert_866_OpenField_130524_SSAB';
% % dataParsed.Animal = input('Enter Animal:','s')
% dataParsed.Animal = 'Sert_866';
% cond(1).notes  = {'5mW 25Hz 10ms pulse REGULAR INTERVAL'};

clear dataParsed
DIR = 'Sert_866\05302013'
dataParsed.FileName = 'Sert_866_OpenField_130530_SSAB';
% dataParsed.Animal = input('Enter Animal:','s')
dataParsed.Animal = 'Sert_866';
cond(1).notes  = {'5mW 25Hz 10ms pulse blocks of 25 stimulations'};

%%
clear dataParsed
dataParsed.Animal = 'Sert_864';

DIR = 'Sert_864\05242013'
dataParsed.FileName = 'Sert_864_OpenField_130524_SSAB';
cond(1).notes  = {'5mW 25Hz 10ms pulse'};

% DIR = 'Sert_864\05262013'
% dataParsed.FileName = 'Sert_864_OpenField_130526_SSAB';
% cond(1).Desc  = {'5mW 25Hz 10ms pulse blocks of 25 stimulations'};
% dataParsed.Animal = input('Enter Animal:','s')

%%
clear dataParsed
dataParsed.Animal = 'Sert_868';
% 
DIR = 'Sert_868\05252013'
dataParsed.FileName = 'Sert_868_OpenField_130525_SSAB';
cond(1).notes  = {'5mW 25Hz 20ms pulse REGULAR INTERVAL 20s'};

% DIR = 'Sert_868\05262013'
% dataParsed.FileName = 'Sert_868_OpenField_130526_SSAB';
% dataParsed.Animal = input('Enter Animal:','s')
% cond(1).notes  = {'5mW 25Hz 10ms pulse blocks of 25 stimulations'};

%%
clear dataParsed
dataParsed.Animal = 'Sert_867';

% SMALL EFFECT?
DIR = 'Sert_867\05242013'
dataParsed.FileName = 'Sert_867_OpenField_130524_SSAB';
% dataParsed.Animal = input('Enter Animal:','s')
cond(1).notes  = {'5mW 25Hz 10ms pulse'};

%%
DIR = fullfile(DIRPATH,DIR);

cd(DIR)
filevidtimes = 'vid_time.csv';
fileTTL = 'led22.csv';
fileCM = 'centroidXY.csv';

dataParsed.AnimalSpecies = 'mice';
dataParsed.Protocol = 'OpenField'; % a hack

dataParsed = getFramesTimes(dataParsed,fullfile(DIR,filevidtimes));
dataParsed = addVideoInfo(dataParsed);


cond(1).event = {};
cond(1).eventdesc = {};
cond(1).eventdesc{1} = 'On';
cond(1).eventdesc{2} = 'Off';
cond(1).color = 'b';
cond(1).desc = 'light';

for icond = 1:length(cond)
    [TTLon TTLoff junk TTLsignal] =   getTTLfromAnalog(fullfile(DIR,fileTTL));
    cond(icond).event{1} = TTLon;
%     cond(icond).event{2} = TTLoff;
     
    % find first offset that follows an onset
    ind_firstOFF = find(min(TTLoff>min(TTLon)),1,'first');
    ind_firstON = find(max(TTLon)<TTLoff(ind_firstOFF));
    cond(icond).Duration = TTLoff(ind_firstOFF) - TTLon(ind_firstON);
end

cond(2).color = 'k';
cond(2).desc = 'control';
% cond(2).event{1} = cond(1).event{1} +300*30;
% cond(2).event{1} = cond(2).event{1}(cond(2).event{1}<length(dp.video.cm.speed));
fr_noStim = find(~TTLsignal);
cond(2).event{1} =  fr_noStim(round(rand(size(TTLoff)).*length(fr_noStim)));

dataParsed.cond = cond;
dataParsed = addcm(dataParsed,fullfile(DIR,fileCM));
dataParsed.TTL = double(TTLsignal);

saveBstruct(dataParsed);
%%
% condition speed
dp = dataParsed;
hz = dp.video.info.meanFrameRate ;
dp.video.cm.speed =dp.video.cm.speed(~isnan(dp.video.cm.speed))  ;
sm = filtdata(dp.video.cm.speed,hz,.4,'low');

figure(100);clf; 
subplot(1,2,1)
plot(dp.video.cm.xy(:,1),dp.video.cm.xy(:,2),'linewidth',0.1)
axis tight equal
% [x y]  = ginput(4);  % include only selected ROI
% in = inpolygon(dp.video.cm.xy(:,1),dp.video.cm.xy(:,2),x,y);
% sm(~in) = nan;

dp.video.cm.speed = sm;
% dp.video.cm.speed(dp.video.cm.speed>100) = nan; %% really big velcities are not real

subplot(1,2,2)
plot([1:length(dp.video.cm.speed)]*1/hz,dp.video.cm.speed','k','linewidth',0.1); hold on
plot([1:length(sm)]*1/hz,sm,'c','linewidth',0.1); hold on
plot(dp.cond(1).event{1}*1/hz,ones(size(dp.cond(1).event{1}))*10,'.b');

% hist(dp.video.cm.speed,1000)
% set(gca,'Yscale','log')

speedFig(dp,dp.cond)
% %%
% 
% figure(1);clf;
% 
% % excludeInd = dp.video.cm.xy(:,1)<190 | dp.video.cm.xy(:,2)>500;
% % dp.video.cm.speed(excludeInd) = NaN;
% % % dp.video.cm.speed(abs( dp.video.cm.speed)<1) = nan;
% % dp.video.cm.speed(abs( dp.video.cm.speed)>30) = nan;
% 

%%

