function [ rt, rtSem, stimSet ] = reactime( data_parsed, plotting )
%rt Returns the median reaction time per stimulus
%   Detailed explanation goes here

if nargin < 2
    plotting = true;
end

stimSet = data_parsed.IntervalSet;
stimVector = data_parsed.Interval;
rtVector = data_parsed.ReactionTime;
choiceVector = data_parsed.ChoiceCorrect;

rt = nan(3,length(stimSet));
rtSd = nan(3,length(stimSet));
rtN = nan(3,length(stimSet));
rtSem = nan(3,length(stimSet));

for s = 1:length(stimSet)
    % All trials
    rt(1,s) = nanmedian(rtVector(stimVector==stimSet(s)));
    rtSd(1,s) = nanstd(rtVector(stimVector==stimSet(s)));
    rtN(1,s) = sum(and(stimVector==stimSet(s),~isnan(rtVector)));
    rtSem(1,s) = rtSd(1,s)/sqrt(rtN(1,s));
    % Only corrects
    rt(2,s) = nanmedian(rtVector(stimVector==stimSet(s) & choiceVector==1));
    rtSd(2,s) = nanstd(rtVector(stimVector==stimSet(s) & choiceVector==1));
    rtN(2,s) = sum(stimVector==stimSet(s) & ~isnan(rtVector) & choiceVector==1);
    rtSem(2,s) = rtSd(2,s)/sqrt(rtN(2,s));
    % Only incorrects
    rt(3,s) = nanmedian(rtVector(stimVector==stimSet(s) & choiceVector==0));
    rtSd(3,s) = nanstd(rtVector(stimVector==stimSet(s) & choiceVector==0));
    rtN(3,s) = sum(stimVector==stimSet(s) & ~isnan(rtVector) & choiceVector==0);
    rtSem(3,s) = rtSd(3,s)/sqrt(rtN(3,s));
end

if plotting
    figure, plot(stimSet,rt)
    hold on
    patch([stimSet, fliplr(stimSet)],[rt-(rtSd./sqrt(rtN)), fliplr(rt+(rtSd./sqrt(rtN)))],[1 172 235]/255,'edgecolor','none','facealpha',0.5)
    axis([0 1 0 max(rt)*1.25])
end
end