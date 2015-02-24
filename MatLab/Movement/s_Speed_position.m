%dp = loadBStruct;
bDoNotLoadVideoData = 0;
name = 'sert864_lgcl';
[exptnames trials] = getStimulatedExptnames(name);
dpArray = constructDataParsedArray(exptnames, trials,bDoNotLoadVideoData);
dp =concdp(dpArray);
dp.Date = name;

%%
% plots speed and cumspeed for two different dps (correct/incorrect) or
% stimulated/unstimulated usually
rd = brigdefs();
bsave = 1;

alignToTone2 = 0;

if alignToTone2
    savfileheader = 'Correct_Stim_StartingTone2';
    desc = ' Tone2';
else
    savfileheader = 'Correct_Stim_StartingTone1';
      desc = ' Tone1';
end
handles.hf = figure(1);clf
listIntv = [1:6];
nc = length(listIntv);
for iIntv = 1:length(listIntv)
    Intv = dp.IntervalSet(listIntv(iIntv));
    
    cond(1).filedesc =[savfileheader ' ' num2str(Intv)];

    cond(1).notes = cond(1).filedesc ; % for plotAnn
    % cond(1).WOI = [1 dp.IntervalSet(5)*dp.Scaling/1000];
    cond(1).WOI = [0 1.5];
    cond(1).baseline = 0.1;
    tempdp = filtbdata(dp,0,{'ChoiceCorrect',1,'Interval',Intv,'stimulationOnCond',1});
   % cond(1).event{1} = tempdp.video.secondStim_fr; % inframes
    cond(1).event{1} = tempdp.video.pokeIn_fr; % inframes
    cond(1).eventdesc{1} = [num2str(Intv) desc];
    cond(1).line = quantile(tempdp.video.choice_fr-tempdp.video.pokeIn_fr,.5) ;% median choice time (frames)
    cond(1).lineTone2 = Intv*tempdp.Scaling/1000 ;% median choice time (frames)
    cond(1).color = 'b';
    cond(1).desc = 'light';
    cond(2).color = 'k';
    cond(2).desc = 'control';
    tempdp = filtbdata(dp,0,{'ChoiceCorrect',1,'Interval',Intv,'stimulationOnCond',0});
   % cond(2).event{1} = tempdp.video.secondStim_fr; % inframes
    cond(2).line = quantile(tempdp.video.choice_fr-tempdp.video.pokeIn_fr,.5); % median choice time (frames)
    cond(2).event{1} = tempdp.video.pokeIn_fr; % inframes
    
    
    lowfilt = 1; % hz
    hz = dp.video.info.meanFrameRate ;
    % rough size calibration in small mouse box assuming
    %640px = 10cm
    cm_px = 10/640 ;
    fm_sec = round (dp.video.info.meanFrameRate);
    
    
    data = dp.video.cm.speed;
    data = data* cm_px *fm_sec; % cm/sec
    data =data(~isnan(data)) ;
    datafilt = filtdata(data,hz,15,'low');
    
    WOI = cond(1).WOI;
    WOI = fm_sec.*WOI;
    xtime = [WOI(1)*-1:1:WOI(2)]*1/fm_sec;
    
    
    
    
    hAx(1) = subplot(2,nc,iIntv); % speed
    hAx(2) = subplot(2,nc,nc+iIntv); % speed
    for icond = 1:length(cond)
        for ievent = 1:length(cond(icond).event)
            spdfilt = 0;
            if ~isempty(cond(icond).event{ievent})
                [spdfilt skipped] = getWOI(datafilt,cond(icond).event{ievent},WOI);
                
                avg_spdfilt  = spdfilt;
                if size(spdfilt,1)>1
                    avg_spdfilt = (nanmedian(avg_spdfilt));
                    sem_spdfilt = (nansem(spdfilt));
                end
                %         line(xtime,spdfilt,'Parent',gca,'color',cond(icond).color,'linewidth',0.1)
                [hltemp hp] = errorpatch(xtime',avg_spdfilt',sem_spdfilt,hAx(1)); hold on
                set(hltemp,'LineWidth',2)
                setColor([hp hltemp],cond(icond).color);
                [hl(icond)] = line(xtime',cumsum(avg_spdfilt),'Parent',hAx(2)); hold on
                setColor([hl(icond)],cond(icond).color);
                               
                % plot time of median choice
                try
                    line([1 1]*xtime(round(cond(icond).line)),[0 max(ylim)],'color',cond(icond).color,'linewidth',1);
                end
            end
        end
        sleg{icond} = [cond(icond).desc ' n=' num2str(size(spdfilt,1))];
    end
    
    try
        if ~alignToTone2
            line([1 1]*cond(1).lineTone2,[0 max(ylim)],'color','k','linewidth',1);
            text(cond(1).lineTone2,0,'Tone2','rotation',90);
        end
        text(xtime(round(cond(1).line)),0,'median choice','rotation',90);
    end
    legend(hl,sleg,'Location','NorthWest','Fontsize',7)
    axes(hAx(1));
    xlabel('sec'); ylabel('speed (cm/s)')
    title(cond(1).eventdesc{ievent});
    axis(hAx,'tight')
    
end

if length(listIntv) >1 % ugly
    cond(1).filedesc =[savfileheader '_MultiIntv'];
else
    if isfield(cond(1),'notes')
        plotAnn(cond(1).notes,handles.hf,1)
    end
end
[~, name] = fileparts(dp.FileName);
savfile = [name cond(1).filedesc ];
plotAnn(name,handles.hf)

if bsave
    orient landscape
    patht = fullfile(rd.Dir.CM,dp.Animal,dp.Date);
    parentfolder(patht,1)
    saveas(handles.hf, fullfile(patht,[savfile '.pdf']));
    saveas(handles.hf, fullfile(patht,[savfile '.fig']));
end
% %%
% data = dp.video.cm.xy;
% data = data* cm_px; % cm/sec
% data =data(~isnan(data(:,1)),:) ;
% datafilt = data;% filtdata(data,hz,lowfilt,'low');
% 
% 
% hAx(2) = subplot(3,1,2); cla; % position
% for icond = 1:length(cond)
%     
%     hAxPos.hsp(icond) = subplot(4,nc,nc+icond); % position
%     
%     for ievent = 1:length(cond(icond).event)
%         [x] = getWOI(datafilt(:,1),cond(icond).event{ievent},WOI);
%         [y] = getWOI(datafilt(:,2),cond(icond).event{ievent},WOI);
%         avg_xfilt = nanmean(x);
%         sem_xfilt = nansem(x);
%         avg_yfilt = nanmean(y);
%         sem_yfilt = nansem(y);
%         %hl = line(x',y','Parent',gca,'color',cond(icond).color,'linewidth',0.1);hold on;
%        hl = plot3(avg_xfilt,avg_yfilt,xtime,'Parent',gca,'color',cond(icond).color);hold on;
% %         [hl hp] = errorpatch(avg_xfilt',avg_yfilt',sem_xfilt',sem_yfilt',hAx(2));
%         setColor([hl hp],cond(icond).color);
%         if icond==1
%             title([cond(1).eventdesc{ievent} ' ' num2str( WOI(2)/fm_sec) 's']);
%         end
%         xlabel('cm')
%         ylabel('cm')
% 
%          hl = plot3(avg_xfilt(1),avg_yfilt(1),xtime(1),'Marker','o','Parent',gca,'color',[1 1 1]*0.5);hold on;
% 
% 
%     end
% end
% axis(hAx(:),'tight')
% % speedFig(dp,cond)
% 
% hAxPos.h = figure;
% set(hAxPos.h,'Position',[ 642          77        1095         901])
% 
% 
% hAx(2) = subplot(3,2,3); cla; % position
% for icond = 1:length(cond)
%     for ievent = 1:length(cond(icond).event)
%         [x ] = getWOI(datafilt(:,1),cond(icond).event{ievent},WOI);
%         [y ] = getWOI(datafilt(:,2),cond(icond).event{ievent},WOI);
%         avg_xfilt = nanmean(x);
%         sem_xfilt = nansem(x);
%         avg_yfilt = nanmean(y);
%         sem_yfilt = nansem(y);
% %         hl = line(x',y','Parent',gca,'color',cond(icond).color,'linewidth',0.1)
%         hl = line(avg_xfilt,avg_yfilt,'Parent',gca,'color',cond(icond).color)
% %         [hl hp] = errorpatch(avg_xfilt',avg_yfilt',sem_xfilt',sem_yfilt',hAx(2));
%         setColor([hl hp],cond(icond).color);
%         if icond==1
%             title([cond(1).eventdesc{ievent} ' ' num2str( WOI(2)/fm_sec) 's']);
%         end
%         xlabel('cm')
%         ylabel('cm')
%                 hl = line(avg_xfilt(1),avg_yfilt(1),'Marker','o','Parent',gca,'color',[1 1 1]*0.5);hold on;
% 
%     end
% end
% axis(hAx(2),'tight')
% % speedFig(dp,cond)

%%


