function [dpArray h] = plot_CMByInterval(dpArray,condCell,plottype,bCorrect,options)
% function h = plot_CMByInterval(dp,plottype,bCorrect,options))

% BA
% plot CM x, y, or speed postion by interval
% stimulated and unstimulated
% can pick bCorrect to be 0, 1 or [0 1]
% plottype = 'x';
% bCorrect =1;% correct trials
rd = brigdefs();

dpArray = dpArrayInputHelper(dpArray,condCell);
dpC =concdp(dpArray);

% defaults
bsave = 1;
lowfilt = 50; % hz
windowSize =  20;% samples (frames)
windowOverlap = 5;

bIntervalGTX = 0;   % set to one to include all intervals >= plotted in each interval plot
% set to 0 to for only interval == interval in
alignToTone2 = 0;   % default align to Tone 1
cm_px = 10/640 ; % rough size calibration in small mouse box assuming
%640px = 10cm
if exist('options','var')
    if isfield(options,'alignToTone2')
        alignToTone2 = options.alignToTone2 ;
    end
    if isfield(options,'bIntervalGTX')
        bIntervalGTX = options.bIntervalGTX ;
    end
    if isfield(options,'bsave')
        bsave = options.bsave ;
    end
    if isfield(options,'lowfilt')
        lowfilt = options.lowfilt ;
    end
    if isfield(options,'windowSize')
        windowSize = options.windowSize ;
    end
    if isfield(options,'windowOverlap')
        windowOverlap = options.windowOverlap ;
    end
end
if isfield(dpC.video.info,'medianFrameRate')
    outputoptions.dt = 1/dpC.video.info.medianFrameRate;
else
    outputoptions.dt = 1/dpC.video.info.meanFrameRate;
end


if length(bCorrect) ==2
    savfileheader = 'All';
elseif bCorrect
    savfileheader = 'Correct';
else
    savfileheader = 'Error';
end

if alignToTone2
    savfileheader = [savfileheader '_Stim_StartingTone2'];
    desc = ' Tone2';
else
    savfileheader = [savfileheader '_Stim_StartingTone1'];
    desc = ' Tone1';
end
switch plottype
    case 'x'
        ylab = 'pos (cm)';
        savfileheader = [savfileheader '_X'];
    case 'y'
        ylab = 'pos (cm)';
        savfileheader = [savfileheader '_Y'];
    case 'speed'
        ylab = 'speed (cm/s)';
        savfileheader = [savfileheader '_Speed'];
    case 'theta'
        ylab = 'deg';
        savfileheader = [savfileheader '_Theta'];
end

handles.hf = figure('Name',savfileheader,'Position',  [779         540        1132         457]);
listIntv = [1: length( dpC.IntervalSet)];
nr = 2;
nc = length(listIntv)/nr;
for iIntv = 1:length(listIntv)
    Intv = dpC.IntervalSet(listIntv(iIntv));
    
    cond(1).filedesc =[savfileheader ' ' num2str(Intv)];
    
    cond(1).notes = cond(1).filedesc ; % for plotAnn
    % cond(1).WOI = [1 dpC.IntervalSet(5)*dpC.Scaling/1000];
    cond(1).WOI = [1 Intv*dpC.Scaling/1000];
    cond(1).baseline = 0.1;
    if bIntervalGTX
        cond(1).filter={'ChoiceCorrect',bCorrect,'Interval',@(x) x >= Intv,'stimulationOnCond',@(x) x~=0};
    else
        cond(1).filter={'ChoiceCorrect',bCorrect,'Interval',Intv,'stimulationOnCond',@(x) x~=0};
    end
    tempdp = filtbdata(dpC,0,cond(1).filter);
    if alignToTone2
        cond(1).event{1} = tempdp.video.secondStim_fr; % inframes
    else
        cond(1).event{1} = tempdp.video.pokeIn_fr; % inframes
    end
    if bIntervalGTX
        cond(1).eventdesc{1} = '>=';
    else
        cond(1).eventdesc{1} = '';
    end
    cond(1).eventdesc{1} = [cond(1).eventdesc{1} num2str(Intv) desc];
    cond(1).line = quantile(tempdp.video.choice_fr-tempdp.video.pokeIn_fr,.5) ;% median choice time (frames)
    cond(1).lineTone2 = Intv*tempdp.Scaling/1000 ;% median choice time (frames)
    cond(1).color = 'b';
    cond(1).desc = 'light';
    cond(2).color = 'k';
    cond(2).desc = 'control';
    if bIntervalGTX
        cond(2).filter = {'ChoiceCorrect',bCorrect,'Interval',@(x) x >= Intv*0.999,'stimulationOnCond',0};
    else
        cond(2).filter = {'ChoiceCorrect',bCorrect,'Interval',Intv,'stimulationOnCond',0};
    end
    tempdp = filtbdata(dpC,0,cond(2).filter);
    cond(2).line = quantile(tempdp.video.choice_fr-tempdp.video.pokeIn_fr,.5); % median choice time (frames)
    if alignToTone2
        cond(2).event{1} = tempdp.video.secondStim_fr; % inframes
    else
        cond(2).event{1} = tempdp.video.pokeIn_fr; % inframes
    end
    
    hz = dpC.video.info.medianFrameRate ;
    fm_sec = round (dpC.video.info.medianFrameRate);
    
    switch plottype
        case 'x'
            data =  dpC.video.cm.xy(:,1); % dpC.video.cm.speed;
            data = data* cm_px ; % cm
            outputoptions.bootfun = @nanmedian;
        case 'y'
            data =  dpC.video.cm.xy(:,2); % dpC.video.cm.speed;
            data = data* cm_px ; % cm
            outputoptions.bootfun = @nanmedian;
        case 'speed'
            data =  dpC.video.cm.speed;
            data = data* cm_px *fm_sec; % cm/sec
            outputoptions.bootfun = @nanmedian;
        case 'theta'
            data =  dpC.video.extremes.thetaParsed;
            data = data* cm_px *fm_sec; % cm/sec
            outputoptions.bootfun = @nanmedian;
    end
    data =data(~isnan(data)) ;
    datafilt = filtdata(data,hz,lowfilt,'low');
    
    WOI = cond(1).WOI;
    WOI = floor(fm_sec.*WOI);
    WOI = WOI + [0 windowSize]; % This means that some data points after the tone will be included but the window including the tone will exist
    xtime = [WOI(1)*-1:1:(WOI(2))]*1/fm_sec;
    
    outputoptions.xOffset = xtime(1);
    hAx(iIntv) = subplot(nr,nc,iIntv); % speed
    %     hAx(2) = subplot(2,nc,nc+iIntv); % speed
    clear spdfilt sleg
    for ievent = 1:length(cond(1).event)
        for icond = 1:length(cond)
            spdfilt{icond,ievent} = 0;
            if ~isempty(cond(icond).event{ievent})
                [spdfilt{icond,ievent} skipped] = getWOI(datafilt,cond(icond).event{ievent},WOI);
                
                if size(spdfilt{icond,ievent},1)>1
                    avg_spdfilt = (nanmedian(spdfilt{icond,ievent}));
                    sem_spdfilt = (nansem(spdfilt{icond,ievent}));
                end
                % plot time of median choice
                try
                    line([1 1]*xtime(round(cond(icond).line)),[0 max(ylim)],'color',cond(icond).color,'linewidth',1);
                end
            end
            sleg{icond} = [cond(icond).desc ' n=' num2str(size(spdfilt{icond,ievent},1))];
            outputoptions.color{icond}  =cond(icond).color;
        end
        outputoptions.hAx =hAx(iIntv) ;
        btempplot = 1;
        if size(spdfilt{1,ievent}' ,2) <=1|| size(spdfilt{2,ievent}' ,2) <=1 ==1 % check there is more at least to trials 
            btempplot = 0;
        end
        if btempplot
            h = plot_significanceMovingWindow(spdfilt{1,ievent}',spdfilt{2,ievent}',windowSize,windowOverlap,outputoptions);
        end
    end
    
    
    if btempplot
        try
            
            if ~alignToTone2
                line([1 1]*cond(1).lineTone2,[0 max(ylim)],'color','k','linewidth',1);
                text(cond(1).lineTone2,0,'Tone2','rotation',90);
            end
            text(xtime(round(cond(1).line)),0,'median choice','rotation',90);
            
        end
        axes(hAx(iIntv));
        xlabel('sec'); ylabel(ylab)
        title(cond(1).eventdesc{ievent});
        axis(hAx(iIntv),'tight')
        hleg =  legend(h.hl(1:2),sleg,'Fontsize',7);
        defaultlegend(hleg,'NorthEast',6)
        
    end
    
end

switch plottype
    case 'speed'
        set(hAx,'ylim',[ 0 max(cellfun(@max,get(hAx,'ylim')))])
    otherwise
        set(hAx,'ylim',[  min(cellfun(@min,get(hAx,'ylim'))) max(cellfun(@max,get(hAx,'ylim')))])
end


setAxEq(hAx,'x');
if length(listIntv) >1 % ugly
    cond(1).filedesc =[savfileheader '_MultiIntv'];
else
    if isfield(cond(1),'notes')
        plotAnn(cond(1).notes,handles.hf,1)
    end
end


% [~, name] = fileparts(dpC.FileName);
name =  dpC(1).collectiveDescriptor ;
savfile = [name cond(1).filedesc ];
% plotAnn(name,handles.hf)
plotAnn(name ,handles.hf)
plotAnn(cond(1).filedesc ,handles.hf,1)
set(handles.hf ,'Name',savfile);
if bsave
    orient landscape
    patht = fullfile(rd.Dir.CM,dpC.Animal,dpC.Date);
    parentfolder(patht,1)
    %     export_fig(handles.hf, fullfile(patht,[savfile]),'-pdf','-transparent');
    saveas(handles.hf, fullfile(patht,[savfile '.fig']));
    plot2svg( fullfile(patht,[savfile '.svg']),handles.hf); % THIS WORKS for transparency!!!
end

%%
