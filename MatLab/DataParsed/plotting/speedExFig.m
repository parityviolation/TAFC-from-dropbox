function hf = speedExFig(dataParsed,bavg)
%% velocity of extreme

if nargin <2
    bavg = 1;
end
rd = brigdefs();

bsave = 1;
lightdur = 4;% sec
cm_px = 10/640 ;
len = 299;

% Plot formatting and init
set(0,'DefaultLineLineWidth',3)
set(0,'DefaultAxesColorOrder',[0.0078    0.6784    0.9216; 0.9569    0.1059    0.1373])
set(0,'DefaultAxesFontName','Arial')
set(0,'DefaultAxesFontSize',14)
set(0,'DefaultAxesBox','off')
set(0,'DefaultLineMarkerSize',20)


[junk, name, junk] = fileparts(dataParsed(1).FileName);
savfile =  [name '_Ex_speed.pdf'];
        hf = figure;
iExptWvideo = 0;
nExpt = length(dataParsed);
for iExpt = 1:nExpt
    thisdp = dataParsed(iExpt);
    if isstruct(thisdp.video)
        iExptWvideo =iExptWvideo +1;
        fm_sec = round (thisdp.video.info.meanFrameRate);
        data = squeeze(sqrt(diff(thisdp.video.extremes(:,:,1),1,2).^2+diff(thisdp.video.extremes(:,:,2),1,2).^2));
        
        data = data* cm_px *fm_sec; % cm/sec
        if iExptWvideo ==1 % all experiments must have same frame rate
            xtime = [1:len]'*1/fm_sec;
        end
        
        
        ndx = getIndex_dp(thisdp);
        cond(1).ndx = ndx.stimulation;
        cond(1).eventdesc = {};
        cond(2).ndx = ndx.nostimulation;
        cond(2).eventdesc = {};
        cond(1).color = 'b';
        cond(2).color = 'k';
        cond(1).desc = 'light';
        cond(2).desc = 'control';
        

        set(hf,'Name',[name ' ' 'Extremum velocity'],'numberTitle','off')
        
        % clf;
        hAx(1) = subplot(1,1,1);
        % hAx(2) = subplot(1,2,2);
        
  
        for icond = 1:length(cond)
            
            temp = nanmean(data(cond(icond).ndx,1:len));
            sem_temp = nansem(data(cond(icond).ndx,1:len));
            kernel = ones(1,25)/25;
            smooth_temp(icond,iExptWvideo,:) = filter(kernel,1,temp);
            smooth_sem(icond,iExptWvideo,:) = filter(kernel,1,sem_temp);
            
            if ~bavg
                
                [hl hp]= errorPatch(xtime,smooth_temp(icond,iExptWvideo,:),smooth_sem(icond,iExptWvideo,:),hAx(1));
                
                %         h(ievent) = line(xtime,temp,'parent',hAx(ievent)); hold on;
                setColor(hl,cond(icond).color);
                setColor(hp,cond(icond).color);
                set(hl,'linewidth',2);
            end
            
            sleg{icond} = cond(icond).desc;
        end
    end
    
end
if bavg
    
    for icond = 1:length(cond)
        
        mspeed = nanmean(squeeze(smooth_temp(icond,:,:)));
        semspeed = nansem(squeeze(smooth_temp(icond,:,:)));
        
        [hl hp]= errorPatch(xtime,mspeed,semspeed,hAx(1));
        
        %         h(ievent) = line(xtime,temp,'parent',hAx(ievent)); hold on;
        setColor(hl,cond(icond).color);
        setColor(hp,cond(icond).color);
        set(hl,'linewidth',4);
        
    end
end
xlabel('sec')
ylabel('speed (cm/s)')

legend(hl,sleg);
addStimulusBar(hAx(1),[0 min(max(get(hAx(1),'xlim')), lightdur) max(get(hAx(1),'ylim'))],'light','b')


plotAnn(name)

if bsave
    saveas(hf, fullfile(rd.Dir.DailyFig,'Stimulation',savfile));
end