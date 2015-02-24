dp = loadBstruct()
%%
ndx = getIndex_dp(dp);
dp1 =  filtbdata_trial(dp,ndx.valid);
ind = find(dp1.Interval == 0.46);
dp2 = filtbdata_trial(dp1,ind);

% 
% ind = find(dp.Interval == 0.46);
% dp3 = filtbdata_trial(dp,ind);

secondStim_fr = dp2.video.secondStim_fr;
dp2.video.secondStim_fr;

nboot = 10;

it = 1;
for iboot = 1:nboot
    
    btrainSet =  rand(1,dp2.ntrials)<0.7;
    trainSet = find(btrainSet);
    testSet = find(~btrainSet);
    
    for itrial = 1:length(secondStim_fr)
        [r c] = find(dp2.video.extremesFrames==secondStim_fr(itrial));
        position(itrial,:) =     dp2.video.extremes(r,c,(1:2));
    end
    
    y = dp2.ChoiceCorrect';
    
    % this should be a trajectory position not xy position
    X = position;
    
    [~,~,glm] = glmfit(X(trainSet,:),y(trainSet),'binomial','constant','off');
    
    % dont' understand this
    logodds = X(testSet,:) * glm.beta;
    
    % this input below seems wrong
    [~,~,~,auclocal] = perfcurve(logical(y(testSet)),logodds,true);
    AUC(iboot,it) = auclocal;
    perf(iboot,it) = mean(y(trainSet));
end

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



