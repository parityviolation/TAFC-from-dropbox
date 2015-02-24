function [ varargout ] = ss_daily_report_SelfStim( varargin )
%daily_report Generates a session report figure
% labels = {'Trial number','Stimulus','Choice long','Correct','Latency'};
% input argument = output of reconst function;
bsave = 1;
% bPMPsyc = 0;
% bplotParam = 1;
% bforfigure = 1;  % turn this on to make a figure that can be exported as a vector

rd = brigdefs();
dstruct.dataParsed = varargin{1};

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
        
         p_left =  sum(choice_left)/length(dstruct.dataParsed.ChoiceLeft);
         p_right =  sum(choice_right)/length(dstruct.dataParsed.ChoiceRight);

        color_r = 'k'; color_l = 'k';
        if any(dataParsed.stimulationOnCond(choice_left))
            color_l = 'b';
        elseif any(dataParsed.stimulationOnCond(choice_right))
            color_r = 'b';
        end
        %% Plots of animal's choice 
        subplot(1,2,1);
        hold on; bar(0,p_right,color_r);bar(1,p_left,color_l);set(gca,'ylim',[0 1]) ;
        set(gca,'xtick',[0 1],'xtickLabel',{'right','left'})
        text(0,p_right*1.1,num2str(sum(dstruct.dataParsed.ChoiceRight)))
        text(1,p_left*1.1,num2str(sum(dstruct.dataParsed.ChoiceLeft)))
        ax(1) = gca;
        xlabel ('Trial number', 'FontSize', 10, 'FontWeight', 'bold' );
        ylabel ('Choice', 'FontSize', 10, 'FontWeight', 'bold' )
        title(['\', name]);
        
       
        %% Trial number as a function of time
        subplot(1,2,2); hold on
        trial_init = dataParsed.TrialInit(1:end-1)/60000;
        
        for a = 1:length(trial_init)
            if dstruct.dataParsed.ChoiceRight(a)==1
                plot(trial_init(a),a,'o','markeredgecolor',color_r, 'MarkerSize', 3);
                hold on
            else
                plot(trial_init(a),a,'o','markeredgecolor',color_l, 'MarkerSize', 3);
                hold on
            end
            
        end
           set(gca,'box','off','tickdir','out')
        ylabel('Trial number', 'FontSize', 10, 'FontWeight', 'bold' )
        xlabel('Time (min)', 'FontSize', 10, 'FontWeight', 'bold' )
        axis tight
        
        
        
       
        
%         %% Initiation time distribution
%         
%         it = ( dataParsed.TrialInit(1:length(dataParsed.TrialAvail(1:end-1))) - dataParsed.TrialAvail(1:end-1) )/1000;
%         subplot(3,4,7)
%         n_bins = 500;
%         hist(it, n_bins)
%         xlabel ('Initiation time (s)', 'FontSize', 10, 'FontWeight', 'bold' )
%         ylabel ('Counts', 'FontSize', 10, 'FontWeight', 'bold' )
%         set(gca,'box','off','tickdir','out')
%         axis tight
%         it_prctile = prctile(it,[0, 95]);
%         xlim(it_prctile)
%         
       
       
        
        varargout{1} = NaN;
        varargout{2} = dstruct.figure.hf;
    end

    function updatefigure(src,event)
        % Callback to parse keypress event data to print a figure
        if event.Character == 'r'
            dstruct.dataParsed = custom_parsedata(dstruct.dataParsed);
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
