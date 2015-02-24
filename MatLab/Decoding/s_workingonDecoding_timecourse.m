clear all
dp = loadBstruct('BII_TAFCv07_box3_130325_SSAB_bstruct');
% dp = loadBstruct('BII_TAFCv06_130227_SSAB_bstruct');
%%
frame_rate = dp.video.info.meanFrameRate; 
INTV = 0.54;
FILTINTV = INTV;
POSIND = round(INTV*dp.Scaling(end)/1000*frame_rate);

%% select subset of data to work with
ndx = getIndex_dp(dp);
dp1 =  filtbdata_trial(dp,ndx.valid);

ind = find(dp1.Interval == FILTINTV);
dp2 = filtbdata_trial(dp1,ind);
% dp2 = dp1;
testSet = 1:dp2.ntrials;

% this should be a trajectory position not xy position
frs = [[1:40:POSIND] POSIND];


% plot_trajectories(dp2,frs);
position =  dp2.video.extremes(:,frs,(3:4));
if 0 % define roi for center poke to accept 
    figure;
    plot(squeeze(dp2.video.extremes(:,:,(4)))',squeeze(dp2.video.extremes(:,:,(3)))','b');hold on;
    plot(position(:,1,2),position(:,1,1),'k.')
     roi = ginput(4);
end
bmask = inpolygon(position(:,1,2),position(:,1,1),roi(:,1),roi(:,2));
% dp2 =  filtbdata_trial(dp,find(bmask));
% plot_trajectories(dp2,frs);

    plot(squeeze(dp2.video.extremes(bmask,:,(4)))',squeeze(dp2.video.extremes(bmask,:,(3)))','r');hold on;
    plot(position(bmask,1,2),position(bmask,1,1),'c.')
     roi = ginput(4);


%%
btrainSet =  rand(1,dp2.ntrials)<0.7;
trainSet = find(btrainSet);
testSet = find(~btrainSet);

y = dp2.ChoiceCorrect';

clear position mC mI T 



data = []; slo = []; sy = []; sX = [];
for itime = 1:length(frs)
    % try
    
    X = squeeze(position(:,itime,:));
    
    [~,~,glm] = glmfit(X(trainSet,:),y(trainSet),'binomial','constant','off');
    
    
    logodds = X(testSet,:) * glm.beta; %  by definition see glm documentation
    
    fit(itime) = glm;
    slo = [slo logodds];
    sy = [sy y(testSet)];
    sX = [sX X ] ;
    
    % create a measure of correctness
    C = logodds>0;
    mC(itime) = sum(logodds>0 & y(testSet)==1)  /sum(y(testSet)==1);
    mI(itime)= sum(logodds <=0 & y(testSet)==0)  /sum(y(testSet)==0);
    T(itime) = (sum(logodds>0 & y(testSet)==1)+ sum(logodds <=0 & y(testSet)==0)) /length(testSet);
end




figure(999);clf;
plot(frs*1/frame_rate,T); hold all;
plot(frs*1/frame_rate,mC)
plot(frs*1/frame_rate,mI)
sleg(1) = {'T'};
sleg(2) = {'C'};
sleg(3) = {'I'};
legend(sleg)
%%
hl = line(y(testSet)',logodds','marker','o','color','k','linestyle','none');
axis tight
xlabel('Real');ylabel('Predicted')
% subplot(1,2,2)
% hl = line(y(testSet)',logodds>0,'marker','.','color','k','linestyle','none')
title(['ntrials:' num2str(dp2.ntrials) ' C: ' num2str(mC) ' I: ' num2str(mI)] )


%%
% how do we validate it is doing a good job?

% this input below seems wrong
[~,~,~,auclocal] = perfcurve(logical(y(testSet)),logodds,true);
AUC(iboot,it) = auclocal;
perf(iboot,it) = mean(y(trainSet));
% end

figure('name','Time course of choice predictability'),
plot(tsSet,median(AUC),'linewidth',3)
set(gca,'xtick',tsSet,'xticklabel',tsSet*1000/120,'ytick',[0.5 .75 1],'fontsize',14,'tickdir','out','box','off')
hold on
% patch([tsSet, fliplr(tsSet)],[median(AUC)-std(AUC) fliplr(median(AUC)+std(AUC))],'b','facealpha',0.1,'edgealpha',0);
patch([tsSet, fliplr(tsSet)],[prctile(AUC,25) fliplr(prctile(AUC,75))],'b','facealpha',0.1,'edgealpha',0);

xlabel 'Time from interval onset (ms)'; ylabel aucROC
axis([0 max(tsSet) .45 1])

choices = dp2.ch
choice and
tracjor for
stimulus X



