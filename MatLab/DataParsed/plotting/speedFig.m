function handles = speedFig(dataParsed,cond)
% function hf = speedFig(dataParsed,cond)
% cond is optional, defaults to pokeIn if doesn't exist
rd = brigdefs();
bsave = 1;
lowfilt = 1; % hz
hz = dataParsed.video.info.medianFrameRate;

% rough size calibration in small mouse box assuming
%640px = 10cm
cm_px = 10/640 ;
fm_sec = round (dataParsed.video.info.meanFrameRate);
if isnan(fm_sec)
    fm_sec = 1;
    warning('dataParsed.video.info.meanFrameRate is empty');
end
WOI = [10 10];
baseline = -3;

if nargin >1
    
    if isfield(cond,'WOI')     
        WOI = cond(1).WOI;
    end
    WOI = fm_sec.*WOI;
    
    if isfield(cond,'baseline')
        
        baseline = cond(1).baseline;
    end
end
baseline = baseline*fm_sec;
baselineWOI = [0 abs(baseline)];


%% Plot formatting and init
set(0,'DefaultLineLineWidth',3)
set(0,'DefaultAxesColorOrder',[0.0078    0.6784    0.9216; 0.9569    0.1059    0.1373])
set(0,'DefaultAxesFontName','Arial')
set(0,'DefaultAxesFontSize',14)
set(0,'DefaultAxesBox','off')
set(0,'DefaultLineMarkerSize',20)

if nargin < 3
    bspeed = 0;
end

sTag = 'speed';

[~, name] = fileparts(dataParsed.FileName);
if isfield(cond(1),'filedesc')
    savfile =  [name '_' cond(1).filedesc sTag '.pdf'];
else
    savfile =  [name '_' sTag '.pdf'];
end

data = dataParsed.video.cm.speed;
if bspeed
    data = abs(data);
    data(data<20) = nan;
end
data = data* cm_px *fm_sec; % cm/sec
data =data(~isnan(data))  ;

datafilt =  filtdata(data,hz,lowfilt,'low');

if nargin ==1
    lightdur = 4;% sec
    ndx = getIndex_dp(dataParsed);
    cond(1).event = {};
    cond(1).eventdesc = {};
    cond(2).event = {};
    cond(2).eventdesc = {};
    cond(1).eventdesc{1} = 'On';
    cond(1).event{1}= dataParsed.video.pokeIn_fr(ndx.stimulation);
    cond(2).event{1}= dataParsed.video.pokeIn_fr(ndx.nostimulation);
    cond(1).eventdesc{2} = 'Off';
    cond(1).event{2}= dataParsed.video.pokeIn_fr(ndx.stimulation)+lightdur*1000;
    cond(2).event{2}= dataParsed.video.pokeIn_fr(ndx.nostimulation)+lightdur*1000;
    cond(1).color = 'b';
    cond(2).color = 'k';
    cond(1).desc = 'light';
    cond(2).desc = 'control';
    %     addStimulusBar(hAx(1),[0 min(max(get(hAx(1),'xlim')), lightdur) max(get(hAx(1),'ylim'))],'light','b')
    
end



handles.hf = figure;
set(handles.hf,'Name',[name ' ' sTag],'numberTitle','off')

% clf;
nplot = max(size(cond(1).event));
for ip = 1:nplot
    handles.hAx(ip) = subplot(3,nplot,ip);  %
    handles.hAxb(ip) = subplot(3,nplot,nplot+ip);  % baselined
    handles.hAxI(ip) = subplot(3,nplot,2*nplot+ip);  % baselined
end

xtime = [WOI(1)*-1:1:WOI(2)]*1/fm_sec;
for icond = 1:length(cond)
    for ievent = 1:length(cond(icond).event)
        
        [spdfilt skipped] = getWOI(datafilt,cond(icond).event{ievent},WOI);
        [baselinespdfilt bskipped]= getWOI(datafilt,cond(icond).event{ievent}(~skipped)+baseline,baselineWOI);
        baselinespdfilt = nanmean(baselinespdfilt,2);
        
        spdfilt = spdfilt(find(~bskipped),:);
        avg_spdfilt = nanmean(spdfilt);
        sem_spdfilt = nansem(spdfilt);      
        
        avg_spdfilt_b = nanmean(spdfilt - repmat(baselinespdfilt,1,size(spdfilt,2))); % baseline subtacted (i.e. the mean of the 3 sec before WOI)
        sem_spdfilt_b = nansem(spdfilt - repmat(baselinespdfilt,1,size(spdfilt,2)));  
 
        % integral (x - <x>0
        [spd skipped] = getWOI(data,cond(icond).event{ievent},WOI);
        avg_spd= nanmean(spd);
        cum_spd = cumsum(avg_spd - mean(avg_spd));

        [handles.hl(ievent,icond) handles.hp(ievent,icond)]= errorPatch(xtime',avg_spdfilt',sem_spdfilt',handles.hAx(ievent)); hold on;
        [handles.hlb(ievent,icond) handles.hpb(ievent,icond)]= errorPatch(xtime',avg_spdfilt_b',sem_spdfilt_b',handles.hAxb(ievent)); hold on;

        line(xtime,cum_spd,'Parent',handles.hAxI(ievent),'color',cond(icond).color)

        if isfield(dataParsed,'TTL')
            axis(handles.hAxb(:),'tight')
            ttl  = getWOI(dataParsed.TTL,cond(icond).event{ievent}(~skipped),WOI);
            yl = get(handles.hAxb(ievent),'ylim');
            line(xtime,mean(ttl)*range(yl)*.1+max(yl),'linewidth',0.1,'color',cond(icond).color,'parent',handles.hAxb(ievent));
            axis(handles.hAxb(:),'tight')
        end
        % plot the raw
        %
        %         hlall = line(repmat(xtime,size(spd,1),1)',spd','linewidth',0.1); hold on;
        %         setColor(hlall,cond(icond).color);
        % %
        if icond==1
            title(cond(1).eventdesc{ievent});
        end
        xlabel('sec')
        ylabel('speed (cm/s)')
    end
    
    setColor(handles.hl(:,icond),cond(icond).color);
    setColor(handles.hp(:,icond),cond(icond).color);
    setColor(handles.hlb(:,icond),cond(icond).color);
    setColor(handles.hpb(:,icond),cond(icond).color);
    set(handles.hl(:,icond),'linewidth',2);
    set(handles.hlb(:,icond),'linewidth',2);
    
    sleg{icond} = cond(icond).desc;
end

axis(handles.hAx(:),'tight')
axis(handles.hAxb(:),'tight')
axis(handles.hAxI(:),'tight')
legend(handles.hl(end,:),sleg);

plotAnn(name,handles.hf)
if isfield(cond(1),'notes')
plotAnn(cond(1).notes,handles.hf,1)
end
if bsave
    saveas(handles.hf, fullfile(rd.Dir.DailyFig,'Stimulation',savfile));
end