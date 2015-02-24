function [ varargout ] = ss_daily_report_TAFCl3( varargin )
%daily_report Generates a session report figure
% labels = {'Trial number','Stimulus','Choice long','Correct','Latency'};
% input argument = output of reconst function;
bsave = 1;
% bPMPsyc = 0;
% bplotParam = 1;
% bforfigure = 1;  % turn this on to make a figure that can be exported as a vector

rd = brigdefs();
dataParsed = varargin{1};
dstruct.dataParsed = dataParsed;
% if nargin==2
%     bsplitConditions = varargin{2};
% else
%     bsplitConditions = 0;
% end

if nargin==3
    bdocked = varargin{3};
else
    bdocked = 1;
end

if isfield(dstruct,'figure')
    if ishandle(dstruct.figure.hf)
        clf(dstruct.figure.hf)
    end
else
    if bdocked
        dstruct.figure.hf = figure('WindowStyle','docked');
    else
        dstruct.figure.hf = figure('position',[360    78   640   844]);
    end
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
        
        dataParsed = dstruct.dataParsed;
        %% Delete last trial; Reward and choice computations
        
        choice_left = dataParsed.ChoiceLeft(1:end-1) == 1;
        choice_right = dataParsed.ChoiceLeft(1:end-1) == 0;
        
        
        
        
        color_r = 'r'; color_l = 'b';
       
        %% Plot of animal's trial initiation times 
       subplot(1,3,1), hold on
        cum_ton = dataParsed.TrialAvail/60000;
        ndx.premature = find(isnan(dataParsed.ChoiceCorrect));
        ndx.correct = find(dataParsed.ChoiceCorrect==1);
        plot(cum_ton,[1:length(cum_ton)],'linewidth',3);
        plot(cum_ton(ndx.premature),ndx.premature,'r+','MarkerSize',2);
        plot(cum_ton(ndx.correct),ndx.correct,'g+','MarkerSize',2);
        % axis([0 max(cum_ton) 1 length(dataParsed)])
        set(gca,'box','off','tickdir','out')
        ylabel '# of trials'; xlabel 'Time (min)'
        axis tight
        legend({'All' 'Premature' 'Correct'},'location','southeast');
        legend boxoff
        
      %% Plot of animal's waiting times 
       subplot(1,3,2), hold on   
       plot(dataParsed.IntervalPrecise(~isnan(dataParsed.IntervalPrecise)))
       set(gca,'box','off','tickdir','out')
       ylabel 'Waiting time (ms)'; xlabel 'trials'
       axis tight
       
       
       %% Plot of animal's waiting times
       subplot(1,3,3), hold on
       kernel = ones(1,10)/10;
       ind = ~isnan(dataParsed.ChoiceLeft);
       cleft = dataParsed.ChoiceLeft(ind);
       avg = filter(kernel,1,cleft);
       avg(1:length(kernel)) = nan;
       trial = find(ind);
       line(trial,avg,'LineWidth',3,'color','k');
       title('Bias')
       set(gca,'box','off','tickdir','out')
       ylabel 'P(Left)'; xlabel 'trials'
       axis tight

       
       
       
        varargout{1} = NaN;
        varargout{2} = dstruct.figure.hf;
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
