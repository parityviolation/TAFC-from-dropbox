function dpArray  = plotsummPreMatureEtc(dp,condCell,options)
% function plotsummPreMatureEtc(varargin)
% pick expts

% A = {};
% A(end+1) = {'Sert864_all'};
% A(end+1) = {'Sert867_all'};
% A(end+1) = {'Sert868_all'};
% A(end+1) = {'Sert_179'};
% % A(end+1) = {'Sert_868'};
% % A(end+1) = {'FI12_1013'};
% % A(end+1) = {'Sert_867'};
% for iAnimal = 1:length(A)
%     dpArray = dpArrayInputHelper(A);
%     dpC(iAnimal) = concdp(dpArray);
% end
dpArray = dpArrayInputHelper(dp,condCell);
%%
bsave = 1;
colorbyAnimal = 0;  % set to 1 if you AnimalString is cell of multiple animals
mycolor = [];
bplotOversession = 1;

if nargin >2
    if isfield(options,'bsave')
        bsave = options.bsave;
    end
    if isfield(options,'colorbyAnimal')
        colorbyAnimal = options.colorbyAnimal;
    end
    if isfield(options,'mycolor')
        mycolor = options.mycolor;
    end
    if isfield(options,'bplotOversession')
        bplotOversession = options.bplotOversession;
    end


end
sAnnot =  dpArray(1).collectiveDescriptor ;


% To Do add signifigance (per session)

r = brigdefs();

% define stimulation condition used to compare to .stimulationOnCond
cond(2).color = 'b';
cond(1).color = 'k';
cond(2).desc = 'light';
cond(1).desc = 'control';
cond(2).val = 1;
cond(1).val = 0;

% Add ChoiceMissLeft
% Add ChoiceMissRight
for idp = 1:length(dpArray)
    dpArray(idp).ChoiceMissLeft = zeros(size(dpArray(idp).TrialInit));
    dpArray(idp).ChoiceMissRight = zeros(size(dpArray(idp).TrialInit));
    
    dpArray(idp).ChoiceMissLeft(dpArray(idp).ChoiceMiss==1 & dpArray(idp).Interval<0.5) = 1;
    dpArray(idp).ChoiceMissRight(dpArray(idp).ChoiceMiss==1 & dpArray(idp).Interval>0.5) = 1;
    
end

% % Plot setup

savename_fig1 = ['_Stimulation_PreMatureEtc'];
savename_fig2 = ['_Stimulation_PreMatureEtcSession'];

% choose paramters to plot
difffldsToPlot = {'Premature','PrematureLong','PrematureShort','ChoiceCorrect','LeftCorrect','ChoiceLeft',...
    'ChoiceMiss','RTLong','RTShort','slope','timeToTrialInit','timeToTrialInitError'};
% fig1_fldsToPlot = {'Premature','PrematureLong','PrematureShort','ChoiceCorrect','LeftCorrect','ChoiceLeft',...
%     'ChoiceMiss','RTLong','RTShort','slope','bias','timeToTrialInit','timeToTrialInitError'};
% fig1_names = {'Premature','PM Long','PM Short','Correct','Cor. Long','Ch. Long',...
%     'Ch. Miss','RTLong','RTShort','slope','bias','trInit','trInitErr'};
fig1_fldsToPlot = {'Premature','ChoiceCorrect','ChoiceLeft',...
    'ChoiceMiss','slope','bias'};
fig1_names = {'Premature','Correct','Ch. Long',...
    'Ch. Miss','slope','bias'};
fig2_fldsToPlot = {'delta_Premature','delta_PrematureLong','delta_ChoiceCorrect','delta_LeftCorrect',...
    'delta_ChoiceLeft','delta_ChoiceMiss','delta_RTLong','delta_RTShort','delta_slope',...
    'delta_timeToTrialInit','delta_timeToTrialInitError'};
fig2_names = {'\DeltaPremature','\DeltaPM Long','\DeltaCorrect','\DeltaCor. Long',...
    '\DeltaCh. Long','\DeltaCh. Miss','\DeltaRTLong','\DeltaRTShort','\Deltaslope','\DeltaTr Start','\DeltaTr Start After Err'};

if colorbyAnimal
    mycolor = colormap(hsv(length(dpArray)+1));
end

% initialize figure handles
hf2pt = figure;
hfSess = figure;
hl = []; mhl = [];

nAnimal = {};
% function summ = addBsummPreMature(summ,dpArray)
% for ianimal =1:length(dpArray)
ianimal =1;
f2 = 'stimulationOnCond';
f1 = {'Premature','PrematureLong','PrematureShort','ChoiceCorrect','LeftCorrect','ChoiceLeft','ChoiceMiss','ChoiceMissLeft','ChoiceMissRight'};
clear summ ;
for ifile = 1:length(dpArray);
    dataParsed = dpArray(ifile);
    
    % remove Multiple CHoicemisses in a row (coudl be sleeping)
    filtoptions.bExcludefilter = 1;
    dataParsed = filtbdata(dataParsed,filtoptions,{'ChoiceMiss',1},{{-1,'ChoiceMiss',1}});

    % Session and Animal Properties
    summ(1).Date(ifile) = {[dataParsed.Date(end-3:end-2) '.' dataParsed.Date(end-1:end)]};
    summ(1).Animal(ifile) = {[' ' dataParsed.Animal]};
    summ(1).scaling(ifile,1) = dataParsed.Scaling(1);
    %     if isfield(dataParsed,'Date')
    summ(1).datenum(ifile,1) = datenum(dataParsed.Date,'yymmdd');
    %     else
    %         FileName = dataParsed.FileName;
    %         temp = strfind(FileName,'_');
    %         summ(1).date(ifile,:) = [FileName(temp(end-1)+3:temp(end-1)+4) '-' FileName(temp(end-1)+5:temp(end-1)+6) '-20' FileName(temp(end-1)+1:temp(end-1)+2)] ;
    %         summ(1).datenum(ifile,1) = datenum(summ(1).date(ifile,:),'mm-dd-yyyy');
    %     end
    %
    % Performance Properties
    dataParsed.LeftCorrect = dataParsed.ChoiceCorrect ==1 & dataParsed.ChoiceLeft ==1;
    for ifld = 1:length(f1)
        f = compare2Fields(dataParsed,f1{ifld},f2);
        summ(1).(f1{ifld})(ifile)  = f(2); % control fraction
        summ(2).(f1{ifld})(ifile) = f(1); % stimulated fraction
    end
end

for icond = 1:length(cond)
    for ifile = 1:length(dpArray);
        dataParsed = dpArray(ifile);
        
        % Time to trial Int
        dpCorrect = filtbdata(dataParsed,0,{'ChoiceCorrect',1});
        indStim = dpCorrect.stimulationOnCond==cond(icond).val;
        %         indStim = indStim((indStim+1)<dataParsed.ntrials); %
        indStimplus1= (find(indStim)+1); %
        indStimplus1(indStimplus1 > dpCorrect.ntrials) = [];
        summ(icond).timeToTrialInit(ifile) = nanmean(dpCorrect.timeToTrialInit(indStimplus1))/1000/50; % scaled arbitrarily to be in same range as other datay
        
        dpError = filtbdata(dataParsed,0,{'ChoiceCorrect',0});
        indStim = dpError.stimulationOnCond==cond(icond).val;
        %         indStim = indStim((indStim+1)<dataParsed.ntrials); %
        indStimplus1= (find(indStim)+1); %
        indStimplus1(indStimplus1 > dpError.ntrials) = [];
        summ(icond).timeToTrialInitError(ifile) = nanmean(dpError.timeToTrialInit(indStimplus1))/1000/50; % scaled arbitrarily to be in same range as other datay
        
        % Reaction Times
        summ(icond).RTLong(ifile) = nanmean(dataParsed.ReactionTime( dataParsed.Interval > 0.5 &...
            dataParsed.stimulationOnCond == cond(icond).val))/1000;
        summ(icond).RTShort(ifile) = nanmean(dataParsed.ReactionTime( dataParsed.Interval < 0.5&...
            dataParsed.stimulationOnCond == cond(icond).val))/1000;
        
        
        % Fit Parametters
        ind = find(dataParsed.analysis.psy.condLabel==cond(icond).val);
        
        
        if ~isempty(ind)
            fit =  dataParsed.analysis.psy.fit(ind);
            summ(icond).param_fit(ifile,:)  = fit.param;
            summ(icond).quality(ifile,1)  = fit.quality;
            summ(icond).fit(ifile,1) = fit;
            summ(icond).range(ifile,1) = range(fit.psyc);
            summ(icond).slope(ifile,1) = -log(summ(icond).param_fit(ifile,1));
            summ(icond).bias(ifile,1) = summ(icond).param_fit(ifile,2);
        else
            
            summ(icond).quality(ifile,1)  = NaN;
            summ(icond).range(ifile,1) = NaN;
            summ(icond).slope(ifile,1) = NaN;
            summ(icond).bias(ifile,1) = NaN;
        end
        
    end
end

% function summ = getSummDiff(summ)
% calculate the difference between index 1 (control) and index 2 (stimulated) for all fields in summ
fldname = fieldnames(summ(1));
for ifld = 1:length(fldname)
    if ismember(fldname{ifld},difffldsToPlot)
        summ(1).(['delta_' fldname{ifld}]) = summ(2).(fldname{ifld}) ...
            -summ(1).(fldname{ifld});
    end
end


nAnimal(ianimal) = {cell2mat(unique(summ(1).Animal))};

if colorbyAnimal,c = mycolor(ianimal,:); else c = mycolor;end
[hf2pt hAx2pt temphl]= summaryPlot_twoPoint(summ,fig1_fldsToPlot,fig1_names, c,hf2pt);
mhl = [mhl temphl(end)];
if bplotOversession
    [hfSess hAxSession temphl] = summaryPlot_ParamOverSession(summ,fig2_fldsToPlot,fig2_names, c,cond,hfSess);
    hl = [hl temphl(end)];
else
    hfSess = [];
end

% end

nAnimal(ianimal) = {cell2mat(unique(summ(1).Animal))};

if colorbyAnimal
    hleg = legend(mhl,nAnimal,'Xcolor','none','Color','none','Interpreter','none','Location','NorthWest');
    hleg2 = legend(hl,nAnimal,'Ycolor','none', 'Color','none','Interpreter','none');
    legend(hleg2,'boxoff')
    legend(hleg,'boxoff')
end

plotAnn(sAnnot,hf2pt);
set(hf2pt,'Name',sAnnot)
if bplotOversession
    plotAnn(sAnnot,hfSess);
    set(hfSess,'Name',sAnnot)
end

%
% plotAnn(cell2mat(nAnimal),hf2pt);
% set(hf2pt,'Name',cell2mat(nAnimal))
% plotAnn(cell2mat(nAnimal),hfSess);
% set(hfSess,'Name',cell2mat(nAnimal))



% average with no regard for n perInterval within a session
if bsave
    if ~isempty(hf2pt)
        %         savename = [strtrim(cell2mat(nAnimal)) savename_fig1];
        d =nAnimal{1};
        d(isspace(d)) = [];
        patht = fullfile(r.Dir.SummaryFig, 'PreMatureEtc',d );
        parentfolder(patht,1)
        savefiledesc = [sAnnot savename_fig1];
        savefiledesc(isspace(savefiledesc)) = [];
        export_fig(hf2pt, fullfile(patht, [savefiledesc]),'-pdf','-transparent');
        saveas(hf2pt, fullfile(patht,[savefiledesc '.fig']));
        
    end
    if ~isempty(hfSess)
        %         savename = [cell2mat(nAnimal) savename_fig2];
        patht = fullfile(r.Dir.SummaryFig, 'PreMatureEtc',nAnimal{1});
        parentfolder(patht,1)
        savefiledesc = [sAnnot savename_fig2];
        export_fig(hfSess, fullfile(patht, [savefiledesc]),'-pdf','-transparent');
        saveas(hfSess, fullfile(patht,[savefiledesc '.fig']));
    end
end






