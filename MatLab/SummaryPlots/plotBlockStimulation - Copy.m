function dpArray =  plotBlockStimulation(varargin)
% function dpArray =  plotBlockStimulation(varargin)
%                                      dpA, conCell,BlockLength,brandomizeStimulation
r = brigdefs();
bsave = 1;
bconcat = 1; % of set to 0 will do the analysis for each dpArray independently
if length(varargin)<3
    warning('BlockLength not specified set to 20')
    BlockLength = 20; % this is for the matching task % 50 for 1481
else
    BlockLength = varargin{3};
end
            
trialsBefAftBlock = ceil([1 1]* 1.1*BlockLength);
bCumAnalysis = 0;
% bplotDiff
brandomizeStimulation = 0;
if length(varargin)>3
    brandomizeStimulation = varargin{4};
end

dpArray = dpArrayInputHelper(varargin{1:min(2,length(varargin))});

if bconcat
    dpC =concdp(dpArray);
else
    dpC = dpArray;
end
% this attempts at making an estimate of the change
if brandomizeStimulation
    for i = 1:20
        dpC(i) = dpC(1);
        % randomize the stimulation as a control
        dpC(i).stimulationOnCond = circshift(dpC(i).stimulationOnCond,[1 round(rand(1)*500)]);
    end
    sAnnot = [sAnnot '_RandStim'];
end


%%
for idpC = 1:length(dpC)
    if bconcat
        sAnnot =  dpArray(1).collectiveDescriptor ;
    else
        sAnnot =  [dpC(idpC).Animal ' ' dpC(idpC).Date]  ;
    end
    savefiledesc = [ sAnnot '_Timecourse_BlockStimulation' ];

    
    % Pick fields to BlockTriggered Average
    if  strcmpi(dpC(idpC).Protocol,'tafc')
        fld = {'ChoiceMiss','ChoiceCorrect','Premature','ChoiceLeft','ReactionTime','timeToTrialInit','stimulationOnCond'};
    elseif strcmpi(dpC(idpC).Protocol,'matching')
        fld = {'ChoiceLeft','ChoiceMiss','stimulationOnCond','ProbRwdLeft'};
        dpC(idpC).ProbRwdLeft = dpC(idpC).ProbRwdLeft/100;
        if ~isfield(dpC(idpC),'beginStimCondBlock' | idpC >1) % forgot to put this field into the arduino code,
            dpC(idpC).beginStimCondBlock = [];
            dpC(idpC) = addbeginStimCondBlockHelper(dpC(idpC),BlockLength);
        end
    else
        error('unknown protocol')
    end
    
    % Get stimulated blocks
    % note might be missing first block of each session)
    startBlock= find(dpC(idpC).beginStimCondBlock==1);
    bstartstimBlock = zeros(size(startBlock));
    bLeftProbHigh= zeros(size(startBlock));
    for iblock = 1:length(startBlock)
        if iblock< length(startBlock)
            endtrial = startBlock(iblock+1);
        else
            endtrial = dpC(idpC).ntrials;
        end
        if any(dpC(idpC).stimulationOnCond(startBlock(iblock):endtrial-1))
            bstartstimBlock(iblock) = 1;
        end
        if mean(dpC(idpC).stimulationOnCond(startBlock(iblock):endtrial-1))> 0.5
            bLeftProbHigh(iblock) = 1;
        end
    end
    
%     Average property in block
   trialRange = [startBlock(1:end); [startBlock(2:end) endtrial]]';
   
   dpC(idpC).trialAvg = getAvgInTrialRange(dpC(idpC),trialRange);
    dpC(idpC).trialAvg.bstartstimBlock = bstartstimBlock;
    dpC(idpC).trialAvg.bLeftProbHigh = bLeftProbHigh;
 
    % calculate block triggered average
    [dpWOI skipped] = getTrialWOI(dpC(idpC),startBlock(find(bstartstimBlock)),trialsBefAftBlock);
    for ifld = 1:length(fld)
        valON(ifld,idpC) = {structfld2mat(dpWOI,fld{ifld})};
        avgON(ifld,:,idpC) = nanmean(valON{ifld,idpC});
    end
    
    [dpWOI skipped]= getTrialWOI(dpC(idpC),startBlock(find(~bstartstimBlock)),trialsBefAftBlock);
    if ~isempty(dpWOI)
        for ifld = 1:length(fld)
        valOFF(ifld,idpC) = {structfld2mat(dpWOI,fld{ifld})};
        avgOFF(ifld,:,idpC) = nanmean(valOFF{ifld,idpC});
        end
    end
    
    % calculate probability for eac stimulted block and each unstimulted
    % block
    
    
    
end
%% 
perON = [];
perOFF = [];
if brandomizeStimulation % find average and 95 percentile of shuffle
%     valON{ifld}= mean(valON,3);
%     valON = valON(1);
%     valOFF{ifld}= mean(valOFF);
%     valOFF = valOFF(1);
%     temp = mean(avgON,3);
    perON= prctile(avgON,[5 95],3);
    avgON = squeeze(mean(avgON,3));
    perOFF= prctile(avgOFF,[5 95],3);
    avgOFF = squeeze(mean(avgOFF,3));    
end

if ~bconcat % make an average across sessions
    perON= repmat(squeeze(std(avgON,0,3))/sqrt(size(squeeze(mean(avgON,3)),3)),[1 1 2]); % SEM
    avgON = squeeze(mean(avgON,3));
    perOFF= repmat(squeeze(std(avgOFF,0,3))/sqrt(size(squeeze(mean(avgOFF,3)),3)),[1 1 2]); % SEM
    avgOFF = squeeze(mean(avgOFF,3));
end
%% plotting
nr = 2;
nc = 2;

mycolor = colormap(jet(length(fld)));
hf = figure('Position', [360    80   782   842]);clf;
set(hf,'Name',savefiledesc,'NumberTitle','off')

% plot the parameters when Block stimulated vs Unstimulated
subplot(nr,nc,[2]);cla;
fld = {'ProbRwdLeft','timeToTrialInit','ChoiceMiss'};
fld = {'ProbRwdLeft','ChoiceMiss'};
fld = fld(ismember(fld,fieldnames(dpC)));
scale = [1 1/20000 1];
myColor = {'k','b','c'}; clear sleg;
for ifld = 1 :length(fld)
    for idp = 1:length(dpC)
        bstartstimBlock = dpC(idp).trialAvg.bstartstimBlock ;
        stimBlock =find(bstartstimBlock);
        unstimBlock =find(~bstartstimBlock);
        nblockToPlot = min(length(stimBlock),length(unstimBlock));
        h(ifld) = line(mean(dpC(idp).trialAvg.(fld{ifld})(unstimBlock(1:nblockToPlot)))*scale(ifld),...
            mean(dpC(idp).trialAvg.(fld{ifld})(stimBlock(1:nblockToPlot)))*scale(ifld),...
            'Marker','.','linestyle','none','color',myColor{ifld});
    end
            sleg{ifld} = fld{ifld};

end
legend(h,sleg,'Location','Best','Fontsize',5)
xlabel(' Control P(Left)')
ylabel(' Stim P(Left)')
axis square
yl = ylim();
line([0 yl(end)],[0 yl(end)],'color','k')


% % plot the parameters when P high is LEFT vs RIGHT
% subplot(nr,nc,3);cla; 
% fld = {'ProbRwdLeft','timeToTrialInit','ChoiceMiss'};
% scale = [1 1/20000 1];
% myColor = {'k','b','c'}; clear sleg;
% for ifld = 1 :length(fld)
%     for idp = 1:length(dpC)
%         bLeftProbHigh = dpC(idp).trialAvg.bLeftProbHigh ;
%         leftBlock =find(bLeftProbHigh);
%        rightBlock =find(~bLeftProbHigh);
%         nblockToPlot = min(length(rightBlock),length(leftBlock));
%         h(ifld) = line(mean(dpC(idp).trialAvg.(fld{ifld})(rightBlock(1:nblockToPlot)))*scale(ifld),...
%             mean(dpC(idp).trialAvg.(fld{ifld})(leftBlock(1:nblockToPlot)))*scale(ifld),...
%             'Marker','.','linestyle','none','color',myColor{ifld});
%     end
%             sleg{ifld} = fld{ifld};
% 
% end
% xlabel('Right P High')
% ylabel('Left P High')
% axis square
% yl = ylim();
% line([0 yl(end)],[0 yl(end)],'color','k')

subplot(nr,nc,1);cla;
for idp = 1:length(dpC)
    bstartstimBlock = dpC(idp).trialAvg.bstartstimBlock ;
    stimBlock =find(bstartstimBlock);
    unstimBlock =find(~bstartstimBlock);
    nblockToPlot = min(length(stimBlock),length(unstimBlock));
    plot(mean(dpC(idp).trialAvg.ChoiceLeft(unstimBlock(1:nblockToPlot))),mean(dpC(idp).trialAvg.ChoiceLeft(stimBlock(1:nblockToPlot))),'.');hold all;
    sleg{idp} = dpC(idp).Date;
end
title('Per Session')
% legend(sleg,'Location','EastOutside','FontSize',5)
xlabel('P(Left) Control Block ')
ylabel('P(Left) Stimulation Block')
axis square
yl = ylim();
line([0 yl(end)],[0 yl(end)],'color','k')



%%

% plot block triggered average of parameter
if 1
    % hAx(1) = subplot(nr,nc,[4 5]);
    hAx(2) = subplot(nr,nc,[3 4]);
    fld = {'ChoiceLeft','ChoiceMiss','stimulationOnCond','ProbRwdLeft'};
    fld = fld(ismember(fld,fieldnames(dpC)));

    
    plot_helper(hAx(2),avgON,perON,fld)
    setTitle(hAx(2),'StimBlock ON')
    % hAx(3) = subplot(nr,nc,6);
    % hAx(4) = subplot(nr,nc,7);
    % plot_helper(hAx([3,4]),avgOFF,perOFF)
    % setTitle(hAx(4),'StimBlock OFF')
    
end

plotAnn(sAnnot);

if bsave
    orient tall
    patht = fullfile(r.Dir.SummaryFig,'BlockTriggered');
    parentfolder(patht,1)
    saveas(hf, fullfile(patht,[savefiledesc '.pdf']));
end
%%
function plot_helper(hAx,avg,per,fld)
hl = []; hp = [];
for ifld = 1:length(fld)
    kernel_length = 10;
    kernel = ones(1,kernel_length)/kernel_length;
    
    %     padded = [nan(size(kernel)),nanmean(val{ifld}),nan(size(kernel))];
    smoothedavg= conv(avg(ifld,:),kernel,'valid');
    xtrials = [1:size(smoothedavg,2)]-size(smoothedavg,2)/2;
     if ~isempty(per)
            smoothedper(1,:)= conv(squeeze(per(ifld,:,1)),kernel,'valid')';
            smoothedper(2,:)= conv(squeeze(per(ifld,:,2)),kernel,'valid')';
     end
    if 0 % nonbaseline subtracted
        if ~isempty(per)
             [hl(end+1) hp(end+1)] = errorPatch(xtrials',smoothedavg', smoothedper(1,:)', smoothedper(2,:)',hAx(1));
            setColor([hl(end) hp(end)],mycolor(ifld,:))
            %         [hl(end+1)] = errorbar(hAx(1),xtrials',smoothedavg', smoothedper(1,:)', smoothedper(2,:)','color',mycolor(ifld,:)); hold all;
        else
            hl(end+1) = line(xtrials,smoothedavg,'color',mycolor(ifld,:),'Parent',hAx(1));
        end
    end
    if bCumAnalysis
        %     integral( x -<x>)
        temp = val{ifld};
        temp = temp- repmat(nanmean(temp')',1,size(temp,2));
        cum_avg = cumsum(nansum(temp));
        cum_avg = cum_avg/range(cum_avg);
        xtrials = [1:length(cum_avg)]-length(cum_avg)/2;
        if isempty(strfind(fld{ifld},'stimulationOnCond'));
            line(xtrials,cum_avg,'color',mycolor(ifld,:),'Parent',hAx(2));
        end
    else
        % plot baseline subtracted
        b = median(smoothedavg);
        if 0 %~isempty(per)
            [hl(end+1) hp(end+1)] = errorPatch(xtrials',smoothedavg'-b, smoothedper(1,:)'-b, smoothedper(2,:)'-b,hAx(end));
            %             errorbar(hAx(2),xtrials',smoothedavg'-b, smoothedper(1,:)'-b, smoothedper(2,:)'-b),'color',mycolor(ifld,:); hold all;
            setColor([hl(end) hp(end)],mycolor(ifld,:))
        else
            
             hl(end+1) = line(xtrials,smoothedavg-b,'color',mycolor(ifld,:),'Parent',hAx(end));
            
        end
    end
    
end
% line([0 0], get(hAx(1),'ylim'),'color','k','linewidth',1,'Parent',hAx(1));
line([0 0], get(hAx(end),'ylim'),'color','k','linewidth',1,'Parent',hAx(end));

hleg = legend(hl,fld,'Fontsize',7,'location','best');
legend boxoff;
setXLabel(hAx(end),'trial')
axis(hAx,'tight')
% set(hAx([1]),'ylim',[0 1])
% set(hAx([1]),'YTick',[0 1])
set(hAx,'TickDir','out')
end
end

function dp = addbeginStimCondBlockHelper(dp,BlockLength)
% define a block by there being a
% "bunch of no stimulation
% followed by stimulation
dp.beginStimCondBlock = zeros(size(dp.stimulationOnCond));
stimOn = dp.stimulationOnCond;
patterns(1,:) = [zeros(1,BlockLength) 1]; %
indFirstblock = find(stimOn,1,'first');
dp.beginStimCondBlock(indFirstblock) = 1;
             patterns(2,:) = [1 zeros(1,BlockLength)]; %
nback = length(patterns) ;
for itrial = indFirstblock+BlockLength:length(stimOn)
    thisTrialHistory = stimOn(itrial-(nback-1):itrial);
    for ip = 1:size(patterns,1)
        if all(thisTrialHistory==patterns(ip,:))
            dp.beginStimCondBlock(itrial)=1;
            if itrial+BlockLength < length(dp.beginStimCondBlock)
                dp.beginStimCondBlock(itrial+BlockLength)=1;
                itrial = itrial+BlockLength;
            end
        end
    end
end

end