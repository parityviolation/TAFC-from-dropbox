function dpArray =plotRankOrder(varargin)
% plots the P(Long) for each stimulation condition in terms of rank order
% lower rank is lower probablity
% BA

set(0,'DefaultAxesColorOrder',[1 1 0;0 1 1;1 0 1],...
      'DefaultAxesLineStyleOrder',':|-|--');
% ADD BOOT STRAP

rd = brigdefs();
bsave = 1;
% bforfigure = 0;


% average psyc points across days.
if isstruct(varargin{1})
    dpArray = varargin{1};
    if ~isfield(dpArray,'collectiveDescriptor')
        dpArray(1).collectiveDescriptor = dpArray(1).Animal;
    end
else
    A = varargin{1}; % 'sert867_lgcl';    
    [exptnames trials] = getStimulatedExptnames(A{1});
    dpArray = constructDataParsedArray(exptnames, trials);
    dpArray(1).collectiveDescriptor = A{1} ;
end

if nargin==2
    cond =  varargin{2};
    condCell = cond.condGroup;
    sAddToCollectiveDescriptor = cond.condGroupDescr;
else % default
    condCell = 'all'; % group Stimulations conditions accordingly
    sAddToCollectiveDescriptor = '_';
end

dpArray(1).collectiveDescriptor = [dpArray(1).collectiveDescriptor sAddToCollectiveDescriptor];
sAnnot =  dpArray(1).collectiveDescriptor ;
savefiledesc = [ sAnnot '__RankOrder_Stimulation_PsyAcrossDays' ];


%%
% for each dp
clear condlabels
for idp = 1:length(dpArray)
    thisdp = dpArray(idp);
    [dpCond] = getdpCond(thisdp,condCell);
    dpCond = dpCond(end:-1:1); % order from control to number 3
    if idp==1
        setncond =  length(dpCond);
    end
    if setncond ~= length(dpCond)
        warning(['skipping session because Number of Conditions is ' num2str(length(dpCond))])
        array_Rank(idp,:,:) = NaN;
        array_meanRank(idp,:) = NaN;
        array_minRank(idp,:) = NaN;
    else
        
    clear fracLong
    for idpCond = 1:setncond
        condlabels{idpCond} = unique(dpCond(idpCond).stimulationOnCond); % for plotting
        [~, stats] = getStats_dp(dpCond(idpCond));
        fracLong(idpCond,:) = stats.frac.choiceLong;
    end
    [~, ranko] = sort(fracLong); % note: identical numbers have a rank order too (first index first??)
    icondMeanRank = mean(ranko,2); %% THIS
    
    clear maxRank; % the total number of intervals  that are ranked the lowest P(long)
    for idpCond = 1:setncond
        maxRank(idpCond,1) = sum(ranko(idpCond,:)==max(ranko(idpCond,:))); %THIS
    end
    
    array_fracLong(idp,:,:) = fracLong;
    array_Rank(idp,:,:) = ranko;
    array_meanRank(idp,:) = icondMeanRank;
    array_maxRank(idp,:) = maxRank;
    end
end
% plot mean of minimum 
hfig  = figure('position',[360   581   770   341]);
hax(1) = subplot(1,3,1);
% plot(nanmean(array_meanRank)) hold all;
plot(nanmean(array_maxRank));
% legend({'min','mean'})
set(gca,'xtick',[1:setncond],'xticklabel',condlabels)
xlabel('Stim Cond')
ylabel('n x at Max Rank')

hax(2) = subplot(1,3,2);
plot(squeeze(nanmean(array_Rank))')
xlabel('Interval')
set(gca,'xtick',[1:length(thisdp.IntervalSet)],'xticklabel',thisdp.IntervalSet)
ylabel('Mean Rank')
try
legend(cellfun(@num2str,condlabels','UniformOutput',0))
catch
end

hax(3) = subplot(1,3,3);
plot(thisdp.IntervalSet,squeeze(nanmean(array_fracLong))')
xlabel('Interval')
set(gca,'xtick',thisdp.IntervalSet)
ylabel('Mean P(Long)')
try
legend(cellfun(@num2str,condlabels','UniformOutput',0))
catch
end

set(hax(3),'xlim',[0 1],'ylim',[0 1])
set(hax,'Box','off')
plotAnn(sAnnot);


if bsave
    patht = fullfile(rd.Dir.SummaryFig);
    parentfolder(patht,1)
    orient tall
    saveas(hfig, fullfile(patht,[savefiledesc '.pdf']));
    saveas(hfig, fullfile(patht,[savefiledesc '.fig']));
end
   


        