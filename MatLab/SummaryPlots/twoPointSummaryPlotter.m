function hf = summaryPlot_twoPoint(summ,fldsToPlot,names,mycolor)
hf = figure;  % figure for 2 point plot
set(hf,'Name','TAFC_Param','Position',[331    22   944   420])

colorbyAnimal = 1;
if nargin< 5
    mycolor = [];
end
if isempty(mycolor)
     colorbyAnimal = 0;
end
% fields in Summary plot
for ifld = 1:length(fldsToPlot)
    xval = ifld;
    yval1 = summ(1).(fldsToPlot{ifld});
    yval2 = summ(2).(fldsToPlot{ifld});
    
    nsession = length(yval1);
    colorsession = colormap(jet(nsession));
    for isession = 1:nsession
        [hAx hl(isession)] = plotJoinLine(yval1(isession),yval2(isession),[xval-0.25 xval+0.25],gca,0);
        set(hl(isession),'LineWidth',1,'Color',colorsession(isession,:));
    end
    hold all
    myval1 = nanmean(yval1);
    myval2 = nanmean(yval2);
    [hAx mhl] = plotJoinLine(myval1,myval2,[xval-0.25 xval+0.25],gca,0);
    if colorbyAnimal
        set(hl,'LineWidth',1,'Color',mycolor(ianimal,:));
        set(mhl,'LineWidth',3,'Color',mycolor(ianimal,:));
    end
end
for i=1:length(summ(1).ChoiceCorrect)
    %         stext = sprintf('%s\n%s %s',stext,summ(1).Animal{i},summ(1).Date{i});
    sctext{i} = [summ(1).Animal{i} ' ' summ(1).Date{i}];
end
hleg = legend(sctext,'Interpreter','none','Location','NorthWest');
set(hleg,'FontSize',7,'Box','off');

ylabel('Fraction of Trials')
set(gca,'xtick',[1:length(names)],'xticklabel',names)
% set(gca,'ylim',[0 1])
axis tight
set(gca,'ytick',[0 1])
set(gca,'TickDir','out','Box','off')

