% plot History of performance from log
function h = plotLogSummary(dpAnimal)
% dpAnimal = 'Sert_1422'
r = brigdefs;
savefile = r.FullPath.animalLog;
load(savefile)


[~, thisLog] = getLogIndexAnimal(dpAnimal,animalLog);


thisDatenum = datenum(thisLog.date,'dd/mmm/yy');
%%
fld = {'fracValidReward','weight','nRewards','nPremature','trialPerSec','boxIndex','sessionDurationHr'};
stitle = {'Performance','Weight','Rewards','Premature','Trial Rate','Box Index','Sess Dur'};
sylabel = {'fracValidReward','g','trials','trials','Trial/Sec','','Hr'};
nylim = {[0 1],[10 50],[0 500],[0 100],[0 40],[0 10],[0 10]};

if 0 % config 1
    h.mat(1).params.matpos = [0 0 1 1];                % [left top width height]
    h.mat(1).params.figmargin = [0.0 0 0.12 0];                % [left right top bottom]
    h.mat(1).params.matmargin = [0 0 0 0];                      % [left right top bottom]
    h.mat(1).params.cellmargin = [0.05 0.055 0.15 0.15];        % [left right top bottom]
    h.mat(1).nrow = 2;
    h.mat(1).ncol = ceil(length(fld)/h.mat(1).nrow );
    pos = [ 1362          53         553         196]
else % plot as one colume
    
    h.mat(1).params.matpos = [0 0 1 1];                % [left top width height]
    h.mat(1).params.figmargin = [0.0 0 0.12 0];                % [left right top bottom]
    h.mat(1).params.matmargin = [0 0 0 0];                      % [left right top bottom]
    h.mat(1).params.cellmargin = [0.2 0.22 0.05 0.1];        % [left right top bottom]
    h.mat(1).nrow = length(fld);
    h.mat(1).ncol = 1;
    pos = [    1717           1         198         995];
end
h.hax = [];
h.fig = figure;
set(h.fig,'Name',dpAnimal,'Position',pos...
    ,'NumberTitle','off','Visible','off') % BA watch out assuming only one mouse
for ifld = 1:length(fld)
    h.hax(end+1) =axes('Parent',h.fig);
    plot(thisDatenum,thisLog.(fld{ifld}),'parent',h.hax(end)); hold all
    title(stitle{ifld});
    ylabel(sylabel{ifld});
    nylim{ifld}(1) = min([thisLog.(fld{ifld}) nylim{ifld}(1)]);
    nylim{ifld}(2) = max([thisLog.(fld{ifld}) nylim{ifld}(2)]);
    ylim(nylim{ifld});
end


h.mat(1).h = h.hax;
for i = 1:length(h.mat)
    ind = 1:length(h.mat(i).h);
    setaxesOnaxesmatrix(h.mat(i).h,h.mat(i).nrow,h.mat(i).ncol,ind, ...
        h.mat(i).params,h.fig);
end

plotAnn(dpAnimal)
defaultAxes(h.hax,[],[],8)

linkaxes(h.hax,'x')
dynamicDateTicks(h.hax, 'link','ddd')
setDateAxes(h.hax, 'XLim', [min(thisDatenum), max(max(thisDatenum),min(thisDatenum)+10)])
%  rotateXLabels( h.hax, 60 ) % doesn't work with dynamic axis

if 1
    export_fig(fullfile(rd.Dir.SummaryFig,['LogSummary_' dpAnimal]),'-transparent','-pdf',h.fig)
    disp('saving figures.................................');
end

set(h.fig,'Visible','on')
