function [ varargout ] = ss_daily_report_BAfig( varargin )
%daily_report Generates a session report figure
% labels = {'Trial number','Stimulus','Choice long','Correct','Latency'};
% input argument = output of reconst function;
bsave = 1;
bPMPsyc = 0;
bplotParam = 0;
bforfigure = 1;  % turn this on to make a figure that can be exported as a vector

rd = brigdefs();
dstruct = varargin{1};
dataParsed = dstruct.dataParsed;

if nargin==2
    bsplitConditions = varargin{2};
else
    bsplitConditions = 0;
end

myxtick = [0 .33 .5 .67 1];
myxticklabel = myxtick * dataParsed.Scaling(end) / 1000;
myxticklabel([1 2 4 5]) = round(myxticklabel([1 2 4 5]));

condcolor  = ['b','r'];
%% Plot formatting and init
set(0,'DefaultLineLineWidth',3)
set(0,'DefaultAxesColorOrder',[0.0078    0.6784    0.9216; 0.9569    0.1059    0.1373])
set(0,'DefaultAxesFontName','Arial')
set(0,'DefaultAxesFontSize',14)
set(0,'DefaultAxesBox','off')
set(0,'DefaultLineMarkerSize',20)


if isfield(dstruct,'figure')
    if ishandle(dstruct.figure.hf)
        clf(dstruct.figure.hf)
    end
else
    dstruct.figure.hf = figure('WindowStyle','docked');
    %     dstruct.figure.hf = figure();
end
hold on

set(dstruct.figure.hf,'KeyPressFcn',@updatefigure);
mn = initFigure(dstruct);

if bsave
    saveas(dstruct.figure.hf, fullfile(rd.Dir.DailyFig, [name '.pdf']));
end
varargout{1} = mn;
varargout{2} = dstruct.figure.hf;


    function  [varargout] = initFigure(dstruct)
        [junk, name, junk] = fileparts(dstruct.dataParsed.FileName);
        set(dstruct.figure.hf,'Name',[dstruct.dataParsed.Animal],'numberTitle','off')
        
        nr = 3; nc = 2;
        dataParsed = dstruct.dataParsed;
        
        bplotStimulation = any(dataParsed.stimulationOnCond)& bplotParam;
        try
        ndx = getIndex_dp(dataParsed);
        catch
        end
        if bsplitConditions
            dpNostim = filtbdata_trial(dataParsed,ndx.valid_nostimulation);
            dpstim = filtbdata_trial(dataParsed,ndx.valid_stimulation);
            dpNostimNoloop = filtbdata_trial(dataParsed,ndx.valid_nostimulation_nocorrectionloop);
        else
            dpNostim = dataParsed;
            dpNostimNoloop = filtbdata_trial(dataParsed,ndx.valid_nostimulation_nocorrectionloop);
            dpstim = filtbdata_trial(dataParsed,[]);
        end
        %% Trial history
        % dataParsed = dataParsed(~isnan(dataParsed.Interval),:); % Filter out invalid trials (i.e. response before beep 2)
        correct_ndx = find(dataParsed.ChoiceCorrect==1);
        incorrect_ndx = find(dataParsed.ChoiceCorrect==0);
        prem_long_ndx = find(dataParsed.PrematureLong==1);
        prem_short_ndx = find(dataParsed.PrematureLong==0);
        prem_ndx = dataParsed.Premature==1;
        rw_miss_ndx = find(dataParsed.RwdMiss==1);
        choice_miss_ndx = find(dataParsed.ChoiceMiss==1);
        stimulation_ndx = find(dataParsed.stimulationOnCond~=0);
        long_valid_ndx = find(dataParsed.ChoiceLeft==1&dataParsed.Premature==0);
        short_valid_ndx = find(dataParsed.ChoiceLeft==0&dataParsed.Premature==0);
        trial_missed_ndx = find(isnan(dataParsed.TrialInit));
        
        if bplotStimulation
            subplot(nr,nc,[1 3]), hold on
        else
            subplot(nr,nc,[1 3 5]), hold on
        end
        plot(dataParsed.Interval(correct_ndx),correct_ndx,'*g','markersize',3)
        plot(dataParsed.Interval(incorrect_ndx),incorrect_ndx,'*r','markersize',3)
        plot(dataParsed.Interval(rw_miss_ndx),rw_miss_ndx,'*','color',[.8 .8 .3],'markersize',3)
        plot(dataParsed.Interval(choice_miss_ndx),choice_miss_ndx,'*','color',[.3 .8 .8],'markersize',3)
        plot(dataParsed.PremTime(prem_long_ndx)/dataParsed.Scaling(end) ,prem_long_ndx,'*','color',[.5 .5 .5],'markersize',3);
        plot(dataParsed.PremTime(prem_short_ndx)/dataParsed.Scaling(end) ,prem_short_ndx,'*k','markersize',3);
        plot(ones(size(trial_missed_ndx)).*.5 ,trial_missed_ndx,'ok','markersize',5,'LineWidth',1);
        
        plot(dataParsed.Interval(stimulation_ndx),stimulation_ndx,'b+','markersize',3,'LineWidth',1)
        plot(dataParsed.PremTime(stimulation_ndx)/dataParsed.Scaling(end) ,stimulation_ndx,'b+','markersize',3,'LineWidth',1);
        ind = ismember(stimulation_ndx,trial_missed_ndx);
        plot(ones(size(stimulation_ndx(ind))).*.5,stimulation_ndx(ind),'b+','markersize',3,'LineWidth',1);
        
        axis([0 1 1 length(dataParsed.TrialNumber)])
        ax(1) = gca;
        set(ax(1),'box','off','tickdir','out','xtick',[0 0.5 1],'YDir','reverse','xtick',myxtick,'xticklabel',myxticklabel)
        ylabel Trial; xlabel 'Interval duration (s)'
        %axis tight
        
        % Running average of performance
        x = dataParsed.Interval;
        % x = x(~isnan(x));
        nnan = sum(~isnan(x));
        corrects = double(dataParsed.ChoiceCorrect(not(prem_ndx))==1);
        prem = double(dataParsed.Premature==1);
        kernel = ones(1,20)/20;
        
        avg = filter(kernel,1,corrects);
        avgPrem = filter(kernel,1,prem);
        avg(1:length(kernel)) = nan;
        avgPrem(1:length(kernel)) = nan;
        
        ax(2) = axes('Position',get(ax(1),'Position'),...
            'XAxisLocation','top',...
            'ytick',[],...
            'xtick',[0 .5 1],...
            'color','none',...
            'XColor',[0.0078 0.6784 0.9216]);
        xlabel 'Average performance'
        line(avgPrem,[1:length(avgPrem)],'LineWidth',3,'color',[.8 .8 .8],'Parent',ax(1));
        temp = nan(size(avg)); ind = find(not(prem_ndx)); % handle the case when the kernel is bigger than the data set
        temp(1:length(ind)) = ind;
        line(avg,temp,'LineWidth',3,'Parent',ax(1));
        line([0.5 0.5],[0 length(avg)],'linestyle',':','LineWidth',1,'Parent',ax(1));
        %% Average numbers of Premature
        if( bplotStimulation)
            hAx = subplot(nr,nc,5);
            f2 = 'stimulationOnCond';
            f1 = {'Premature','PrematureLong','ChoiceCorrect','ChoiceLeft','TrialInit'};
            cm = {'.k','+k','.g','+g','.b'};
            for ifld = 1:length(f1)
                f = compare2Fields(dataParsed,f1{ifld},f2);
                plot(f(2),f(1),cm{ifld},'MarkerSize',5); hold all
                %             ,'Color',cm(ifld,:),'Marker','.','Linestyle','none','Parent',hAx);
            end
            xlabel('Control'); ylabel('Stimulated');
            hleg = legend(f1,'Location','NorthWest');
            set(hleg,'FontSize',8,'Box','off')
            
            line([0 1],[0 1],'Color',[1 1 1].*0.3,'Parent',hAx,'LineWidth',1)
            
        end
        %% Psychometric curve
        hAx = subplot(nr,nc,[2,4]);
        [fit h] = ss_psycurve(dpNostimNoloop,1,1,hAx);
        set(h.hlraw, 'color', 'k');
        set(h.hl, 'color', 'k');
        
        if bPMPsyc
            dpPM = prematurePsycurvHelper(dataParsed);
            [fit h] = ss_psycurve(dpPM,1,1,hAx);
            set(h.hlraw, 'color', [1 1 1]*.3);
            set(h.hl, 'color', [1 1 1]*.3);
        end
        [fit h] = ss_psycurve(dpstim,1,1,hAx);
        set(h.hlraw, 'color', condcolor(1));
        set(h.hl, 'color', condcolor(1));
        
        set(hAx,'box','off','xtick',myxtick,'xticklabel',myxticklabel,'tickdir','out', 'color',[1 1 1])
        ylabel 'P(long choice)'
        
        %         ntotaltrials
        %         sigTest(data,true,hAx,sigLevel)
        %% Reaction Times
        hAx = subplot(3,2,6); hold on
        if ~bforfigure
            [rtdata h] = ss_reactime_all(dpNostimNoloop,true,hAx);
        end
        [rtdata h] = ss_reactime(dpNostimNoloop,true,hAx);
        set(h.hp(1),'Facecolor','k');
        set(h.hl(1),'color','k');
        
        if bforfigure
            delete(h.hp(1))
        end
        [rtdata h] = ss_reactime(dpstim,true,hAx);
        set(h.hp(1),'Facecolor',condcolor(1));
        set(h.hl(1),'color',condcolor(1));
        if bforfigure
            delete(h.hp(1))
        end
        set(hAx,'box','off','tickdir','out','xtick',myxtick,'xticklabel',myxticklabel, 'color',[1 1 1])
        %        set(hAx,'box','off','tickdir','out','xtick',myxtick,'xticklabel',myxticklabel,'ytick',round(linspace(max(min(min(rtdata.rt))-200,0), max(max(rtdata.rt))+200, 3)), 'color',[1 1 1])
        xlabel 'Interval duration (s)'; ylabel 'Reaction time (ms)'
        
        %% Trial onsets distribution
%         subplot(3,2,6), hold on
%         ndx = getIndex_dp(dpNostim);
%         cum_ton = dpNostim.TrialAvail/60000;
%         plot(cum_ton,[1:length(cum_ton)],'linewidth',3);
%         plot(cum_ton(ndx.incorrect),ndx.incorrect,'r+','MarkerSize',2);
%         plot(cum_ton(ndx.correct),ndx.correct,'g+','MarkerSize',2);
%         % axis([0 max(cum_ton) 1 length(dataParsed)])
%         set(gca,'box','off','tickdir','out')
%         ylabel '# of trials'; xlabel 'Time (min)'
%         axis tight
%         legend({'All' 'Errors' 'Correct'},'location','southeast');
%         legend boxoff
%         
        %%
        annotation('textbox',[.60 .5 .5 .5],'edgecolor','none','String',[dataParsed.Animal ' ' dataParsed.Date],'fontsize',20,'fontname','Arial','interpreter','none');
        
        %%
        varargout{1} = nanmean(avg);
        varargout{2} = dstruct.figure.hf;
        
    end

    function updatefigure(src,event)
        % Callback to parse keypress event data to print a figure
        if event.Character == 'r'
            dstruct.dataParsed = custom_parsedata(dataParsed);
            clf(dstruct.figure.hf);
            try
                initFigure(dstruct);
                
                if bsave
                    saveas(dstruct.figure.hf, fullfile(rd.Dir.DailyFig, [name '.pdf']));
                end
            catch ME
                getReport(ME)
            end
            
        end
    end
end