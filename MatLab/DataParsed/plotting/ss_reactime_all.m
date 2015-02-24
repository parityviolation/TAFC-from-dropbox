function [varargout] = ss_reactime_all(data_parsed, plotting, hAx )
%rt Returns the median reaction time per stimulus
%   Detailed explanation goes here

if nargin < 2
    plotting = true;
end

if nargin < 3
    hAx = gca;
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

h = [];
if plotting
    
    h.hp(1) =  patch([stimSet, fliplr(stimSet)],[rt(1,:)-rtSem(1,:), fliplr(rt(1,:)+rtSem(1,:))],'k','edgecolor','none','facealpha',0.2,'Parent',hAx);
    h.hp(2) =  patch([stimSet, fliplr(stimSet)],[rt(2,:)-rtSem(2,:), fliplr(rt(2,:)+rtSem(2,:))],'g','edgecolor','none','facealpha',0.2,'Parent',hAx);
    h.hp(3) =  patch([stimSet, fliplr(stimSet)],[rt(3,:)-rtSem(3,:), fliplr(rt(3,:)+rtSem(3,:))],'r','edgecolor','none','facealpha',0.2,'Parent',hAx);
    
    h.hl(1) = line(stimSet,rt(1,:),'color','k','Parent',hAx);
    h.hl(2) = line(stimSet,rt(2,:),'color','g','Parent',hAx);
    h.hl(3) = line(stimSet,rt(3,:),'color','r','Parent',hAx);
    if ~isnan(rt)
        set(hAx,'xlim',[0 1],'ylim',[ min(min(rt))-200, max(max(rt))+200])
    end
end

data.rt = rt;
data.rtSd = rtSd;
data.rtN = rtN;
data.rtSem = rtSem;
varargout{1} = data;
varargout{2} = h;
end