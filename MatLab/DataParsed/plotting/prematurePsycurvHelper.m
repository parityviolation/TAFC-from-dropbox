function [dataParsed dpPM]= prematurePsycurvHelper(dataParsed)
% function dpPM = prematurePsycurvHelper(dataParsed)
ndx = getIndex_dp(dataParsed);

dpPM= filtbdata_trial(dataParsed,ndx.prem);
% create bins for placing PreTime into Interval times
edges(1) = 0;
for iInt = 1:length(dpPM.IntervalSet)-1
    edges(end+1) = mean([dpPM.IntervalSet(iInt),dpPM.IntervalSet(iInt+1)]);
end
edges(end+1) = 1;

% bin Premature times into the Intervals given during the during the
% session

dpPM.ChoiceLeft(:) = 0;
dpPM.ChoiceLeft(logical(dpPM.PrematureLong)) = 1;
for itrial = 1:length(dpPM.Interval)
    for ie = 1:(length(edges)-1)
        if  edges(ie)<=(dpPM.PremTime(itrial)/dpPM.Scaling(end)) &(dpPM.PremTime(itrial)/dpPM.Scaling(end))< edges(ie+1)
            dpPM.Interval(itrial) = dpPM.IntervalSet(ie);
%             if ie == 1
%                 dpPM.PremTime(itrial)/dpPM.Scaling(end)
%             end
        end
    end
end

dataParsed.IntervalwithPM = dataParsed.Interval;
dataParsed.IntervalwithPM(ndx.prem) = dpPM.Interval;

