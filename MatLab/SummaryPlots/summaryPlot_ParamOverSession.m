function [hf hAx hl]= summaryPlot_ParamOverSession(summ,fldsToPlot,names,mycolor,cond,hf)


colorbyAnimal = 1;
if nargin< 4
    mycolor = [];
end
if isempty(mycolor)
    colorbyAnimal = 0;
end
if nargin < 5
    cond(2).color = 'b';
    cond(1).color = 'k';
    cond(2).desc = 'light';
    cond(1).desc = 'control';
end
if nargin < 6
    hf = [];
end

if  isempty(hf) | ~ishandle(hf)
    hf = figure();  % figure for 2 point plot
end
set(hf,'Name','TAFCParamOverSession','Position',[ 331    22   944   893])
set(0,'CurrentFigure',hf);

hAx = [];
nc = 2;
nr= ceil(length(fldsToPlot)/2);

[~, sortind ] = sort(summ(1).datenum,'ascend');

% fields in Summary plot
for ifld = 1:length(fldsToPlot)
    hAx(end+1) = subplot(nr,nc,ifld);
    
    title(names{ifld})
    nsession = summ(1).datenum(sortind);
    if ~isempty(strfind(fldsToPlot{ifld},'delta'))
        yval1 = summ(1).(fldsToPlot{ifld})(sortind);
        [hl(1,ifld)] = line(nsession,yval1,'Color','k');
        set(hl(1,ifld),'LineWidth',3);
        line([min(nsession), max(nsession)],[0 0],'LineStyle','--','LineWidth',1,'Color','k');
    else
        yval1 = summ(1).(fldsToPlot{ifld})(sortind);
        yval2 = summ(2).(fldsToPlot{ifld})(sortind);
        [ hl(1,ifld)] = line(nsession,yval1,'Color',cond(1).color);
        [hl(2,ifld)] = line(nsession,yval2,'Color',cond(2).color);
        set(hl(:,ifld),'LineWidth',3);
    end
    axis tight
end
if colorbyAnimal
    set(hl(:),'Color',mycolor);
end
set(hAx(:),'TickDir','out','Box','off')
set(hAx(:),'FontSize',7)
set(hAx(:),'color','none');
for i = 1:length(hAx)
    if length(nsession) > 40
        datetick(hAx(i),'x',3);
    else
        datetick(hAx(i),'x',6);        
    end
end
% set(hAx(:), 'xlim', [min(summ(1).datenum(:)), max(summ(1).datenum(:))]);

if ~colorbyAnimal
    hleg = legend({cond(1).desc,cond(2).desc},'Interpreter','none','Location','NorthWest');
    set(hleg,'FontSize',7,'Box','off','Location','Best');
end
% orient(hf,'tall')