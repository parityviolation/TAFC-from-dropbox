% plot History of performance from log
function h = plotLogSummary(dpAnimal,hfig)
% dpAnimal = 'Sert_1422'
bsave = 1;
h.bautoscaleX = 0;

r = brigdefs;
savefile = r.FullPath.animalLog;
load(savefile);


[~, h.thisLog] = getLogIndexAnimal(dpAnimal,animalLog);


thisDatenum = datenum(h.thisLog.date,'dd/mmm/yy');
nDaysActuallyTrained = length(thisDatenum);
nDaysTraining = thisDatenum(end) - thisDatenum(1);
%%
h.fld = {'weight','fracValidReward','biasLeft','nRewards','nPremature','trialPerSec','boxIndex','sessionDurationHr','nStimuli'};
h.stitle = {'Weight','Performance','Bias Left', 'Rewards','Premature','Trial Rate','Box Index','Sess Dur','nStimuli'};
h.sylabel = {'g','fracValidReward','bias','trials','trials','sec/trial','','Hr',''};
h.nylim = {[10 50],[0.4 1],[-0.4 0.4],[0 500],[0 100],[10 30],[1 8],[0 6],[2 12]};

if 0 % config 1
    h.mat(1).params.matpos = [0 0 1 1];                % [left top width height]
    h.mat(1).params.figmargin = [0.0 0 0.12 0];                % [left right top bottom]
    h.mat(1).params.matmargin = [0 0 0 0];                      % [left right top bottom]
    h.mat(1).params.cellmargin = [0.05 0.055 0.15 0.15];        % [left right top bottom]
    h.mat(1).nrow = 2;
    h.mat(1).ncol = ceil(length(h.fld)/h.mat(1).nrow );
    pos = [ 1362          53         553         196]
else % plot as one colume
    
    h.mat(1).params.matpos = [0 0 1 1];                % [left top width height]
    h.mat(1).params.figmargin = [0.0 0 0.12 0];                % [left right top bottom]
    h.mat(1).params.matmargin = [0 0 0 0];                      % [left right top bottom]
    h.mat(1).params.cellmargin = [0.2 0.22 0.05 0.1];        % [left right top bottom]
    h.mat(1).nrow = length(h.fld);
    h.mat(1).ncol = 1;
    pos = [    1661          51         253         944];
end
h.hax = [];
if nargin <2
    h.fig = figure;
else
    h.fig = hfig;
end
    
set(h.fig,'Name',[dpAnimal ' Summary'],'Position',pos...
    ,'NumberTitle','off','Visible','off') % BA watch out assuming only one mouse
set(h.fig,'KeyPressFcn',@updatefigure);

for ifld = 1:length(h.fld)
    h.hax(end+1) =axes('Parent',h.fig);
    plot(thisDatenum,h.thisLog.(h.fld{ifld}),'parent',h.hax(end),'Marker','.'); hold all
    title(h.stitle{ifld});
    ylabel(h.sylabel{ifld});
    %     h.nylim{ifld}(1) = min([h.thisLog.(h.fld{ifld}) h.nylim{ifld}(1)]);
    %     h.nylim{ifld}(2) = max([h.thisLog.(h.fld{ifld}) h.nylim{ifld}(2)]);
    %     ylim(h.nylim{ifld});
    % plot x axis
line(get(h.hax(end),'xlim'),[0 0],'color','k','linestyle',':')

end
axishelper(h);

h.mat(1).h = h.hax;
for i = 1:length(h.mat)
    ind = 1:length(h.mat(i).h);
    setaxesOnaxesmatrix(h.mat(i).h,h.mat(i).nrow,h.mat(i).ncol,ind, ...
        h.mat(i).params,h.fig);
end

plotAnn([dpAnimal ' ' num2str(nDaysActuallyTrained) ' of '  num2str(nDaysTraining) ' days']);
defaultAxes(h.hax,[],[],8);

linkaxes(h.hax,'x');
dynamicDateTicks(h.hax, 'link','ddd/mm');
setDateAxes(h.hax, 'XLim', [min(thisDatenum), max(max(thisDatenum),min(thisDatenum)+10)]);
%  rotateXLabels( h.hax, 60 ) % doesn't work with dynamic axis

if bsave
    export_fig(fullfile(r.Dir.SummaryFig,'Log Summary',['LogSummary_' dpAnimal]),'-transparent','-pdf',h.fig);
end

set(h.fig,'Visible','on');


guidata(h.fig,h);
end
function updatefigure(src,event)
h = guidata(src);
% Callback to parse keypress event data to print a figure
switch(event.Character)
    
    case 'a' %toggle autoscale access
        h.bautoscaleX = ~h.bautoscaleX;
end
guidata(src,h);
axishelper(h);
end

function axishelper(h)
for iax = 1:length(h.hax)
    if h.bautoscaleX
        h.nylim{iax}(1) = min(h.thisLog.(h.fld{iax}));
        h.nylim{iax}(2) = max(h.thisLog.(h.fld{iax}));
        if h.nylim{iax}(1)== h.nylim{iax}(2)
            h.nylim{iax}(1) = h.nylim{iax}(1)*.95;
            h.nylim{iax}(2) = h.nylim{iax}(2)*1.05;
        end
            
    else
        h.nylim{iax}(1) = min([h.thisLog.(h.fld{iax}) h.nylim{iax}(1)]);
        h.nylim{iax}(2) = max([h.thisLog.(h.fld{iax}) h.nylim{iax}(2)]);
    end
    set(h.hax(iax),'YLim',h.nylim{iax});
end
end

