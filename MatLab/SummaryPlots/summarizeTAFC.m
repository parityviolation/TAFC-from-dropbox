function hpsyc = summarizeTAFC(AnimalStr,lastNfiles,bplotAvg)
% function summarizeTAFC(AnimalStr or dpArray,lastNfiles)
% plot and save a summary of the Animal descrbied by AnimalStr 
bsave =1;
rd = brigdefs();
datadir = rd.Dir.DataBehav;
bnewfig = 1;

bplotAvg = 0;

if nargin ==0
    [FileName,PathName,FilterIndex] = uigetfile([datadir '\*.txt'],'Select Behavior file(s) to analyze','MultiSelect','on');
else
    dpArray = [];
    try
    [dpArray]= dpArrayInputHelper(AnimalStr);
    end
    if ~isempty(dpArray)
        for idp = 1:length(dpArray)
            PathName= dpArray(idp).PathName;
            files{idp,1} = [dpArray(idp).FileName '.txt'];
        end
    else
        [PathName files] = getAnimalExpt(AnimalStr);
    end
    
    if nargin <2
        beginfile =1;
        lastNfiles = size(files,1);
        FileName = files(1:lastNfiles,1);
    elseif lastNfiles <=0
        FileName = files(1:lastNfiles,1);
    else
        
        if length(lastNfiles) ==1
            
            FileName = files(1:min(length(files),lastNfiles),1);
            lastNfiles = size(files,1);
        else
            FileName = files([lastNfiles(1):lastNfiles(2)],1);
        end
            
    end
    
end
% dir([datadir dp.mouseName '\*.txt'])
% doesn't work with only one file
ind =1; % filenames with valid data
for i = 1: length(FileName)
    try
        if ~isempty(dpArray)
            dp = dpArray(i);
        else
            dp= custom_parsedata(fullfile(PathName,FileName{i}));
        end
        if ~isempty(dp)
            
            %           [summary.psyc(ind,:), summary.xaxis(ind,:), summary.param_fit(ind,:)] = psycurve_t(dp.matrix,false,true);
            fit = ss_psycurve(dp,0,1);
            summary.param_fit(ind,:)  = fit.param;
            summary.quality(ind,1)  = fit.quality;
            summary.fit(ind,1) = fit;
            summary.range(ind,1) = range(fit.psyc);
            summary.slope(ind,1) = -log(summary.param_fit(ind,1));
            summary.bias(ind,1) = summary.param_fit(ind,2);
            summary.scaling(ind,1) = dp.Scaling(1);
            
            summary.stimulation(ind,1) = any(dp.stimulationOnCond);
            
            
            
            temp = strfind(FileName{i},'_');
            dataParsed = addBExptDetails(dp);
            if summary.stimulation(ind,1)
                summary.date(ind,:) = [dp.Date ' stim'];
            else
                summary.date(ind,:) = [dp.Date ' ctrl'];
            end
            summary.datenum(ind,1) = datenum(dp.Date,'yymmdd');
            
            summary.mouseName(ind,1) = {dp.Animal};
            summary.Ncorrect(ind,1) = sum(dp.ChoiceCorrect==1);
            summary.Nincorrect(ind,1) = sum(dp.ChoiceCorrect==0);
            summary.NValidtrials(ind,1) = sum(~isnan(dp.ChoiceCorrect)) ;
            summary.Ntrials(ind,1) = length(dp.ChoiceCorrect) ;
            summary.Premature(ind,1) = sum(dp.Premature);
            
            ind = ind+1;
            
        end
    catch ME
        getReport(ME)
    end
    
end
tempsummary = summary;
save(fullfile(rd.Dir.SummaryFig,[summary.mouseName{end} 'SummaryPerformance']),'summary');
summary = tempsummary;
ind_include = [];
MAX_FITQUALITY = 0.6;
ind_include = find(summary.quality <MAX_FITQUALITY  ...
            & summary.NValidtrials >50);% ...
%             & summary.scaling== 3000) ;
        
        fld = fieldnames(summary);
        for ifield = 1:length(fld)
            if size(summary.(fld{ifield}),2)>1
                summary.(fld{ifield}) = summary.(fld{ifield})(ind_include,:);
            else
                summary.(fld{ifield}) = summary.(fld{ifield})(ind_include);
            end
        end
% sort
[junk sortind ] = sort(summary.datenum,'ascend');
hax = [];
if bnewfig
   hf = figure;
end
% plotting
nr = 2;
nc = 2;
hf = gcf;

set(hf,'Name',  summary.mouseName{end},'Position',[360    69   913   853],'Visible','off') % BA watch out assuming only one mouse
hax(end+1) = subplot(nr,nc,1);
plot(summary.datenum(sortind),log10(summary.slope(sortind)),'r','linewidth',2); hold on
plot(summary.datenum(sortind),summary.bias(sortind),'k','linewidth',2);
plot(summary.datenum(sortind),summary.range(sortind),'b','linewidth',2);
% plot(summary.datenum(sortind),summary.stimulation(sortind),'r','linewidth',2);
title ('Performance')
s{1} = 'slope';
s{2} = 'bias';
s{3} = 'range';
% s{4} = 'stimulation';
legend(s,'box','off','Location','Best');
axis tight
ylim([0 1])

sordate = summary.date(sortind,:);
subplot(nr,nc,2);
if bplotAvg
    mp = nanmean(summary.param_fit(:,:));
    fit.param = mp;
    hpsyc =   plotpsycurve(fit);
    %     set(h.hp,'edgealpha',1)
    %     setColor(h.hp,'k')
    %     set(h.hp,'lineWidth',3);
else
    hpsyc = plotpsycurve(summary.fit(sortind));
    cm = colormap(jet(length(summary.fit)));
    for ihp = 1:length(hpsyc.hl)
        setColor(hpsyc.hl(ihp),cm(ihp,:))
        s{ihp} = sordate(ihp,:);
    end
%     set(h.hp,'edgealpha',0.25)
end
hleg = legend(hpsyc.hl,s,'box','off','Location','EastOutside');
set(hleg,'fontsize',6)
axis tight
ylim([0 1])

hax(end+1) =subplot(nr,nc,3);
plot(summary.datenum(sortind),summary.Ntrials(sortind),'k'); hold all;
plot(summary.datenum(sortind),summary.NValidtrials(sortind),'b');hold on;
plot(summary.datenum(sortind),summary.Ncorrect(sortind),'g'); hold all;
title ('Trials')
s{1} = 'Total';
s{2} = 'Valid';
s{3} = 'Correct';
axis tight
%ylim([0 300])
legend(s,'box','off','Location','Best');

hax(end+1) =subplot(nr,nc,4);
plot(summary.datenum(sortind),summary.Ncorrect(sortind)./summary.NValidtrials(sortind),'g');hold on;
plot(summary.datenum(sortind),summary.Ncorrect(sortind)./summary.Ntrials(sortind),'b');hold on;
plot(summary.datenum(sortind),summary.Premature(sortind)./summary.Ntrials(sortind),'color',[0.3 0.3 0.3]);
s{1} = 'C & Valid';
s{2} = 'C';
s{3} = 'PreM';
legend(s,'box','off','Location','Best');
ylim([0 1])

for i = 1:length(hax)
    if length(FileName) > 40
        datetick(hax(i),'x',3,'keeplimits');
    else
        datetick(hax(i),'x',6),'keeplimits';
        
    end
end
plotAnn(summary.mouseName(1))
set(hax, 'xlim', [min(summary.datenum(:)), max(summary.datenum(:))]);
linkaxes(hax,'x');

if bsave
    export_fig(fullfile(rd.Dir.SummaryFig,['Summary_' summary.mouseName{1}]),'-transparent','-pdf',gcf)
    disp('saving figures.................................');
end
set(hf,'Visible','on')



% plot