

  %% for multiple channels, try to find a way of 
clear all; 
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


% data.raw = data.raw(1:length(data.raw)/2);
% count = count/2;

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

alignCond = 'reward';
%alignCond = 'trialInit';
param = 'RewardAmount';
%param = 'ChoiceLeft';

WOI = [4 7];

%WOI = [2 2];

 %% Correction on raw
% 
% data = correctionGreen(data);
% 
% data.splitCh = [data.corrGreen ;dataRed];
% 

%%

hf = figure;
set(hf, 'WindowStyle', 'docked');
ax1 = subplot(4,2,[5 7]);
woi = 1:length(data.splitCh);  %20000;
wois = woi/data.sampleRate;


 plot(wois,data.splitCh(1,woi),'g')
 hold on
 plot(wois,data.splitCh(2,woi),'r')
 plot(wois,data.rewardSync(:,woi),'k')
 plot(wois,data.Sync(:,woi),'b')
 
 xlabel('time in sec','FontSize',13)
 ylabel('f','FontSize',13)
 title('raw data both channels','FontSize',13)
 axis tight
 axis square
 
 set(gca,'TickDir','out','FontSize',13,'LineWidth',2)
 
 
 
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
if strcmp(alignCond, 'reward');
    if isfield(dp,'RewardTime')
        rewardTime = dp.RewardTime - dp.TrialAvail;
    else
        rewardTime = dp.firstSidePokeTime-dp.TrialAvail;
    end

elseif strcmp(alignCond, 'trialInit');
rewardTime = dp.TrialInit-dp.TrialAvail;

else
    
rewardTime = dp.firstSidePokeTime-dp.TrialAvail;
alignCond = 'reward';  

end


rewardSyncPulseTimesBulk = syncPulseTimesBulk + rewardTime(1:length(syncPulseTimesBulk));

dp.rewardTimesSync = rewardSyncPulseTimesBulk;

rewardSyncPulseTimesBulk = rewardSyncPulseTimesBulk(~isnan(rewardSyncPulseTimesBulk));
 
 %% sanity check sync
%  
%  h = figure;
%  woi = 1:length(data.splitCh);  %20000;
%  wois = woi/data.sampleRate;
%  syncPulseTimesBulkPlot = syncPulseTimesBulk/data.sampleRate;
%  rewardSyncPulseTimesBulkPlot = rewardSyncPulseTimesBulk/data.sampleRate;
%  yThres = syncThresh*ones(1,length(syncPulseTimesBulkPlot));
%  %rewardYThres = rewardSyncThresh*ones(1,length(rewardSyncPulseTimesBulkPlot));
%  
%  
%  set(h, 'WindowStyle', 'docked');
%  plot(wois,data.Sync(:,woi),'k')
%  hold on
%  plot(syncPulseTimesBulkPlot,yThres,'or')
%  
% %  plot(wois,data.rewardSync(:,woi),'b')
% %  hold on
% %  plot(rewardSyncPulseTimesBulkPlot,rewardYThres,'og')
% %  
%  xlabel('time in sec')
%  ylabel('f')
%  title('raw data both channels')

 
 
 
 %% low pass filtering
high = 1;
low = 0;
data.lowCut = 5;

data.lowFilt=[];

for i = 1:size(data.splitCh,1)
    
    data.lowFilt(i,:) = filterdata(data.splitCh(i,:),data.dt,data.lowCut,low);
    
end


%% for protocol with dif reward magnitudes

nRewards = length(rewardSyncPulseTimesBulk);

baselineWindow = [5 3]; %in seconds
baselineWindow = baselineWindow*data.sampleRate; %in samples
baselineW = [];
baseline = [];
%WOI = [4 7];
WOI = WOI*data.sampleRate;
xaxis = [-WOI(1):WOI(2)]';
deltaF = [];
deltaF_F = [];
deltaF_F_mean = [];
deltaF_F_median = [];
colorsG = [];
colorsR = [];
colors = [];


if isfield(dp,param)   
    
    rwdAmount = unique(dp.(param));
    
    rwdAmount = rwdAmount(~isnan(rwdAmount));
    
    range = linspace(0.4,1,length(rwdAmount))';
    
    colorsG = zeros(length(rwdAmount),3);
    
    colorsG(:,2) = range;
    
    colorsR = zeros(length(rwdAmount),3);
    
    colorsR(:,1) = range;
    
    colors(:,:,1) = colorsG;
    
    colors(:,:,2) = colorsR;
    
    dpCorrect = filtbdata(dp,0,{'ChoiceCorrect', 1});
   
       
    figure(hf);
    
%     hf = figure ;
%     set(hf, 'WindowStyle', 'docked');
%     
    %     trialNoRew = dpCorrect.absolute_trial(dpCorrect.RewardAmount==0);
    %     trialSmallRew = dpCorrect.absolute_trial(dpCorrect.RewardAmount==1);
    %
     deltaF_F_g_all = [];
     deltaF_F_r_all = [];
     
    for o = 1:length(rwdAmount)
        thisDp = filtbdata(dpCorrect,0,{param, rwdAmount(o)});
        
        
        baselineW = [];
        baseline = [];
        deltaF = [];
        deltaF_F = [];
        deltaF_F_mean = [];
        deltaF_F_sem = [];
        
        deltaF_F_median = deltaF_F_mean;
       
        
        
        for z = 1:2
            
            for i = 1:thisDp.ntrials
                thisTrial = thisDp.absolute_trial(i);
                
                
                baselineW(i,:,z) = data.lowFilt(z,(rewardSyncPulseTimesBulk(thisTrial)-baselineWindow(1):rewardSyncPulseTimesBulk(thisTrial)-baselineWindow(2)));
                baseline(i,z) = mean(baselineW(i,:,z));
                
                deltaF(i,:,z) = data.lowFilt(z,(rewardSyncPulseTimesBulk(thisTrial)-WOI(1):rewardSyncPulseTimesBulk(thisTrial)+WOI(2))) - baseline(i,z);
                
                deltaF_F(i,:,z) = deltaF(i,:,z)/baseline(i,z);
%                 
%                                  plot(deltaF_F(i,:,z),'color',colors(o,:,z),'linewidth',2)
%                                 hold on
% %                 
                %
            end
            
            
            if z == 1
                deltaF_F_g_all= [deltaF_F_g_all(:,:); deltaF_F(:,:,z)];
                
            elseif z==2
                deltaF_F_r_all = [deltaF_F_r_all(:,:); deltaF_F(:,:,z)];
                
            end
            
            
            deltaF_F_mean(:,z) = mean(deltaF_F(:,:,z));
            deltaF_F_median(:,z) = median(deltaF_F(:,:,z));
            deltaF_F_error(:,z) = sem(deltaF_F(:,:,z));
            
            
        end
        
        
        
        
        
%         plot(deltaF_F_mean(:,1),'color',colorsG(o,:),'linewidth',2)
%         hold on
%         plot(deltaF_F_mean(:,2),'color',colorsR(o,:),'linewidth',2)
%         
        deltaF_F_mean_sub = deltaF_F_mean(:,1)-deltaF_F_mean(:,2);
        
        
ax2 = subplot(4,2,[2 4]); 
% 
        plot(xaxis,deltaF_F_mean(:,1),'color',colorsG(o,:),'linewidth',2)
        hold on
        fill([xaxis; flipud(xaxis)],[deltaF_F_mean(:,1)+deltaF_F_error(:,1); flipud(deltaF_F_mean(:,1)-deltaF_F_error(:,1))],colorsG(o,:),'FaceAlpha', 0.2,'linestyle','none');
        plot(xaxis,deltaF_F_mean(:,2),'color',colorsR(o,:),'linewidth',2)
        fill([xaxis; flipud(xaxis)],[deltaF_F_mean(:,2)+deltaF_F_error(:,2); flipud(deltaF_F_mean(:,2)-deltaF_F_error(:,2))],colorsR(o,:),'FaceAlpha', 0.2,'linestyle','none');
       
        axis tight
        axis square
%         legend ([num2str(rwdAmount(1)) ' x ' param ' gcamp'],...
%                 [num2str(rwdAmount(1)) 'x ' param ' tdTomato'],...
%                 [num2str(rwdAmount(2)) 'x ' param ' gcamp'],...
%                 [num2str(rwdAmount(2)) 'x ' param ' tdTomato'],...
%                 '3x reward gcamp', '3x reward tdTomato','Location','NorthEastOutside')
        




        xlabel ('time in ms','FontSize',13)
        ylabel ('delta f/f','FontSize',13)
        title(['DeltaF/F on both channels aligned on ' alignCond ' and split by ' param],'FontSize',13)
        set(gca,'TickDir','out','FontSize',13,'LineWidth',2)
        yRange = ylim;
        plot([0 0],yRange,'--k')
        plot([-2000 -2000],yRange,'--k')


    end
    
               
    
end



%% Correction on delta f/f
deltaF_F_g = [];
deltaF_F_r = [];

rc = size(deltaF_F_g_all);

nElements = rc(1)*rc(2);

deltaF_F_g = reshape(permute(deltaF_F_g_all(:,:),[2 1]),1,nElements);


deltaF_F_r = reshape(permute(deltaF_F_r_all(:,:),[2 1]),1,nElements);

ax3 = subplot(4,2,[1 3]); 
data = correctionGreen(data,deltaF_F_g,deltaF_F_r,hf);

corrGreenAll = reshape(data.corrGreen,rc(2),rc(1))';

set(gca,'TickDir','out','FontSize',13,'LineWidth',2)



%%

figure(hf)
axCorr = subplot(4,2,[6 8]); 
firstTrial = 0;
trials = [];
medianCorrGreen = [];
meanCorrGreen = [];


for o = 1:length(rwdAmount)
        thisDp = filtbdata(dpCorrect,0,{param, rwdAmount(o)});
        nTrialsNow(o) = thisDp.ntrials;
        lastTrial = firstTrial+nTrialsNow(o);
        trials(o,:) = [firstTrial+1 lastTrial];
        firstTrial = lastTrial; 
        corrGreen = corrGreenAll(trials(o,1):trials(o,2),:);
        medianCorrGreen(:,o) = median(corrGreen)';
        meanCorrGreen(:,o) = mean(corrGreen)';
        errorCorrGreen(:,o) = sem(corrGreen)';
        
        plot(xaxis,meanCorrGreen(:,o),'color',colorsG(o,:),'linewidth',2)
        hold on
        fill([xaxis; flipud(xaxis)],[meanCorrGreen(:,o)+ errorCorrGreen(:,o); flipud(meanCorrGreen(:,o)- errorCorrGreen(:,o))],colorsG(o,:),'FaceAlpha', 0.2,'linestyle','none');

        axis tight
        axis square
%         legend ([num2str(rwdAmount(1)) ' x reward gcamp'],...
%                 [num2str(rwdAmount(2)) 'x reward gcamp'],...
%                 'Location','NorthEastOutside')
        xlabel ('time in ms','FontSize',13)
        ylabel ('delta f/f','FontSize',13)
        title('Corrected Signal using fit parameters','FontSize',13)
        
end  

plotAnn([dp.FileName 'alignedOn_' alignCond])

set(gca,'TickDir','out','FontSize',13,'LineWidth',2)
plot([0 0],yRange,'--k')
plot([-2000 -2000],yRange,'--k')


%figDir = fullfile(bulkDatadir,'SummaryFigures',[dp.FileName '_alignedOn_' alignCond '.pdf']);
figDir = fullfile(bulkDatadir,'SummaryFigures',[dp.FileName,'.pdf']);
save2pdf(figDir)
% 
% for i = 1:rc(1)
%    
%     
% %     plot(corrGreen(i,:));
% %     hold on
% %     
% end

%data.splitCh = [data.corrGreen ;dataRed];




%% For reaction time analysis

% hfrt = figure;
% set(hfrt, 'WindowStyle', 'docked');
% 
% axRtHist = subplot(1,2,1)
% 
% for o = 1:length(rwdAmount)
%     
%     thisDp = filtbdata(dpCorrect,0,{param, rwdAmount(o)});
%     reactionTimes{:,o} = thisDp.firstSidePokeTime - thisDp.TrialInit;
%     [hstNow, XoutNow] = hist(reactionTimes{o},300);
%     hst{:,o} = hstNow; 
%     Xout{:,o} = XoutNow;
%     axRtHist = subplot(1,2,1)
%     stairs(Xout{o},hst{o},'color',colorsG(o,:))
%     hold on
%     
%     nTrials(o) = size(reactionTimes{o},2);
%     
%     stat(1,o) = median(reactionTimes{o});
%     stat(2,o) = std(reactionTimes{o});
%     
%     
%     
%     clear hstNow XoutNow;
%     axis tight
%     axis square
%     title('Reaction time distributions')
% 
%     %legend(hfrt,'
%     
% end
% 
% axRtBox = subplot(1,2,2)
% 
% reactionTimesBox = nan(max(nTrials),length(rwdAmount));
% 
% for o = 1:length(rwdAmount)
% 
%     reactionTimesBox(1:nTrials(o),o) = reactionTimes{o}';
% 
% end
% 
% boxplot(reactionTimesBox)
%    
% axis tight
% axis square
% title('Reaction time median and interquartile range')





%% For licking analysis
% 
% 
% 
% hfl = figure;
% set(hfl, 'WindowStyle', 'docked');
% 
% 
% for o = 1:length(rwdAmount)
%     
%     haxl(o) = subplot(1,length(rwdAmount),o);
%     thisDp = filtbdata(dpCorrect,0,{param, rwdAmount(o)});
%     ntrials = length(thisDp.PokeTimes.LeftIn);
%     
%     for i = 1:ntrials
%         
%         leftIn = thisDp.PokeTimes.LeftIn{i} - thisDp.TrialInit(i);
%         leftIn = leftIn(leftIn>0&leftIn<WOI(2));
%         leftOut = thisDp.PokeTimes.LeftOut{i} - thisDp.TrialInit(i);
%         leftOut = leftOut(leftOut>0&leftOut<WOI(2));
%         
%         rightIn = thisDp.PokeTimes.RightIn{i} - thisDp.TrialInit(i);
%         rightIn = rightIn(rightIn>0&rightIn<WOI(2));
%         rightOut = thisDp.PokeTimes.RightOut{i} - thisDp.TrialInit(i);
%         rightOut = rightOut(rightOut>0&rightOut<WOI(2));
%         
%         
%         
%         plot(leftIn,zeros(length(leftIn),1)+i,'.b','markersize',10)
%         hold on
%         plot(leftOut,zeros(length(leftOut),1)+i,'.k','markersize',10)
%         hold on
%         plot(rightIn,zeros(length(rightIn),1)+i,'*r','markersize',10)
%         hold on
%         plot(rightOut,zeros(length(rightOut),1)+i,'*k','markersize',10)
%         
%         
%         
%     end
%     
% end



