function [ varargout ] = ss_daily_report_TAFCl2( varargin )
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
        
        %% Plot of animal's trial initiation times 
        hold on
        cum_ton = dataParsed.TrialAvail/60000;
        plot(cum_ton,[1:length(cum_ton)],'linewidth',3);
        set(gca,'box','off','tickdir','out')
        ylabel ' # of Rewarded trials'; xlabel 'Time (min)'
        axis tight
        
        

       
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
