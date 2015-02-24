function [hf hAx mhl hl]= summaryPlot_twoPoint(summ,fldsToPlot,names,mycolor,hf)

colorbyAnimal = 0;
if nargin< 4
    mycolor = [];
end
if isempty(mycolor)
    colorbyAnimal = 0;
end

if nargin < 5
    hf = [];
end

if isempty(hf) | ~ishandle(hf)
    hf = figure;  % figure for 2 point plot
end

[~, sortind ] = sort(summ(1).datenum,'ascend');

set(hf,'Name','TAFC_Param','Position',[331    22   944   420])
set(0,'CurrentFigure',hf)
hAx = subplot(1,1,1);
ncomparisons = length(fldsToPlot);
% fields in Summary plot
for ifld = 1:length(fldsToPlot)
    xval = ifld;
    yval1 = summ(1).(fldsToPlot{ifld})(sortind);
    yval2 = summ(2).(fldsToPlot{ifld})(sortind);
    
    nsession = length(yval1);
    colorsession = colormap(copper(nsession));
    for isession = 1:nsession
        [hAx hl(isession)] = plotJoinLine(yval1(isession),yval2(isession),[xval-0.25 xval+0.25],hAx,0);
        set(hl(isession),'LineWidth',1,'Color',colorsession(isession,:));
    end
    hold all
    [p h] = signtest(yval1,yval2);
%     p = p*ncomparisons; % Boneferri correction (not really fair cause tests are not independent)
    if h
        text(xval,1,['p=' num2str(p,'%1.1g')],'Fontsize',6,'Parent',hAx);
    end
    
    myval1 = nanmean(yval1);
    myval2 = nanmean(yval2);
    [hAx mhl(ifld)] = plotJoinLine(myval1,myval2,[xval-0.25 xval+0.25],gca,0);
   
    if colorbyAnimal
        set(hl(:),'Color',mycolor);
        set(mhl(:),'Color',mycolor);
    elseif ~isempty(mycolor)
        for iline = 1:length(hl)
             set(hl(iline),'Color',mycolor(iline,:));
        end
    end
    
end

set(mhl(:),'LineWidth',3);

for i=1:length(sortind)
    %         stext = sprintf('%s\n%s %s',stext,summ(1).Animal{i},summ(1).Date{i});
    sctext{i} = [summ(1).Animal{sortind(i)} ' ' summ(1).Date{sortind(i)}];
end
hleg = legend(sctext,'Interpreter','none','Color','none','Location','BestOutside','FontSize',7);
legend('boxoff')
ylabel('Fraction of Trials')
set(gca,'xtick',[1:length(names)],'xticklabel',names)
axis tight
yl = max(get(gca,'ylim'));
set(gca,'ylim',[-0.1 min(3,yl)])
set(gca,'xlim',[min(get(gca,'xlim'))-0.1 max(get(gca,'xlim'))+0.1])
set(gca,'ytick',[0 1])
set(gca,'TickDir','out','Box','off')
set(gca,'color','none');
% orient(hf,'landscape');
%

hAx =gca;

