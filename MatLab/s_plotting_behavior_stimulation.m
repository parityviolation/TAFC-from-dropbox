%%

% 15-17 had effect on both animals wait
% 17 changed form 85 to constant stimulus
% 17,18 stimulationoff response 85 (I don't udnerstand this because off no
% longer means off )
% several animals
% several days
% lick sensor changed

% pick a session

% 3 cases,
%       no light,
%       light above head,
%       light at 1,2
%      light on/ light off align
%


% VGAT 1385
% NEW sensor
% 111214
%

% TO DO
% SHIELD LIGHT
% There is a offset response (larger when the fiber is higher and hitting more of the cortex

% Remove first X trials
% split out correct and incorrect?

licks = buildLicks();
bsave = 1
clear XY
XY{1} = [0 2.5]
XY{2} = [0 0];
% analysis

% What are the most likely trials to fail on
% reaction time for go and wait across session

% average length of time before wait give up (control for this with go)
% Is there longer waiting time when they wait longer ?? Hazard Rate

% video and lick when the fail and lick what does the animal actually do (the lick port is quite close so it could be not a real lick)

% lick latency (go) as a function of trial in session
% lick boute (haven't detected yet) 
% lick rate

% what does licking boute look like as a fucntino of how long they wait?
% hazard rate? surprise?
% firstTrial = 1; 
% licks = filtspikes(licks,1,{},{'sessionTrial', @(x) x<100})

% problems plotting concatenated session in raster

% 
% ADD HAZARD RATE
% ANALYZE across days ( should at least be no light effect)
% 
% ADD light pulsing for masking
% 
% START STIMULATING BILATERALLY
%% plot correct of each trial time across session
sw = licks.sweeps;
relativeField = 'TrialInit';
sw = addTimeRelativeTo(sw,{'firstLickAfterResponseAvailable'},relativeField);

filterlength = 5; filttype = 'gaussian';
kernel = getFilterFun(filterlength,filttype);


% get inde of Go NoGo Wait
fld = {'ChoiceCorrectGo','ChoiceCorrectNoGo','ChoiceCorrectWait','ChoiceCorrect'};
ttype = {'Go','NoGo','Wait'};
for ifld = 1:length(fld)
    y = sw.(fld{ifld}); % this is the same as Performance
    sw.movingAvg.(fld{ifld}) =  nanconv(y,kernel,'edge','1d') ;
    sw.movingAvg.([fld{ifld} 'NaN']) =  nanconv(y,kernel,'edge','nanout','1d') ;
    
    % first lick times
    if ifld <= length(ttype)
    [~, index.(ttype{ifld})] = filtbdata(sw,0,{'trialType',lower(ttype{ifld})});
    y =  sw.firstLickAfterResponseAvailable_RelativeTime_TrialInit;
    y(~index.(ttype{ifld}))=NaN ;
    sw.movingAvg.(['firstLick' ttype{ifld}]) =  nanconv(y,kernel,'edge','1d') ;
    end
end

x = 1:sw.ntrials;
figure('Name',['Session Avg ' licks.sweeps.Animal ' '  licks.sweeps.Date],...
    'Position', [680   350   854   600])
hAx(1) = subplot(2,1,1);
% find the last trial where the Go averages to 70% only included trials up
% intil here
% lastTrial = find(sw.movingAvg.ChoiceCorrectGo > .8,1,'last')
% line([1 1].*lastTrial,[0 1],'color','k')

h.hlGo = line(x,sw.movingAvg.ChoiceCorrectGo,'LineWidth',2,'color',[0 1 0]);
h.hlNoGo = line(x,sw.movingAvg.ChoiceCorrectNoGo,'LineWidth',2,'color',[1 0 0]);
h.hlWait = line(x,sw.movingAvg.ChoiceCorrectWait,'LineWidth',2,'color',[0.5 0.5 0.5]);
xlabel('Trial #')
ylabel('Performance')
ylim([0 1])
legend({'Go','No Go','Wait'},'Location','Best')

if isfield(sw,'sessiontimeOffset')
indFirstTrialInSession = find(sw.sessionTrial ==1); else indFirstTrialInSession = 1 ;end
hold on;
plot(x(indFirstTrialInSession),ones(1,length(indFirstTrialInSession)),'.k','markersize',10)

defaultAxes(hAx(1))
if isfield(sw,'sessiontimeOffset')
nsessions = length(unique(sw.sessiontimeOffset)); else nsessions = 1; end

hAx(2) = subplot(2,1,2);

h.hlGoLick = line(x,sw.movingAvg.firstLickGo/1000,'LineWidth',2,'color',[0 1 0]);
h.hlNoGoLick  = line(x,sw.movingAvg.firstLickNoGo/1000,'LineWidth',2,'color',[1 0 0]);
h.hlWaitLick  = line(x,sw.movingAvg.firstLickWait/1000,'LineWidth',2,'color',[0.5 0.5 0.5]);
xlabel('Trial #')
ylabel('FirstLick Time (s)')

title('First Lick')
defaultAxes(hAx(2))

% % Manually select range to analyze
axes(hAx(1))
cursor = ginput(2*nsessions); % select ranges to include for each session
cursor = round(cursor);
includeTrials = zeros(1,sw.ntrials);
for i = 1:nsessions    
    includeTrials(cursor((i-1)*2+1,1):cursor((i-1)*2+2,1)) =  1;
        patch([cursor((i-1)*2+1,1) cursor((i-1)*2+1,1) cursor((i-1)*2+2,1) cursor((i-1)*2+2,1)],[0 1 1 0],[0.5 0.5 0.5],'facealpha',0.3,'edgecolor','none')
end


licksFiltered = filtspikes(licks,1,[],{'TrialNumber', find(includeTrials)}) ; % take only a subset of trials (hand selected above)
%%

% % fisher exact test

% plot fraction of Go/Wait/NoGo
s = {'Go','Wait','No Go'};
clear cond
icond = 1;
cond(icond).fsweep = { 'stimulation', 0};
cond(icond).Label = 'Control';
icond = 2;
cond(icond).fsweep = { 'stimulationCoordX',XY{1}(1),'stimulationCoordY',XY{1}(2),'stimulation', 1};
cond(icond).Label = num2str(XY{1});
icond = 3;
cond(icond).fsweep = { 'stimulationCoordX',XY{2}(1),'stimulationCoordY',XY{2}(2),'stimulation', 1};
cond(icond).Label = num2str(XY{2});

for icond = 1:length(cond)
    sw = licksFiltered.sweeps;
sw_ThisStimCoord =  filtbdata(sw,[],cond(icond).fsweep ); 
% probabilty of error
Ntrials(1,icond,:) = [sum(ismember(sw_ThisStimCoord.ChoiceCorrectGo,[0])) sum(sw_ThisStimCoord.ChoiceCorrectGo==1)];
Ntrials(2,icond,:) = [sum(ismember(sw_ThisStimCoord.ChoiceCorrectWait,[0])) sum(sw_ThisStimCoord.ChoiceCorrectWait==1)];
Ntrials(3,icond,:) = [sum(ismember(sw_ThisStimCoord.ChoiceCorrectNoGo,[0])) sum(sw_ThisStimCoord.ChoiceCorrectNoGo==1)];

end
perf = squeeze(Ntrials(:,2,:)./Ntrials(:,1,:)); % unstimulated, stimulated.


for icond = 2:length(cond) % for all none control compare to control
    cond(icond).Label
    for i=1:3 % each trialType
        s{i}
        a = Ntrials(i,1,1); % NoStim NoWait
        b = Ntrials(i,icond,1); % Stim NoWait
        c = Ntrials(i,1,1)+  Ntrials(i,1,2); % NoStim Wait
        d = Ntrials(i,icond,2)+  Ntrials(i,icond,2); % Stim Wait
        
        [~,Pneg(icond-1,i)] =         fisherextest(a,b,c,d);
%         s{i} = [s{i} ' pNeg ='  num2str(Pneg(i),'%1.1f')];
    end
end
%%

h = plotBarStackGroups(Ntrials,s );
 text( .8 *max(xlim), .9*max(ylim) ,num2str(Pneg,' %1.2f'));
 
title('Fisher Exact Test')
legend({'error','correct'},'Location','Best')
defaultAxes(gca)
ylabel('Trials')
% [Ppos,Pneg,Pboth]=fisherextest(a,b,c,d)
sAnn = sprintf('%s_%s_%s',licks.sweeps.Animal,'StimEffectOnPerformance', licks.sweeps.Date);
set(gcf,'Name','Fraction Correct')

fig = gcf;


plotAnn(sAnn, gcf );

 if bsave
%     r = brigdefs;
    sAnimal = licks.sweeps.Animal;
    savepath = fullfile('C:\Users\Bassam\Dropbox (Mainen Lab)\Bassam\BVA_MainenLab\Behavior\Data\HF_GoNoGoWait',sAnimal,'Licks');
    parentfolder(savepath,1);
%         export_fig(fig,fullfile(savepath,sAnn),'-pdf','-transparent')
    plot2svg(fullfile(savepath,[sAnn '.svg']),fig)
%     saveas(fig,fullfile(savepath,sAnn))
    disp([ 'saved to ' fullfile(savepath,sAnn)])
 end

 %Hazard rate?? change
 
%%
clear options cond;


Choice = [1]
% 
 calignEvent = {'timeOdorOn','TrialInit','timeOutcome'};
 cWOI  = {[-2 12]*1000
    [-1 10]*1000 + 5*1000
    [-5 5]*1000 };

% 
% calignEvent = {'TrialInit','timeStimulationOff'};
% cWOI  = { [-1 15]*1000 + 5*1000; [-10 5]*1000 };
% 



% ctypes = {'go','wait','nogo'};
ctypes = {'go','wait','nogo'};

Electrode = 0; % this is for picking Licks
UnitID = 0; % this is for picking Licks

options.bsave = 0;
options.bootstrap = 0;
options.binsize = 10;
options.nsmooth =round(50/ options.binsize);
options.dpFieldsToPlot = {'firstLickAfterResponseAvailable'};
options.bootstrap = 0;

figparam.matpos = [0 0 1 1];
figparam.figmargin = [0.03 0.03  0.025  0 ];  % [ LEFT RIGHT TOP BOTTOM]
figparam.matmargin = [0 0  0  0 ];
figparam.cellmargin = [0.03 0.035  0.06  0.06 ];


nr = length(calignEvent)*2;
nc = length(ctypes);
fig = figure('Position',[ 680          54        1226         924],...
   'Renderer', 'OpenGL','Name',[ licks.sweeps.Animal ' '  licksFiltered.sweeps.Date] );
sAlign = '';
for ialign = 1:length(calignEvent)
    alignEvent = calignEvent{ialign};
    sAlign = [sAlign ' ' alignEvent];

    WOI = cWOI{ialign};
    
    for itype = 1:length(ctypes)
        sTrialType = ctypes{itype}
        
        options.sDesc = [sTrialType 'StimNoStim'];
        
        
        sAnimal = licksFiltered.sweeps.Animal;
        sDate = licksFiltered.sweeps.Date;
        options.savefile = sprintf('%s_%s_%s_AL%s_%sLicks',licksFiltered.sweeps.Animal,licksFiltered.sweeps.Date, options.sDesc,alignEvent, sDate);
        options.dpFieldsToPlot = {};
        options.sortSweepsByARelativeToB= {'firstLickAfterResponseAvailable','timeResponseAvailable'}; % {'firstSidePokeTime',alignEvent};
        options.plottype = {'psth','rasterplot'};
        icond = 1;
        cond(icond).sleg = sTrialType;
        cond(icond).spikesf = {'Electrode',Electrode,'Unit',UnitID};
        cond(icond).sweepsf   = {'trialType',sTrialType,'stimulation',0,'ChoiceCorrect',Choice};
        cond(icond).trialRelsweepsf   = {};
        cond(icond).alignEvent= alignEvent; % NOTE Times must be relative to the beginning of the session
        cond(icond).plotparam.scolor = 'k';
        icond = 2;
        cond(icond).sleg =  [sTrialType ' Stim ' num2str(XY{1})];
        cond(icond).spikesf = {'Electrode',Electrode,'Unit',UnitID};
        cond(icond).sweepsf   = {'trialType',sTrialType,'stimulation',1,'ChoiceCorrect',Choice,...
            'stimulationCoordX',XY{1}(1),'stimulationCoordY',XY{1}(2)};
        cond(icond).trialRelsweepsf   = {};
        cond(icond).alignEvent= alignEvent; % NOTE Times must be relative to the beginning of the session
        cond(icond).plotparam.scolor = 'b'
        icond = 3;
        
        cond(icond).sleg = [sTrialType ' Stim ' num2str(XY{2})];
        cond(icond).spikesf = {'Electrode',Electrode,'Unit',UnitID};
        cond(icond).sweepsf   = {'trialType',sTrialType,'stimulation',1,'ChoiceCorrect',Choice,...
            'stimulationCoordX',XY{2}(1),'stimulationCoordY',XY{2}(2)};
        cond(icond).trialRelsweepsf   = {};
        cond(icond).alignEvent= alignEvent; % NOTE Times must be relative to the beginning of the session
        cond(icond).plotparam.scolor = [0 0 0.5];

        [h  ntrialsInCond]= psthCondSpikes(licksFiltered,cond, WOI, options);
%           
        % set(h.fig,'WindowStyle','docked')
        
        setaxesOnaxesmatrix(h.hAx(1),nr,nc,(ialign-1)*nc*2+itype,figparam,fig)
        setaxesOnaxesmatrix(h.hAx(2),nr,nc,(ialign-1)*nc*2+nc +itype,figparam,fig)
              clear sleg; for icond =1 : length(cond),       sleg{icond} =  [cond(icond).sleg ' n = ' num2str(ntrialsInCond(icond),'%d')] ; end
        hlegPsth = legend(h.hAx(1),h.hpsth,sleg);
        defaultLegend(hlegPsth,[],7)
        close(h.fig);

    end
end

sAnn = sprintf('%s_%s_%s_Choice%s Licks_%s',licks.sweeps.Animal,deblank(sAlign),'LightOnandOFF', deblank(num2str(Choice,' %d')), licks.sweeps.Date);

plotAnn(sAnn, fig );

 if bsave
%     r = brigdefs;
    sAnimal = licks.sweeps.Animal;
    savepath = fullfile('C:\Users\Bassam\Dropbox (Mainen Lab)\Bassam\BVA_MainenLab\Behavior\Data\HF_GoNoGoWait',sAnimal,'Licks');
    parentfolder(savepath,1);
%         export_fig(fig,fullfile(savepath,sAnn),'-pdf','-transparent')
    plot2svg(fullfile(savepath,[sAnn '.svg']),fig)
%     saveas(fig,fullfile(savepath,sAnn))
    disp([ 'saved to ' fullfile(savepath,sAnn)])
 end
        
