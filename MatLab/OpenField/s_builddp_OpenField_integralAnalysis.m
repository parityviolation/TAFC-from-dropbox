%% builddp_video
% CHECK WHAT PART OF THE VIDEO CAN BE ANALYZED

%dataParsed = loadBstruct();
DIRPATH = 'C:\Users\User\Desktop\OpenField\';
% DIRPATH = 'C:\Users\Behave\Desktop\OpenField\';
clear dataParsed
clear cond
stimulationDuration = 3;
Interval = 10; % sec
cond(1).WOI = [3 Interval]; % sec
cond(1).baseline = -3; % sec
TrialPerBlock = 30;
blockLength = (TrialPerBlock * Interval * hz)/2;

frameNumRange = [];
%%
% clear dataParsed
% DIR = 'Sert_866\05242013'
% dataParsed.FileName = 'Sert_866_OpenField_130524_SSAB';
% % dataParsed.Animal = input('Enter Animal:','s')
% cond(1).notes  = {'5mW 25Hz 10ms pulse REGULAR INTERVAL'};

% clear dataParsed
% DIR = 'Sert_866\05302013';
% dataParsed.FileName = 'Sert_866_OpenField_130530_SSAB';
% cond(1).notes  = {'5mW 25Hz 10ms pulse blocks of 25 stimulations'};

%%%
% dataParsed.Animal = 'Sert_864';
% DIR = 'Sert_864\05242013'
% dataParsed.FileName = 'Sert_864_OpenField_130524_SSAB';
% cond(1).notes  = {'5mW 25Hz 10ms pulse'};
%
% DIR = 'Sert_864\05262013'
% dataParsed.FileName = 'Sert_864_OpenField_130526_SSAB';
% cond(1).Desc  = {'5mW 25Hz 10ms pulse blocks of 25 stimulations'};

%%%
% dataParsed.Animal = 'Sert_868';
% %
% DIR = 'Sert_868\05252013'
% dataParsed.FileName = 'Sert_868_OpenField_130525_SSAB';
% cond(1).notes  = {'5mW 25Hz 20ms pulse REGULAR INTERVAL 20s'};
%
% DIR = 'Sert_868\05262013'
% dataParsed.FileName = 'Sert_868_OpenField_130526_SSAB';
% cond(1).notes  = {'5mW 25Hz 10ms pulse blocks of 25 stimulations'};

%%%
% dataParsed.Animal = 'Sert_1422' % REDO>
% dataParsed.Date = '011914';  frameNumRange = [1 64000];
dataParsed.Animal = 'Sert_1421'
dataParsed.Date = '011914';   %frameNumRange = [1 64000];
%
% % SMALL EFFECT?
% DIR = 'Sert_867\05242013'
% dataParsed.FileName = 'Sert_867_OpenField_130524_SSAB';
% cond(1).notes  = {'5mW 25Hz 10ms pulse'};

DIR = [dataParsed.Animal '\' dataParsed.Date];
dataParsed.FileName = [dataParsed.Animal '_OpenField_' dataParsed.Date '_SSAB'];
cond(1).notes  = {'3.5-5mW 3sec on 7sec off sets of 30 on and off'};

%%
if 0%existBstruct(dataParsed.FileName)
    loadBstruct(dataParsed.FileName)
else
    DIR = fullfile(DIRPATH,DIR);
    
    cd(DIR)
    filevidtimes = 'vid_time.csv';
    fileTTL = 'led22.csv';
    fileCM = 'centroidXY.csv';
    
    dataParsed.AnimalSpecies = 'mice';
    dataParsed.Protocol = 'OpenField'; % a hack
    
    dataParsed = getFramesTimes(dataParsed,fullfile(DIR,filevidtimes));
    dataParsed = addVideoInfo(dataParsed);
    
    clear cond
    cond(2).event = {};
    cond(2).eventdesc = {};
    cond(2).eventdesc{1} = 'On';
    cond(2).color = 'b';
    cond(2).desc = 'light';
    
    %     cond(2).eventdesc{2} = 'Off';
    cond(1).eventdesc{1} = 'On';
    %     cond(1).eventdesc{2} = 'Off';
    cond(1).color = [0.2 0.2 0.2];
    cond(1).desc = 'control';
    
    
    icond = 2;
    [TTLon, TTLoff, ~, TTLsignal] =   getTTLfromAnalog(fullfile(DIR,fileTTL),1);
    cond(icond).event{1} = TTLon;
    %     cond(icond).event{2} = TTLoff;
    
    % find first offset that follows an onset
    ind_firstOFF = find(min(TTLoff>min(TTLon)),1,'first');
    ind_firstON = find(max(TTLon)<TTLoff(ind_firstOFF));
    cond(icond).Duration = TTLoff(ind_firstOFF) - TTLon(ind_firstON);
    
    
    
    % cond(2).event{1} = cond(1).event{1} +300*30;
    % cond(2).event{1} = cond(2).event{1}(cond(2).event{1}<length(dp.video.cm.speed));
    fr_noStim = find(~TTLsignal);
    cond(1).event{1} =  fr_noStim(round(rand(size(TTLoff)).*length(fr_noStim)));
    
    dataParsed.cond = cond;
    dataParsed = addcm(dataParsed,fullfile(DIR,fileCM));
    dataParsed.TTL = double(TTLsignal);
    
    
    if ~isempty(frameNumRange)
        error('FIX the cond(icond).event fieelds')
        dataParsed.video.framesTimes = dataParsed.video.framesTimes(frameNumRange(1):frameNumRange(2));
        dataParsed.TTL = dataParsed.TTL(frameNumRange(1):frameNumRange(2));
        dataParsed.video.framesTimes = dataParsed.video.framesTimes(frameNumRange(1):frameNumRange(2));
        dataParsed.video.cm.xy = dataParsed.video.cm.xy (frameNumRange(1):frameNumRange(2),:);
        dataParsed.video.cm.speed = dataParsed.video.cm.speed(frameNumRange(1):frameNumRange(2));
        
        % FIX BELOW
        cond(icond).event{1}  = ismember(cond(icond).event{1},frameNumRange(1):frameNumRange(2));
    end
    saveBstruct(dataParsed);
end
%%
% condition speed
dp = dataParsed;
hz = dp.video.info.meanFrameRate ;

dp.video.cm.speed(dp.video.cm.speed>quantile(dp.video.cm.speed(:),.95)) = nan; %% really big velcities are not real

% %integral analysis
%
% getWOI
% subtract mean
%         [spd skipped] = getWOI(data,cond(icond).event{ievent},WOI);
%
% cumsum(nanmean(
%
%  sm = filtdata(dp.video.cm.speed,hz,.4,'low'); % cannot filter data with
%  NANs
sm = dp.video.cm.speed;

figure(100);clf;
subplot(1,2,1)
plot(dp.video.cm.xy(:,1),dp.video.cm.xy(:,2),'linewidth',0.1)
axis tight equal
[x y]  = ginput(4);  % include only selected ROI
in = inpolygon(dp.video.cm.xy(:,1),dp.video.cm.xy(:,2),x,y);
sm(~in) = nan;
dp.video.cm.speed = sm;

subplot(1,2,2);cla
plot([1:length(dp.video.cm.speed)]*1/hz,dp.video.cm.speed','k','linewidth',0.1); hold on
% plot([1:length(sm)]*1/hz,sm,'c','linewidth',0.1); hold on
yl = get(gca,'ylim')
plot(dp.cond(2).event{1}*1/hz,ones(size(dp.cond(2).event{1}))*yl(2)*1.05,'.b');

% hist(dp.video.cm.speed,1000)
% set(gca,'Yscale','log')

handles = speedFig(dp,dp.cond)
% %%
%
% figure(1);clf;
%
% % excludeInd = dp.video.cm.xy(:,1)<190 | dp.video.cm.xy(:,2)>500;
% % dp.video.cm.speed(excludeInd) = NaN;
% % % dp.video.cm.speed(abs( dp.video.cm.speed)<1) = nan;
% % dp.video.cm.speed(abs( dp.video.cm.speed)>30) = nan;
%

%% plot average speed with blocks

IStimI = diff(dp.cond(2).event{1});
indEndBlock= (find(IStimI > Interval * 2 * hz));
indBeginBlock = indEndBlock+1;
indBeginBlock = indBeginBlock(indBeginBlock <length(dp.cond(2).event{1}));

% if starts at the end of a block remove it
if indEndBlock(1) <indBeginBlock(1), indEndBlock = indEndBlock(2:end); end
% if Begin Block doesn't finish remove it.
if length(indBeginBlock) > length(indEndBlock), indBeginBlock = indBeginBlock(1:end-1); end

% control blocks between stimulation blocks
dp.cond(1).event{1} = [];
for iblock = 1:length(indBeginBlock)
    indEntireBlock = dp.cond(2).event{1} >= dp.cond(2).event{1}(indBeginBlock(iblock)) &...
        dp.cond(2).event{1} <= dp.cond(2).event{1}(indEndBlock(iblock));
    dp.cond(1).event{1} = [dp.cond(1).event{1} ...
        [dp.cond(2).event{1}(indEntireBlock)-dp.cond(2).event{1}(indBeginBlock(iblock))+(dp.cond(2).event{1}(indEndBlock(iblock))+Interval)]'];
end

vidlength = length(dp.video.cm.xy);
dp.cond(1).event{1} = dp.cond(1).event{1}(dp.cond(1).event{1} <vidlength);

if 0 % plotting to check
    figure
    clf;
    plot(dp.cond(2).event{1},1,'.k','markersize',1); hold on
    plot(dp.cond(2).event{1}(indBeginBlock),1,'.r');
    plot(dp.cond(2).event{1}(indEndBlock),1,'.b');
    
    plot(dp.cond(1).event{1},2,'-g','markersize',2); hold on
    ylim([-5 5])
end

% FiltWindow = round(.2*hz);
FiltWindow = 30;

data = dp.video.cm.speed;
datafilt =  medfilt1(data,FiltWindow);
if 0
    figure
    plot(data)
    plot(data,'linewidth',1)
    hold all
    plot(datafilt,'linewidth',1)
end
%%
figure
WOI = round(cond(1).WOI*hz);

for iblock = 1:length(indBeginBlock)
    icond = 2
    indThisBlock = dp.cond(icond).event{1} >= dp.cond(icond).event{1}(indBeginBlock(iblock)) &...
        dp.cond(icond).event{1} <= dp.cond(icond).event{1}(indEndBlock(iblock));
    % stimulated blocks
    thisBlockEvents = dp.cond(icond).event{1}(indThisBlock);
    
    
    spdfilt = getWOI(datafilt,thisBlockEvents,WOI);
    baseline  = mean(spdfilt(:,1:WOI),2);
    spdfilt= spdfilt-repmat( baseline,1,size(spdfilt,2));
    trialmean = mean(spdfilt(:,WOI(1):WOI(1)+WOI(2)),2);
    blockmean = mean(trialmean);
    
    line(thisBlockEvents/hz,trialmean,'linestyle','none','marker','.','markersize',8,'color',dp.cond(icond).color)
    line([thisBlockEvents(1) thisBlockEvents(end)]/hz,[1 1]*blockmean,'linewidth',2,'linestyle','-','color',dp.cond(icond).color)
    
    % control
    icond = 1;
    if (iblock +1)  < length(indBeginBlock)
        stop = dp.cond(2).event{1}(indBeginBlock(iblock+1));
    else
        stop = vidlength;
    end
    indThisBlock = dp.cond(icond).event{1} > dp.cond(2).event{1}(indEndBlock(iblock)) &...
        dp.cond(icond).event{1} < stop;
    
    thisBlockEvents = dp.cond(icond).event{1}(indThisBlock);
    
    
    spdfilt = getWOI(datafilt,thisBlockEvents,WOI);
    baseline  = mean(spdfilt(:,1:WOI),2);
    spdfilt= spdfilt-repmat( baseline,1,size(spdfilt,2));
    trialmean = mean(spdfilt(:,WOI(1):WOI(1)+WOI(2)),2);
    blockmean = mean(trialmean);
    
    line(thisBlockEvents/hz,trialmean,'linestyle','none','marker','.','markersize',8,'color',dp.cond(icond).color)
    line([thisBlockEvents(1) thisBlockEvents(end)]/hz,[1 1]*blockmean,'linewidth',2,'linestyle','-','color',dp.cond(icond).color)
    
end

xlabel('time (s)')
axis tight






