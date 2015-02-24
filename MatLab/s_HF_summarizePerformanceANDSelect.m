%% plot correct of each trial time across session
sw = licks.sweeps;
relativeField = 'TrialInit';
sw = addTimeRelativeTo(sw,{'timeOutcome'},relativeField);

filterlength = 5; filttype = 'gaussian';
kernel = getFilterFun(filterlength,filttype);


% get inde of Go NoGo Wait
fld = {'ChoiceCorrectGo','ChoiceCorrectNoGo','ChoiceCorrectWait','ChoiceCorrect'};
ttype = {'Go','NoGo','Wait'};
filter = {{'ChoiceCorrect',1},{'ChoiceCorrect',0},{'ChoiceCorrect',0}};
for ifld = 1:length(fld)
    y = sw.(fld{ifld}); % this is the same as Performance
    sw.movingAvg.(fld{ifld}) =  nanconv(y,kernel,'edge','1d') ;
    sw.movingAvg.([fld{ifld} 'NaN']) =  nanconv(y,kernel,'edge','nanout','1d') ;
    
    % outcome times
    if ifld <= length(ttype)
    [~, index.(ttype{ifld})] = filtbdata(sw,0,{'trialType',lower(ttype{ifld}),filter{ifld}{:}});
    y =  sw.timeOutcome_RelativeTime_TrialInit;
    y(~index.(ttype{ifld})) = NaN;
    sw.movingAvg.(['timeOutcome' ttype{ifld}]) =  nanconv(y,kernel,'edge','1d') ;
    end
      
end

fld = {'nLicks','nLicksBeforeOdor','nLicksDuringOdorDelay','nLicksAfterOutcome'};
fldname = {'GoCorrect','NoGoError','WaitCorrect','WaitError'};
ttype = {'Go','NoGo','Wait','Wait'};
filter = {{'ChoiceCorrect',1},{'ChoiceCorrect',0},{'ChoiceCorrect',[1]},{'ChoiceCorrect',[0]}};
for ifld = 1:length(fld)
    y=sw.(fld{ifld});
    for itt = 1:length(ttype)
        thisy = y;
        [~, index.(ttype{itt})] = filtbdata(sw,0,{'trialType',lower(ttype{itt}),filter{itt}{:}});
        thisy(~index.(ttype{itt}))=NaN ;
        sw.movingAvg.([(fld{ifld}) fldname{itt}]) =  nanconv(thisy,kernel,'edge','1d');
    end
end


x = 1:sw.ntrials;
figure('Name',['Session Avg ' licks.sweeps.Animal ' '  licks.sweeps.Date],...
    'Position', [680   0   854   900])
hAx(1) = subplot(3,2,1);
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
nsessions = length(unique(sw.sessiontimeOffset)); else nsessions = 1; end

hAx(2) = subplot(3,2,3);

h.hlGoLick = line(x,sw.movingAvg.timeOutcomeGo/1000,'LineWidth',2,'color',[0 1 0]);
h.hlNoGoLick  = line(x,sw.movingAvg.timeOutcomeNoGo/1000,'LineWidth',2,'color',[1 0 0]);
h.hlWaitLick  = line(x,sw.movingAvg.timeOutcomeWait/1000,'LineWidth',2,'color',[0.5 0.5 0.5]);
xlabel('Trial #')
ylabel('FirstLick Time (s)')

title('First Lick, CorrectGo, Error NoGo& Wait')

% lick plots

hAx(3) = subplot(3,2,2);
fldname = {'GoCorrect','NoGoError','WaitCorrect','WaitError'}

h.hlGoLick = line(x,sw.movingAvg.nLicksGoCorrect,'LineWidth',2,'color',[0 1 0]);
h.hlNoGoLick  = line(x,sw.movingAvg.nLicksNoGoError,'LineWidth',2,'color',[1 0 0]);
h.hlWaitLick  = line(x,sw.movingAvg.nLicksWaitCorrect,'LineWidth',2,'color',[0.5 0.5 0.5]);
h.hlWaitLick  = line(x,sw.movingAvg.nLicksWaitError,'LineWidth',2,'color',[0.5 0.5 0.5],'LineStyle','--');
xlabel('Trial #')
ylabel('Total Licks')

title('Total Licks')
hAx(4) = subplot(3,2,4);

h.hlGoLick = line(x,sw.movingAvg.nLicksDuringOdorDelayGoCorrect,'LineWidth',2,'color',[0 1 0]);
h.hlNoGoLick  = line(x,sw.movingAvg.nLicksDuringOdorDelayNoGoError,'LineWidth',2,'color',[1 0 0]);
h.hlWaitLick  = line(x,sw.movingAvg.nLicksDuringOdorDelayWaitCorrect,'LineWidth',2,'color',[0.5 0.5 0.5]);
h.hlWaitLick  = line(x,sw.movingAvg.nLicksDuringOdorDelayWaitError,'LineWidth',2,'color',[0.5 0.5 0.5],'LineStyle','--');
xlabel('Trial #')
ylabel('# Licks During Odor and Delay Licks')

title('Odor and Delay Licks')

hAx(5) = subplot(3,2,6);
h.hlGoLick = line(x,sw.movingAvg.nLicksAfterOutcomeGoCorrect,'LineWidth',2,'color',[0 1 0]);
h.hlNoGoLick  = line(x,sw.movingAvg.nLicksAfterOutcomeNoGoError,'LineWidth',2,'color',[1 0 0]);
h.hlWaitLick  = line(x,sw.movingAvg.nLicksAfterOutcomeWaitCorrect,'LineWidth',2,'color',[0.5 0.5 0.5]);
h.hlWaitLick  = line(x,sw.movingAvg.nLicksAfterOutcomeWaitError,'LineWidth',2,'color',[0.5 0.5 0.5],'LineStyle','--');
xlabel('Trial #')
ylabel('# Licks After Outcome')

title('After Outcome Licks')


defaultAxes(hAx)



% add Start of Session marker
if isfield(sw,'sessiontimeOffset')
indFirstTrialInSession = find(sw.sessionTrial ==1); else indFirstTrialInSession = 1 ;end
hold on;
hStartSession = line(x(indFirstTrialInSession),ones(1,length(indFirstTrialInSession)),'linestyle','x','color','k','markersize',10);

copyobj(hStartSession,hAx(1:end-1));

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
