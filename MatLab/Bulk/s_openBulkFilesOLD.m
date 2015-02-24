
  %% for multiple channels, try to find a way of 
 
data.nChannels = 4;
data.sampleRate = 1000; %samples per second
data.dt = 1/data.sampleRate;

if isunix
    slash = '/';
else
    slash = '\';
end

brigdef = brigdefs();
bulkDatadir = brigdef.Dir.BulkData;

[FileName,PathName] = uigetfile(fullfile(bulkDatadir,slash,'*.*'),'Select Bonsai bulk file to analyze');

FullPath = [PathName FileName];


fid = fopen(FullPath,'r');


[data.raw,count]=fread(fid,'float64');
fclose(fid)

dp = daily_TAFC_Mice;
data.raw = data.raw';

greenInd = [1:data.nChannels:count];
redInd = [2:data.nChannels:count];
syncInd = [4:data.nChannels:count];
rewardSyncInd = [3:data.nChannels:count];

dataGreen = data.raw(greenInd);
dataRed = data.raw(redInd);
dataSync = data.raw(syncInd);
data.Sync = dataSync;
dataRewardSync = data.raw(rewardSyncInd);
data.rewardSync = dataRewardSync;


data.splitCh = [dataGreen ;dataRed];
%% Correction

%data = correctionGreen(data);


%%

h = figure
woi = 1:length(data.splitCh);  %20000;
wois = woi/data.sampleRate;

set(h, 'WindowStyle', 'docked');
 plot(wois,data.splitCh(1,woi),'g')
 hold on
 plot(wois,data.splitCh(2,woi),'r')
 plot(wois,data.rewardSync(:,woi),'k')
 plot(wois,data.Sync(:,woi),'b')
 
 xlabel('time in sec')
 ylabel('f')
 title('raw data both channels')
 
 %% for trial init
 
 syncThresh = median(data.Sync) + std(data.Sync)*15;
 
 syncPulse = data.Sync > syncThresh;
 
 syncPulse = find(syncPulse == 1);
 
 syncPulseDiff = diff(syncPulse);
 
 syncPulseTimesBulk = syncPulse(find(syncPulseDiff>1)+1);
 
 syncPulseTimesBulk = [syncPulse(1) syncPulseTimesBulk];
 
 %syncPulseTimesBulk = syncPulseTimesBulk(2:end);
 
 %% for reward 
 %WHEN WE HAVE REWARD SYNC PULSE
%  rewardSyncThresh = median(data.rewardSync) + std(data.rewardSync)*2;
%  
%  rewardSyncPulse = data.rewardSync > rewardSyncThresh;
%  
%  rewardSyncPulse = find(rewardSyncPulse == 1);
%  
%  rewardSyncPulseDiff = diff(rewardSyncPulse);
%  
%  rewardSyncPulseTimesBulk = rewardSyncPulse(find(rewardSyncPulseDiff>1)+1);
%  
 %rewardSyncPulseTimesBulk = [rewardSyncPulse(1) rewardSyncPulseTimesBulk]; 
 
 %rewardSyncPulseTimesBulk = rewardSyncPulseTimesBulk(3:end); %to remve the
% first one
 

%When we don't have reward sync pulse

rewardTime = dp.firstSidePokeTime-dp.TrialAvail;

%rewardTime = dp.TrialInit-dp.TrialAvail;

rewardSyncPulseTimesBulk = syncPulseTimesBulk + rewardTime;

dp.rewardTimesSync = rewardSyncPulseTimesBulk;

rewardSyncPulseTimesBulk = rewardSyncPulseTimesBulk(~isnan(rewardSyncPulseTimesBulk));
 
 %% sanity check sync
 
 h = figure;
 woi = 1:length(data.splitCh);  %20000;
 wois = woi/data.sampleRate;
 syncPulseTimesBulkPlot = syncPulseTimesBulk/data.sampleRate;
 rewardSyncPulseTimesBulkPlot = rewardSyncPulseTimesBulk/data.sampleRate;
 yThres = syncThresh*ones(1,length(syncPulseTimesBulkPlot));
 %rewardYThres = rewardSyncThresh*ones(1,length(rewardSyncPulseTimesBulkPlot));
 
 
 set(h, 'WindowStyle', 'docked');
 plot(wois,data.Sync(:,woi),'k')
 hold on
 plot(syncPulseTimesBulkPlot,yThres,'or')
 
%  plot(wois,data.rewardSync(:,woi),'b')
%  hold on
%  plot(rewardSyncPulseTimesBulkPlot,rewardYThres,'og')
%  
 xlabel('time in sec')
 ylabel('f')
 title('raw data both channels')

 
 
 
 %%
high = 1;
low = 0;
woi = 1:1000;
wois = woi/data.sampleRate;
data.lowCut = 5;



color = ['g'; 'r'];
h = figure 
set(h, 'WindowStyle', 'docked');
pos = 1;

data.lowFilt=[];

for i = 1:size(data.splitCh,1)
    
    data.lowFilt(i,:) = filterdata(data.splitCh(i,:),data.dt,data.lowCut,low);
    
   
    subplot(size(data.splitCh,1),2,pos)
    pos = pos+1;
     
    plot(wois,data.splitCh(i,woi),color(i))
    xlabel('time in sec')
    ylabel('f')
    if pos >2
    title('raw data red channel')
    else
    title('raw data green channel')
    end
    
    
    subplot(size(data.splitCh,1),2,pos)
    pos = pos+1;
    plot(wois,data.lowFilt(i,woi),color(i))
    xlabel('time in sec')
    ylabel('f')
    
    if pos>3
        title('low pass filtered data red channel')
    else
        title('low pass filtered data green channel')
    end
end

 %%
woi =1:size(data.splitCh,2);
wois = woi/data.sampleRate;


pos = 1;
h = figure ;
set(h, 'WindowStyle', 'docked');
 
for i = 1: size(data.splitCh,1)
    
    
ax(:,pos) = subplot(size(data.splitCh,1)*2,1,pos);
pos = pos+1;
plot(wois,data.splitCh(i,woi),color(i))
hold on
plot(rewardSyncPulseTimesBulkPlot,data.splitCh(i,rewardSyncPulseTimesBulk),'.k','markersize',7)
xlabel('time in sec')
ylabel('f')
if pos<3
title('raw data green channel')
else
title('raw data red channel')
end   
    
ax(:,pos) = subplot(size(data.splitCh,1)*2,1,pos);
pos = pos+1;
plot(wois,data.lowFilt(i,woi),color(i))
hold on
plot(rewardSyncPulseTimesBulkPlot,data.lowFilt(i,rewardSyncPulseTimesBulk),'.k','markersize',7)
xlabel('time in sec')
ylabel('f')

if pos<=3
title('low pass filtered data green channel')
else
title('low pass filtered data red channel')
end 


linkaxes(ax,'x')

end


%%

nRewards = length(rewardSyncPulseTimesBulk);

baselineWindow = 2; %in seconds
baselineWindow = baselineWindow*data.sampleRate; %in samples
baselineW = [];
baseline = [];
WOI = [2 6];
WOI = WOI*data.sampleRate;
xaxis = [-WOI(1):WOI(2)]';
deltaF = [];
deltaF_F = [];
deltaF_F_mean = [];
deltaF_F_median = [];

pos = 1;
h = figure ;
set(h, 'WindowStyle', 'docked');

for z = 1:2
    
    for i=1:nRewards
        
        baselineW(i,:,z) = data.lowFilt(z,(rewardSyncPulseTimesBulk(i)-baselineWindow:rewardSyncPulseTimesBulk(i)));
        baseline(i,z) = mean(baselineW(i,:,z));
        
        deltaF(i,:,z) = data.lowFilt(z,(rewardSyncPulseTimesBulk(i)-WOI(1):rewardSyncPulseTimesBulk(i)+WOI(2))) - baseline(i,z);
        
        deltaF_F(i,:,z) = deltaF(i,:,z)/baseline(i,z);
        
        
    end
    
    deltaF_F_mean(:,z) = mean(deltaF_F(:,:,z));
    deltaF_F_median(:,z) = median(deltaF_F(:,:,z));

    
end




% plot(deltaF_F_mean(:,1),'--g','linewidth',5)
% hold on
% plot(deltaF_F_mean(:,2),'--r','linewidth',5)

%deltaF_F_mean_sub = deltaF_F_mean(:,1)-deltaF_F_mean(:,2);

%plot(deltaF_F_mean_sub,'k','linewidth',5)


plot(deltaF_F_median(:,1),'--g','linewidth',2)
hold on
plot(deltaF_F_median(:,2),'--r','linewidth',2)


%% for protocol with dif reward magnitudes
colorsG = [];
colorsR = [];
colors = [];


param = 'RewardAmount';
%param = 'ChoiceLeft';

if isfield(dp,param)   
    
    rwdAmount = unique(dp.RewardAmount);
    
    %rwdAmount = unique(dp.ChoiceLeft);
    
    rwdAmount = rwdAmount(~isnan(rwdAmount));
    
    range = linspace(0.4,1,length(rwdAmount))';
    
    colorsG = zeros(length(rwdAmount),3);
    
    colorsG(:,2) = range;
    
    colorsR = zeros(length(rwdAmount),3);
    
    colorsR(:,1) = range;
    
    colors(:,:,1) = colorsG;
    
    colors(:,:,2) = colorsR;
    
    dpCorrect = filtbdata(dp,0,{'ChoiceCorrect', 1});
   
    
    
    pos = 1;
    h = figure ;
    set(h, 'WindowStyle', 'docked');
    
    %     trialNoRew = dpCorrect.absolute_trial(dpCorrect.RewardAmount==0);
    %     trialSmallRew = dpCorrect.absolute_trial(dpCorrect.RewardAmount==1);
    %
    for o = 1:length(rwdAmount)
        thisDp = filtbdata(dpCorrect,0,{param, rwdAmount(o)});
        
        
        baselineW = [];
        baseline = [];
        deltaF = [];
        deltaF_F = [];
        deltaF_F_mean = [];
        deltaF_F_median = deltaF_F_mean;
       
        
        
        for z = 1:2
            
            for i = 1:thisDp.ntrials
                thisTrial = thisDp.absolute_trial(i);
                
                
                baselineW(i,:,z) = data.lowFilt(z,(rewardSyncPulseTimesBulk(thisTrial)-baselineWindow:rewardSyncPulseTimesBulk(thisTrial)));
                baseline(i,z) = mean(baselineW(i,:,z));
                
                deltaF(i,:,z) = data.lowFilt(z,(rewardSyncPulseTimesBulk(thisTrial)-WOI(1):rewardSyncPulseTimesBulk(thisTrial)+WOI(2))) - baseline(i,z);
                
                deltaF_F(i,:,z) = deltaF(i,:,z)/baseline(i,z);
                
%                 plot(deltaF_F(i,:,z),'color',colors(o,:,z),'linewidth',2)
%                 hold on
%                 
%                 
            end
            
            deltaF_F_mean(:,z) = mean(deltaF_F(:,:,z));
            deltaF_F_median(:,z) = median(deltaF_F(:,:,z));
            
            
        end
        
        
        
        
        %
%         plot(deltaF_F_mean(:,1),'color',colorsG(o,:),'linewidth',2)
%         hold on
%         plot(deltaF_F_mean(:,2),'color',colorsR(o,:),'linewidth',2)
%         
%         deltaF_F_mean_sub = deltaF_F_mean(:,1)-deltaF_F_mean(:,2);
%         
        
subplot(2,1,1)   
        plot(xaxis,deltaF_F_median(:,1),'color',colorsG(o,:),'linewidth',2)
        hold on
        plot(xaxis,deltaF_F_median(:,2),'color',colorsR(o,:),'linewidth',2)
        axis square
        legend ([num2str(rwdAmount(1)) ' x reward gcamp'],...
                [num2str(rwdAmount(1)) 'x reward tdTomato'],...
                [num2str(rwdAmount(2)) 'x reward gcamp'],...
                [num2str(rwdAmount(2)) 'x reward tdTomato'],...
                '3x reward gcamp', '3x reward tdTomato','Location','NorthEastOutside')
        xlabel ('time in ms')
        ylabel ('delta f/f')

subplot(2,1,2)
        deltaF_F_median_sub = deltaF_F_median(:,1)-deltaF_F_median(:,2);
        plot(xaxis,deltaF_F_median_sub(:,1),'color',colorsG(o,:),'linewidth',2)
        hold on
        axis square
        legend ([num2str(rwdAmount(1)) ' x reward'],...
            [num2str(rwdAmount(2)) 'x reward'],'3x reward','Location','NorthEastOutside')
        xlabel ('time in ms')
        ylabel ('delta f/f')

    end
    
               
    
end



%% For licking analysis

% ntrials = length(thisDp.PokeTimes.LeftIn);
% 
% h = figure;
% set(h, 'WindowStyle', 'docked');
% for i = 1:ntrials
% 
% leftIn = thisDp.PokeTimes.LeftIn{i} - thisDp.TrialInit(i);
% leftIn = leftIn(leftIn>0);
% leftOut = thisDp.PokeTimes.LeftOut{i} - thisDp.TrialInit(i);
% leftOut = leftOut(leftOut>0);
% 
% 
% plot(leftIn,zeros(length(leftIn),1)+i,'.b')
% hold on
% plot(leftOut,zeros(length(leftOut),1)+i,'.k')
% 
% 
% end



