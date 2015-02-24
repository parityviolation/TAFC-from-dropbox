function [ varargout ] = ss_daily_report( varargin )
%daily_report Generates a session report figure
% labels = {'Trial number','Stimulus','Choice long','Correct','Latency'};
% input argument = output of reconst function;
bsave = 1;
bPMPsyc = 1;
bplotParam = 1;
bforfigure = 1;  % turn this on to make a figure that can be exported as a vector
bsplitAllStimCond = 0;  % split different stimulation condiations
bOnlyFirstPreMature = 1; % exclude premature events that follow previous premature events from the pscyhometric curve


rd = brigdefs();
dataParsed = varargin{1};
dstruct.dataParsed = dataParsed;

if nargin==2
    bsplitStimCond = varargin{2};
else
    bsplitStimCond = 0;
end


myxtick = [0 .33 .5 .67 1];
myxticklabel = myxtick * dataParsed.Scaling(end) / 1000;
myxticklabel([1 2 4 5]) = round(myxticklabel([1 2 4 5]));

condcolor  = ['b','r'];
%% Plot formatting and init


if nargin==3
    bdocked = varargin{3};
else
    bdocked = 1;
end

if isfield(dstruct,'figure')
    if ishandle(dstruct.figure.hf)
        clf(dstruct.figure.hf);
    end
else
    if bdocked
        dstruct.figure.hf = figure('WindowStyle','docked');
    else
        dstruct.figure.hf = figure('position',[360    78   640   844]);
    end
    %     dstruct.figure.hf = figure();
end


set( dstruct.figure.hf,'DefaultLineLineWidth',3);
set( dstruct.figure.hf,'DefaultAxesColorOrder',[0.0078    0.6784    0.9216; 0.9569    0.1059    0.1373]);
set( dstruct.figure.hf,'DefaultAxesFontName','Arial');
set( dstruct.figure.hf,'DefaultAxesFontSize',14);
set( dstruct.figure.hf,'DefaultAxesBox','off');
set( dstruct.figure.hf,'DefaultLineMarkerSize',20);

set(dstruct.figure.hf,'KeyPressFcn',@updatefigure);
mn = initFigure(dstruct);

if bsave
    saveas(dstruct.figure.hf, fullfile(rd.Dir.DailyFig, [name '.pdf']));
end
varargout{1} = mn;
varargout{2} = dstruct.figure.hf;


    function  [varargout] = initFigure(dstruct)
        [junk, name, junk] = fileparts(dstruct.dataParsed.FileName);
        set(dstruct.figure.hf,'Name',[dstruct.dataParsed.Animal  ' ' dstruct.dataParsed.FileName],'numberTitle','off')
        
        nr = 3; nc = 2;
        dataParsed = dstruct.dataParsed;
        
        bplotStimulation = any(dataParsed.stimulationOnCond)& bplotParam;
        
        try
            ndx = getIndex_dp(dataParsed);
        catch
            
        end
        
        [dpCond,dpPMCond] = getdpCond(dataParsed,bsplitStimCond,bsplitAllStimCond);
        
        
        if bOnlyFirstPreMature
            
            for i = 1:length(dpPMCond)
                if dpPMCond(i).ntrials>2
                    trials = dpPMCond(i).absolute_trial([1 find(diff(dpPMCond(i).absolute_trial)>1)+1]);
                    dpPMCond(i) = filtbdata(dpPMCond(i),0,{'absolute_trial',trials});
                end
            end
        end
        %% Trial history
        % dataParsed = dataParsed(~isnan(dataParsed.Interval),:); % Filter out invalid trials (i.e. response before beep 2)
        correct_ndx = find(dataParsed.ChoiceCorrect==1);
        incorrect_ndx = find(dataParsed.ChoiceCorrect==0);
        prem_long_ndx = find(dataParsed.PrematureLong==1);
        prem_short_ndx = find(dataParsed.PrematureLong==0);
        prem_fix_ndx = find(dataParsed.PrematureFixation==1);
        prem_ndx = dataParsed.Premature==1;
        rw_miss_ndx = find(dataParsed.RwdMiss==1);
        choice_miss_ndx = find(dataParsed.ChoiceMiss==1);
        stimulation_ndx = find(dataParsed.stimulationOnCond~=0);
        long_valid_ndx = find(dataParsed.ChoiceLeft==1&dataParsed.Premature==0);
        short_valid_ndx = find(dataParsed.ChoiceLeft==0&dataParsed.Premature==0);
        trial_missed_ndx = find(isnan(dataParsed.TrialInit));
        
        percent_correct = length(correct_ndx)/(length(correct_ndx)+length(incorrect_ndx))*100;
        percent_premature = sum(prem_ndx)/(dataParsed.ntrials)*100;
        
                dataParsed = addMovingAvg_dp(dataParsed);
biasLeft = nanmean(dataParsed.movingAvg.biasLeft);
        if bplotStimulation
            hAx = subplot(nr,nc,[1 3],'parent',dstruct.figure.hf); hold on
        else
            hAx = subplot(nr,nc,[1 3 5],'parent',dstruct.figure.hf); hold on
        end
        line(dataParsed.Interval(correct_ndx),correct_ndx,'linestyle','none','marker','*','color','g','markersize',4);
        line(dataParsed.Interval(incorrect_ndx),incorrect_ndx,'linestyle','none','marker','*','color','r','markersize',3);
        line(dataParsed.Interval(rw_miss_ndx),rw_miss_ndx,'linestyle','none','marker','*','color',[.8 .8 .3],'markersize',3);
        line(dataParsed.Interval(choice_miss_ndx),choice_miss_ndx,'linestyle','none','marker','*','color',[.3 .8 .8],'markersize',3);
        line(dataParsed.PremTime(prem_long_ndx)/dataParsed.Scaling(end) ,prem_long_ndx,'linestyle','none','marker','*','color',[.5 .5 .5],'markersize',3);
        line(dataParsed.PremTime(prem_short_ndx)/dataParsed.Scaling(end) ,prem_short_ndx,'linestyle','none','marker','*','color','k','markersize',3);
        line(ones(size(trial_missed_ndx)).*.5 ,trial_missed_ndx,'linestyle','none','marker','o','color','k','markersize',5,'LineWidth',1);
        
        line(dataParsed.Interval(stimulation_ndx),stimulation_ndx,'linestyle','none','marker','+','color','b','markersize',3,'LineWidth',1);
        line(dataParsed.PremTime(stimulation_ndx)/dataParsed.Scaling(end) ,stimulation_ndx,'linestyle','none','marker','+','color','b','markersize',3,'LineWidth',1);
        ind = ismember(stimulation_ndx,trial_missed_ndx);
        line(ones(size(stimulation_ndx(ind))).*.5,stimulation_ndx(ind),'linestyle','none','marker','+','color','b','markersize',3,'LineWidth',1);
%         
        axis([0 1 1 length(dataParsed.TrialNumber)]);
        ax(1) = gca;
        set(ax(1),'box','off','tickdir','out','xtick',[0 0.5 1],'YDir','reverse','xtick',myxtick,'xticklabel',myxticklabel);
        ylabel Trial; xlabel 'Interval duration (s)'
        title(['Cor: ' num2str(percent_correct,'%1.0f') '%  ' ...
            'PreM: ' num2str(percent_premature,'%1.0f') '% '...
            'biasL: ' num2str(biasLeft*100,'%1.0f') '% ']);
        %axis tight
        
        %% Running average of performance
        ax(2) = axes('Position',get(ax(1),'Position'),...
            'XAxisLocation','top',...
            'ytick',[],...
            'xtick',[0 .5 1],...
            'color','none',...
            'XColor',[0.0078 0.6784 0.9216],'Parent',dstruct.figure.hf);
        line([0.5 0.5],[0 length(dataParsed.TrialNumber)],'linestyle',':','LineWidth',1,'Parent',ax(1));
        
%         dataParsed = addMovingAvg_dp(dataParsed);
        
        plotRunningAvg(dataParsed,ax(1),1);
        
        
        %% Average numbers of Premature
        if( bplotStimulation)
            hAx = subplot(nr,nc,5,'parent',dstruct.figure.hf);
            f2 = 'stimulationOnCond';
            f1 = {'Premature','PrematureLong','ChoiceCorrect','ChoiceLeft','TrialInit','PrematureFixation','ChoiceMiss'};
            cm = {'ok','+k','og','+g','ob','+m','oc'};
            for ifld = 1:length(f1)
                f = compare2Fields(dataParsed,f1{ifld},f2);
                plot(f(2),f(1),cm{ifld},'MarkerSize',3); hold all
                %             ,'Color',cm(ifld,:),'Marker','.','Linestyle','none','Parent',hAx);
            end
            xlabel('Control'); ylabel('Stimulated');
            hleg = legend(f1,'Location','NorthWest');
            set(hleg,'FontSize',5,'Box','off');
            
            line([0 1],[0 1],'Color',[1 1 1].*0.3,'Parent',hAx,'LineWidth',1);
            
        end
        %% Psychometric curve
        hAx = subplot(nr,nc,2,'parent',dstruct.figure.hf);
        for icond = 1:length(dpCond)
            if dpCond(icond).ntrials
                [fit h] = ss_psycurve(dpCond(icond),1,1,hAx);
                setColor(h,dpCond(icond).plotparam.color );
                if bPMPsyc
                   [~, dpPM]= prematurePsycurvHelper(dpPMCond(icond));
                    if dpPM.ntrials
                        [fit h] = ss_psycurve(dpPM,1,1,hAx);
                        setColor(h,dpCond(icond).plotparam.color );
                        set(h.hl,'Linestyle','--');
                        set(h.hlraw,'MarkerSize',2 );
                        if bOnlyFirstPreMature
                            set(h.hl,'Linestyle',':');
                        end
                        
                    end
                end
            end
        end
        
        
        
        set(hAx,'box','off','xtick',myxtick,'xticklabel',myxticklabel,'tickdir','out', 'color',[1 1 1]);
        ylabel 'P(long choice)'
        axis square
        %         ntotaltrials
        %         sigTest(data,true,hAx,sigLevel)
        %% Reaction Times
        hAx = subplot(3,2,4,'parent',dstruct.figure.hf); hold on
        
        for icond = 1:length(dpCond)
            if dpCond(icond).ntrials
                [rtdata h] = ss_reactime(filtbdata(dpCond(icond),0,{'ChoiceCorrect',1}),true,hAx,~bforfigure);
                setColor(h,dpCond(icond).plotparam.color );
                if bforfigure
                    if isfield(h,'hp')
                        delete(h.hp(1));
                    end
                end
            end
            
        end
        set(hAx,'box','off','tickdir','out','xtick',myxtick,'xticklabel',myxticklabel, 'color',[1 1 1]);
        %        set(hAx,'box','off','tickdir','out','xtick',myxtick,'xticklabel',myxticklabel,'ytick',round(linspace(max(min(min(rtdata.rt))-200,0), max(max(rtdata.rt))+200, 3)), 'color',[1 1 1])
        xlabel 'Interval duration (s)'; ylabel 'Reaction time (ms)'
        axis square
        
        %% Trial onsets distribution
        hAx = subplot(3,2,6,'parent',dstruct.figure.hf); hold on
        dpNostim =  filtbdata_trial(dataParsed,ndx.valid); % includes correction loops
        ndx = getIndex_dp(dpNostim);
        cum_ton = dpNostim.TrialAvail/60000;
        line(cum_ton,[1:length(cum_ton)],'linestyle','none','linewidth',3);
        line(cum_ton(ndx.incorrect),ndx.incorrect,'linestyle','none','color','r','marker','+','MarkerSize',2);
        line(cum_ton(ndx.correct),ndx.correct,'linestyle','none','color','g','marker','+','MarkerSize',2);

        ndx = getIndex_dp(dataParsed);
        cum_ton = dataParsed.TrialAvail/60000;
        line(cum_ton,[1:length(cum_ton)],'linestyle','none','linewidth',1);
        line(cum_ton(ndx.prem),ndx.prem,'linestyle','none','color','k','marker','o','MarkerSize',2,'linewidth',1);
        line(cum_ton(ndx.incorrect),ndx.incorrect,'linestyle','none','color','r','marker','o','MarkerSize',2,'linewidth',1);
        line(cum_ton(ndx.correct),ndx.correct,'linestyle','none','color','g','marker','o','MarkerSize',2,'linewidth',1);
      % axis([0 max(cum_ton) 1 length(dataParsed)])
        set(gca,'box','off','tickdir','out');
        ylabel '# of trials'; xlabel 'Time (min)'
        axis tight
        legend({'All' 'Errors' 'Correct'},'location','southeast');
        legend boxoff
        
        %%
        annotation('textbox',[.60 .5 .5 .5],'edgecolor','none','String',[dataParsed.Animal ' ' dataParsed.Date],'fontsize',20,'fontname','Arial','interpreter','none');
        
        % plot a table of how much stimulation in each condition
        [Nvalid N] = getNtrialStimCond(dataParsed);
        htable = uitable('Data',Nvalid',...
            'ColumnName', [],...
            'RowName',[],...
            'Columneditable',logical(zeros(1,size(Nvalid,2))),...
            'Fontsize',5.5,...
            'Units','normalized',...
            'ColumnWidth',{12 12 12 12 12 12 12 12},'Position',[0.5 0 .15 .1]);
        
        %%
        varargout{1} = [];
        varargout{2} = dstruct.figure.hf;
        plotAnn( dstruct.dataParsed.FileName,dstruct.figure.hf);
        
    end

    function updatefigure(src,event)
        % Callback to parse keypress event data to print a figure
        bupdate = 0;
        switch(event.Character)
            case 'r'
                bupdate = 1;
            case 'S'
                dp = dstruct.dataParsed;
                performSummary = getPerformance(dp);
                
                [animalLog bfound] = addToLocalLog(performSummary,[],dp.FileName);
                
                hSummary = plotLogSummary(dp.Animal);
                bupdate = 0;
            case 'p'
                bPMPsyc = ~bPMPsyc;
                bupdate = 1;
            case 's'
                bsplitAllStimCond = ~bsplitAllStimCond;
                bupdate = 1;
            case 'c'
                bsplitStimCond = ~bsplitStimCond;
                bupdate = 1;
                
            case 'l' %load a new file
                [directory files] = getAnimalExpt(dstruct.dataParsed.Animal);
                if isunix
                    slash = '/';
                else
                    slash = '\';
                end
                [FileName,PathName] = uigetfile(fullfile(directory,slash,'*.txt'),'Select Behavior file to analyze');
                dataParsed = [PathName FileName];
                
                bupdate = 1;
            case 28 % left (LOAD OLDER FILE)
                [directory files] = getAnimalExpt(dstruct.dataParsed.Animal);
                % note files are sorted by date starting from most current
                % find the current expt
                [~, loc] =  ismember(files(:,2),dstruct.dataParsed.FileName);
                loc = find(loc);
                % the next LESS current behavioral file
                loc  = loc +1;
                if (loc) > size(files,1); % wrap to the NEWEST if this is the OLDEST current file
                    loc = 1;
                end
                
                dataParsed = fullfile(directory,files{loc,1});
                bupdate = 1;
            case 29 % right (LOAD PREVIOUS DAYS BEHAVIOR FILE)
                [directory files] = getAnimalExpt(dstruct.dataParsed.Animal);
                % note files are sorted by date starting from most current
                % find the current expt
                [~, loc] =  ismember(files(:,2),dstruct.dataParsed.FileName);
                loc = find(loc);
                % the next more current behavioral file
                loc  = loc -1;
                if (loc) <=0 % wrap to the oldest if this is the most current file
                    loc = size(files,1);
                end
                
                dataParsed = fullfile(directory,files{loc,1});
                bupdate = 1;
        end
        
        if bupdate
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