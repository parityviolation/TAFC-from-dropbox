function [ dataParsed ] = ss_parsedata_test( varargin )
%PARSEDATA   Add condition test to create task-specific fields (such as
%interval duration, reward probabilities, block info, ...)
if isunix
    slash = '/';
else
    slash = '\';
end

brigdef = brigdefs();
datadir = brigdef.Dir.DataBehav;

if  nargin==1 && isnumeric(varargin{1})  % rawData
    dataParsed.FileName = 'Unknown';
    dataParsed.Animal = 'Unknown';
    dataParsed.AnimalSpecies = 'Unknown';
    dataRaw = varargin{1};
    dataParsed.Protocol = 'TAFC'; % a hack
    dataParsed.RawData  = dataRaw;

else
    if nargin==0 || isempty(varargin{1})
        [FileName,PathName] = uigetfile(fullfile(datadir,slash,'*.txt'),'Select Behavior file to analyze');
        FullPath = [PathName FileName];
    elseif nargin==1 && isstruct(varargin{1})
        dataParsed = varargin{1};
        FullPath = dataParsed.FullPath;
        FileName = dataParsed.FileName;
        PathName = dataParsed.PathName;
    else
        FullPath = varargin{1};
        slash_ndx = regexp(FullPath,slash);
        FileName = FullPath(slash_ndx(end)+1:end);
        PathName = FullPath(1:slash_ndx(end)-1);
        
    end
    dataParsed.FullPath = FullPath   ;
    dataParsed = addBExptDetails(dataParsed);

    
    if strcmp('2AFC',dataParsed.Protocol)
        dataParsed.Protocol = 'TAFC';
    end
    
        
    dataRaw = dlmread(dataParsed.FullPath);
    dataParsed.RawData = dataRaw;

end


if any(dataRaw(:,1)==106)
    dataParsed.Scaling = dataRaw(dataRaw==106,2);
else
    dataParsed.Scaling = 3000;
end

stimCond = [];

for i=1000:1049
stimCond = vertcat(stimCond,dataRaw(dataRaw(:,1)==i,1));
end
stimCond = unique(stimCond);

%% Trial-based variables
% (reconst)
timeStamps_ndx = find(dataRaw(:,1)<=100 | dataRaw(:,1)>200);
dataRaw(timeStamps_ndx,2) = dataRaw(timeStamps_ndx,2)-dataRaw(timeStamps_ndx(1),2);

trialOn_ndx = find(dataRaw(:,1)==22);
dataParsed.TrialNumber = 1:length(trialOn_ndx);
blockCount = 0;


% intialize field
dataParsed.controlLoop = nan(size(dataParsed.TrialNumber));

%labels = {'Left p(rwd)','Right p(rwd)','Latency','Trial onset','Reward miss','Movement time','Block number'};

for t = 1:length(trialOn_ndx)
    if t < length(trialOn_ndx)
        t_data = dataRaw(trialOn_ndx(t):trialOn_ndx(t+1),:);
        
        if strcmp('WithholdingTask', dataParsed.Protocol)
            if ismember(88,t_data(:,1))
                dataParsed.TrialInit(t) = t_data(t_data(:,1)==88,2);
            else
                error('no waiting for cpoke state??? strange')             
            end
            
        elseif strcmp('MATCHING', dataParsed.Protocol)
            if ismember(73,t_data(:,1))
                dataParsed.TrialInit(t) = t_data(t_data(:,1)==73,2);
            else
                dataParsed.TrialInit(t) = NaN;
                %              display 'Error at detecting trial initiation times: can''t find *wait_Sin* state 25'
            end
            
        elseif strcmp('SelfReinf01', dataParsed.Protocol)   
            if ismember(26,t_data(:,1))
                dataParsed.TrialInit(t) = t_data(t_data(:,1)==26,2);
            elseif ismember(28,t_data(:,1))
                dataParsed.TrialInit(t) = t_data(t_data(:,1)==28,2);
            else
                dataParsed.TrialInit(t) = NaN;
                %              display 'Error at detecting trial initiation times: can''t find *wait_Sin* state 25'
            end
            
        else
            if ismember(56,t_data(:,1))
                dataParsed.TrialInit(t) = t_data(t_data(:,1)==56,2);
            else
                dataParsed.TrialInit(t) = NaN;
                %              display 'Error at detecting trial initiation times: can''t find *wait_Sin* state 25'
            end
        end
                
            
            
            
    else
        t_data = dataRaw(trialOn_ndx(t):end,:);
        dataParsed.TrialInit(t) = NaN;
    end
    
    try
        dataParsed.TrialAvail(t) = t_data(t_data(:,1)==23,2);
    catch err_noState23
        display 'Error at detecting trial availability times: can''t find *wait_Cin* state 23'
    end
    
   
    dataParsed.PokeTimes.LeftIn{t} = t_data(t_data(:,1)==1,2);
    dataParsed.PokeTimes.LeftOut{t} = t_data(t_data(:,1)==9,2);
    dataParsed.PokeTimes.RightIn{t} = t_data(t_data(:,1)==2,2);
    dataParsed.PokeTimes.RightOut{t} = t_data(t_data(:,1)==10,2);
    dataParsed.PokeTimes.CenterIn{t} = t_data(t_data(:,1)==0,2);
    dataParsed.PokeTimes.CenterOut{t} = t_data(t_data(:,1)==8,2);
    
    %     if  && ismember(38,t_data) && ismember(39,t_data)
    if ismember(37,t_data(:,1))
        dataParsed.Premature(t) = 1;
        dataParsed.PrematureLong(t) = NaN;
    elseif ismember(38,t_data(:,1))
        dataParsed.Premature(t) = 1;
        dataParsed.PrematureLong(t) = 1;
    elseif ismember(39,t_data(:,1))
        dataParsed.Premature(t) = 1;
        dataParsed.PrematureLong(t) = 0;
    else
        dataParsed.Premature(t) = 0;
        dataParsed.PrematureLong(t) = NaN;
    end
    
    
    if dataParsed.Premature(t)==1
        try
            dataParsed.PremTime(t) = t_data(ismember(t_data(:,1),[37:39 48:51]),2)-t_data(t_data(:,1)==16,2);
        catch
            dataParsed.PremTime(t) = NaN;
            display 'Error: Two premature responses detected in a single trial'
        end
    else
        dataParsed.PremTime(t) = NaN;
    end
    
  %SS for fixation protocol 
    if ismember(75,t_data(:,1))
        dataParsed.PrematureFixation(t) = 1;
    else
        dataParsed.PrematureFixation(t) = 0;
    end
    
    
    
    if ismember(40,t_data(:,1))
        dataParsed.ChoiceMiss(t) = 1;
    else
        dataParsed.ChoiceMiss(t) = 0;
    end
    
    if ismember(54,t_data(:,1))
        dataParsed.RwdMiss(t) = 1;
    else
        dataParsed.RwdMiss(t) = 0;
    end
    
    if any(ismember(t_data(:,1),[26:29]))
        try
            dataParsed.ReactionTime(t) = t_data(ismember(t_data(:,1),[26:29]),2)-t_data(t_data(:,1)==25,2); % duration of wait_Sin state
        catch
            display 'Error calculating RT: more than one choice state detected in a single trial.'
            dataParsed.ReactionTime(t) = nan;
        end
        %dataParsed.ReactionTime = t_data( find(and(ismember(t_data(:,1),[1 2]),t_data(:,2)>t_data(t_data(:,1)==17,2)),1) ,2) - t_data(t_data(:,1)==17,2); % find first side poke after 2nd beep
    else
        dataParsed.ReactionTime(t) = nan;
    end
    
    if strcmp('MATCHING',dataParsed.Protocol)
        
        if ismember(26,t_data(:,1))
            dataParsed.ChoiceLeft(t) = 1;
            dataParsed.Rewarded(t) = 1;
        elseif ismember(27,t_data(:,1))
            dataParsed.ChoiceLeft(t) = 0;
            dataParsed.Rewarded(t) = 0;
        elseif ismember(28,t_data(:,1))
            dataParsed.ChoiceLeft(t) = 0;
            dataParsed.Rewarded(t) = 1;
        elseif ismember(29,t_data(:,1))
            dataParsed.ChoiceLeft(t) = 1;
            dataParsed.Rewarded(t) = 0;
        else
            dataParsed.ChoiceLeft(t) = NaN;
            dataParsed.Rewarded(t) = NaN;
        end
        
        if ismember(101,t_data)
            blockCount = blockCount + 1;
            dataParsed.ProbRwdLeft(t) = t_data(t_data(:,1)==101,2);
            dataParsed.ProbRwdRight(t) = t_data(t_data(:,1)==102,2);
        else
            try
                dataParsed.ProbRwdLeft(t) = dataParsed.ProbRwdLeft(t-1);
                dataParsed.ProbRwdRight(t) = dataParsed.ProbRwdRight(t-1);
            catch
                dataParsed.ProbRwdLeft(t) = NaN;
                dataParsed.ProbRwdRight(t) = NaN;
            end
        end
        dataParsed.BlockNumber(t) = blockCount;
        
        if ismember(25,t_data) % this is sloppy but there should be only 1 occurance
            dataParsed.WaitingTimeActual(t) =   t_data(t_data(:,1)==25,2) - t_data(t_data(:,1)==73,2); % time in ms
        elseif ismember(75,t_data)   % this is sloppy but there should be only 1 occurance
            dataParsed.WaitingTimeActual(t) =   t_data(t_data(:,1)==75,2) - t_data(t_data(:,1)==73,2); % time ms
        else             dataParsed.WaitingTimeActual(t) =   NaN;
        end
        if ismember(107,t_data)  % this is sloppy but there should be only 1 occurance
            dataParsed.WaitingTimeMin(t) =   t_data(find(t_data(:,1)==107,1),2) ;
        else
            dataParsed.WaitingTimeMin(t) =   NaN ;
        end
    elseif strcmp('TAFC',dataParsed.Protocol)
        
        
        if ismember(26,t_data(:,1))
            dataParsed.ChoiceLeft(t) = 1;
            dataParsed.ChoiceCorrect(t) = 1;
        elseif ismember(27,t_data(:,1))
            dataParsed.ChoiceLeft(t) = 0;
            dataParsed.ChoiceCorrect(t) = 0;
        elseif ismember(28,t_data(:,1))
            dataParsed.ChoiceLeft(t) = 0;
            dataParsed.ChoiceCorrect(t) = 1;
        elseif ismember(29,t_data(:,1))
            dataParsed.ChoiceLeft(t) = 1;
            dataParsed.ChoiceCorrect(t) = 0;
        else
            dataParsed.ChoiceLeft(t) = NaN;
            dataParsed.ChoiceCorrect(t) = NaN;
        end
        
        if ismember(17,t_data(:,1)) && ismember(16,t_data(:,1))
            dataParsed.IntervalPrecise(t) = t_data(find(t_data(:,1)==17,1),2)-t_data(find(t_data(:,1)==16,1),2);
        elseif ismember(17,t_data(:,1)) && ismember(56,t_data(:,1))
            dataParsed.IntervalPrecise(t) = t_data(find(t_data(:,1)==17,1),2)-t_data(find(t_data(:,1)==56,1),2);
        else
            dataParsed.IntervalPrecise(t) = NaN;
        end
        
        if ismember(20,t_data(:,1)) && (ismember(30,t_data(:,1)) || ismember(31,t_data(:,1)))
            dataParsed.StimRwdDelay(t) = t_data(find(t_data(:,1)==30|t_data(:,1)==31,1),2) - t_data(find(t_data(:,1)==20|t_data(:,1)==4|t_data(:,1)==5|t_data(:,1)==25,1),2);
        elseif ismember(25,t_data(:,1)) && (ismember(30,t_data(:,1)) || ismember(31,t_data(:,1)))
            dataParsed.StimRwdDelay(t) = t_data(find(t_data(:,1)==30|t_data(:,1)==31,1),2) - t_data(find(t_data(:,1)==25,1),2);
        else
            dataParsed.StimRwdDelay(t) = NaN;
        end
        
        % BA new
        if ismember(85,t_data(:,1))
            dataParsed.beginStimCondBlock(t) = 1;
        else
            dataParsed.beginStimCondBlock(t) = NaN;
        end
        
        % BA new
        if ismember(86,t_data(:,1))
            dataParsed.beginPMStimCond(t) = 1;
        else
            dataParsed.beginPMStimCond(t) = NaN;
        end
        
        
        if ismember(108,t_data)  % BA this is sloppy but there should be only 1 occurance
            dataParsed.reDraw(t) =   t_data(find(t_data(:,1)==108,1),2) ;
        else
            dataParsed.reDraw(t) =   NaN ;
        end

        if ismember(109,t_data)  % BA
            if (t+1)<=length(trialOn_ndx)
                dataParsed.controlLoop(t+1) =   t_data(find(t_data(:,1)==109,1),2);
            else
                dataParsed.controlLoop(t+1) =   NaN ;
            end
        end
        
        % % SS Stimulation ON
        [temp ind] = ismember(t_data(:,1),1000:1049); % stimulation on codes
        ind = find(ind);
        if ~isempty(ind)
            if length(ind)>1 
                error('more than one stimulation condition this trial')
            end
            dataParsed.stimulationOnCond(t) = t_data(ind,1)-999;
            dataParsed.stimulationOnTime(t) = t_data(ind,2);
            
        else
            dataParsed.stimulationOnCond(t) = 0;
            dataParsed.stimulationOnTime(t) = NaN;
        end
        
        % % Stimulation OFF
        [temp ind] = ismember(t_data(:,1),1050:1099); % stimulation on codes
        ind = find(ind);
        if ~isempty(ind)
            if length(ind)>1
                error('more than one stimulation condition this trial')
            end
            dataParsed.stimulationOffCond(t) = t_data(ind,1)-1049;
            dataParsed.stimulationOffTime(t) = t_data(ind,2);
            
        else
            dataParsed.stimulationOffCond(t) = 0;
            dataParsed.stimulationOffTime(t) = NaN;
        end
        
        
    elseif strcmp('SFI',dataParsed.Protocol)
        
        
    elseif strcmp('SelfReinf01',dataParsed.Protocol)
       
         if ismember(26,t_data(:,1))
            dataParsed.ChoiceLeft(t) = 1;
            dataParsed.Rewarded(t) = 1;
            dataParsed.ChoiceRight(t) = 0;
            
        
        elseif ismember(28,t_data(:,1))
            dataParsed.ChoiceLeft(t) = 0;
            dataParsed.Rewarded(t) = 1;
            dataParsed.ChoiceRight(t) = 1;
       
         end
        
        
        % % Stimulation ON
        [temp ind] = ismember(t_data(:,1),1000:1049); % stimulation on codes
        ind = find(ind);
        if ~isempty(ind)
            if length(ind)>1 
                error('more than one stimulation condition this trial')
            end
            dataParsed.stimulationOnCond(t) = t_data(ind,1)-999;
            dataParsed.stimulationOnTime(t) = t_data(ind,2);
            
        else
            dataParsed.stimulationOnCond(t) = NaN;
            dataParsed.stimulationOnTime(t) = NaN;
        end
        
        % % Stimulation OFF
        [temp ind] = ismember(t_data(:,1),1050:1099); % stimulation on codes
        ind = find(ind);
        if ~isempty(ind)
            if length(ind)>1
                error('more than one stimulation condition this trial')
            end
            dataParsed.stimulationOffCond(t) = t_data(ind,1)-1049;
            dataParsed.stimulationOffTime(t) = t_data(ind,2);
            
        else
            dataParsed.stimulationOffCond(t) = NaN;
            dataParsed.stimulationOffTime(t) = NaN;
        end %%%
        
        
    elseif strcmp('WithholdingTask',dataParsed.Protocol)
        %Time start waiting
        idxCin = t_data(:,1)==88;
        if any(idxCin)
            dataParsed.CenterPokeIn(t) = t_data(idxCin,2);
        else
            dataParsed.CenterPokeIn(t) = NaN;
        end
        
        %Time abort waiting
        idxCout = ismember(t_data(:,1), (91:93));
        if any(idxCout)
            dataParsed.CenterPokeOut(t) = t_data(idxCout,2);
        else
            dataParsed.CenterPokeOut(t) = NaN;
        end
        
        %Duration waiting
        dataParsed.CenterPokeDur(t) = dataParsed.CenterPokeOut(t) - dataParsed.CenterPokeIn(t);
        
        %Time reward
        idxRew = ismember(t_data(:,1), [30 97]);
        if any(idxRew)
            dataParsed.WaterDeliv(t) = t_data(idxRew,2);
        else
            dataParsed.WaterDeliv(t) = NaN;
        end
        
        %Time licking
        idxLin = ismember(t_data(:,1), (94:95));
        if any(idxLin)
            dataParsed.WaterPokeIn(t) = t_data(idxLin,2);
        else
            dataParsed.WaterPokeIn(t) = NaN;
        end
        
        %Time start ITI
        idxIti = t_data(:,1) == 32;
        if any(idxIti)
            dataParsed.TimeOut(t) = t_data(idxIti,2);
        else
            dataParsed.WaterPokeIn(t) = NaN;
        end
        
        %WaitType
        if any(t_data(:,1) == 90)
            dataParsed.WaitType(t) = 3;
        elseif any(t_data(:,1) == 89)
            dataParsed.WaitType(t) = 2;
        elseif any(t_data(:,1) == 88)
            dataParsed.WaitType(t) = 1;
        else
            dataParsed.WaitType(t) = NaN;
        end
        
        %Choice
        if any(ismember(t_data(:,1), (94:96)))
            dataParsed.Choice(t) = 1;            
        elseif any(t_data(:,1)==32)
            dataParsed.Choice(t) = 3;
        end
        
        %Reward
        if any(t_data(:,1) == 97)
            dataParsed.Reward(t) = 3;
        elseif any(t_data(:,1) == 30)
            dataParsed.Reward(t) = 2;
        elseif any(t_data(:,1) == 32)
            dataParsed.Reward(t) = 1;
        else
            dataParsed.Reward(t) = NaN;
        end
        
        %T1 delay
        idxT1Delay = t_data(:,1)==111;
        if any(idxT1Delay)
            dataParsed.T1Delay(t) = t_data(idxT1Delay,2);
        end
        
        %T2 delay
        idxT2Delay = t_data(:,1)==112;
        if any(idxT2Delay)
            dataParsed.T2Delay(t) = t_data(idxT2Delay,2);
        end
        
    end
    
    
    %     % 8- Trial onsets
    %     matrix(t,7) = t_data(find(t_data(:,1)==22,1),2);
    %     % 9- Rwd miss
    %     if ismember(54,t_data(:,1))
    %         matrix(t,9) = true;
    %     else
    %         matrix(t,9) = false;
    %     end
    
    
    
    %% Session-based variables
    % isnan(dataParsed.IntervalPrecise) | isnan(dataParsed.Scaling)
    %         dataParsed.Interval = NaN;
    %         dataParsed.IntervalSet = NaN;
    %     else
end
if strcmp('TAFC',dataParsed.Protocol)
    
    if any(~isnan(dataParsed.IntervalPrecise)        )
        [dataParsed.Interval, dataParsed.IntervalSet, fixcount] = roundstim(dataParsed.IntervalPrecise, dataParsed.Scaling);
        if fixcount > 0
            display(['Attention: Forced rounding needed in ' num2str(fixcount) ' trials.'])
        end
    else
        dataParsed.Interval = NaN;
        dataParsed.IntervalSet = NaN;
        fixcount = NaN;
    end
    
    dataParsed.timeToTrialInit = [NaN diff(dataParsed.TrialInit)];
end
%%

% dataParsed = orderfields(dataParsed);
