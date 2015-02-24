function h = plotRunningAvg(dataParsed,hAx,bvertical,bplotPrem)
if ~exist('bplotPrem','var')
    bplotPrem = 1;
end
if ~exist('bvertical','var')
    bvertical = 0;
end
if ~exist('hAx','var')
    hAx = gca;
end
x = dataParsed.Interval;
% x = x(~isnan(x));
prem_ndx = dataParsed.Premature==1;
corrects = double(dataParsed.ChoiceCorrect(not(prem_ndx))==1);
prem = double(dataParsed.Premature==1|dataParsed.PrematureFixation==1);
kernel = ones(1,20)/20;

avg = filter(kernel,1,corrects);
avgPrem = filter(kernel,1,prem);
avg(1:length(kernel)) = nan;
avgPrem(1:length(kernel)) = nan;
h.hlPrem = [];
if bvertical
    xlabel 'Average performance'
    if bplotPrem
        h.hlPrem = line(avgPrem,[1:length(avgPrem)],'LineWidth',3,'color',[.8 .8 .8],'Parent',hAx);
    end
    temp = nan(size(avg)); ind = find(not(prem_ndx)); % handle the case when the kernel is bigger than the data set
    temp(1:length(ind)) = ind;
    h.hlPerf = line(avg,temp,'LineWidth',3,'Parent',hAx);
else
    ylabel 'Average performance'
    if bplotPrem
    h.hlPrem = line([1:length(avgPrem)],avgPrem,'LineWidth',3,'color',[.8 .8 .8],'Parent',hAx);
    end
    temp = nan(size(avg)); ind = find(not(prem_ndx)); % handle the case when the kernel is bigger than the data set
    temp(1:length(ind)) = ind;
    h.hlPerf = line(temp,avg,'LineWidth',3,'Parent',hAx);
end