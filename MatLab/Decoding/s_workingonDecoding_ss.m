clear all
dp = loadBstruct('BII_TAFCv06_130227_SSAB_bstruct')
%% select subset of data to work with
ndx = getIndex_dp(dp);
dp1 =  filtbdata_trial(dp,ndx.valid);

ind = find(dp1.Interval == 0.46);
% dp2 = filtbdata_trial(dp1,ind);
dp2 = dp1;
%%

secondStim_fr = dp2.video.secondStim_fr;
% secondStim_fr = dp2.video.pokeIn_fr;
dp2.video.secondStim_fr;

bmask = ismember(secondStim_fr,dp2.video.extremesFrames); %  not sure exactly why but there are different numbers of trials in these two sets of frames
                                               % hack to avoid it
dp2 = filtbdata_trial(dp2,find(bmask));                                              
plot_trajectories(dp2);

btrainSet =  rand(1,dp2.ntrials)<0.7;
trainSet = find(btrainSet);
testSet = find(~btrainSet);
clear position
% try
for itrial = 1:length(secondStim_fr)
    [r c] = find(dp2.video.extremesFrames==secondStim_fr(itrial));
    position(itrial,:) =  dp2.video.extremes(r,c,(1:2));
end
% catch
%     display([num2str(itrial) ' of ' num2str(length(secondStim_fr)) ' not found']);
% end
%%
y = dp2.ChoiceCorrect';

% this should be a trajectory position not xy position
X = position;

[~,~,glm] = glmfit(X(trainSet,:),y(trainSet),'binomial','constant','off');


logodds = X(testSet,:) * glm.beta; %  by definition see glm documentation
[logodds'; y(testSet)']

% create a measure of correctness
C = logodds>0
mC = sum(logodds>0 & y(testSet)==1)  /sum(y(testSet)==1);
mI= sum(logodds <=0 & y(testSet)==0)  /sum(y(testSet)==0);

figure(999);clf;
subplot(1,2,1)
hl = line(y(testSet)',logodds','marker','.','color','k','linestyle','none')
%  xlim([-0.1 1])
%  ylim([-1 1])
axis tight
xlabel('Real');ylabel('Predicted')
subplot(1,2,2)
hl = line(y(testSet)',logodds>0,'marker','.','color','k','linestyle','none')
title(['C: ' num2str(mC) ' I: ' num2str(mI)] )


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



