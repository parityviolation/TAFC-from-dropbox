function [ dataParsed ] = ss_parsedata( varargin )
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
        [~, ~, ext] = fileparts(FullPath);
        if isempty(ext) % add default extension if none exists
            FullPath = [FullPath '.txt'];
        end
        
        if isempty(slash_ndx) % add default directory if directory doesn't exist
            tempdataParsed.FullPath = FullPath   ;
            tempdataParsed = addBExptDetails(tempdataParsed); % 
            
            FullPath = fullfile(datadir,tempdataParsed.Animal,FullPath);
            slash_ndx = regexp(FullPath,slash);            
        end
        
        
        FileName = FullPath(slash_ndx(end)+1:end);
        PathName = FullPath(1:slash_ndx(end)-1);
        
    end
    dataParsed.FullPath = FullPath   ;
    dataParsed = addBExptDetails(dataParsed);
    
    
    if strcmp('2AFC',dataParsed.Protocol)
        dataParsed.Protocol = 'TAFC';
    end
    
    if isempty(dataParsed.Protocol) % BA hack
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
if strcmp('MATCHING', dataParsed.Protocol)
    trialOn_ndx = find(dataRaw(:,1)==23); %trial Initiated
elseif  strcmp('TAFC', dataParsed.Protocol)
    trialOn_ndx = find(dataRaw(:,1)==23);  % waiting for center IN
else
    trialOn_ndx = find(dataRaw(:,1)==22);
end
dataParsed.TrialNumber = 1:length(trialOn_ndx);
blockCount = 0;


% intialize field
dataParsed.controlLoop = nan(size(dataParsed.TrialNumber));
dataParsed.reDraw = nan(size(dataParsed.TrialNumber));
dataParsed.intervalIndex = nan(size(dataParsed.TrialNumber));
dataParsed.condIndex = nan(size(dataParsed.TrialNumber));

%labels = {'Left p(rwd)','Right p(rwd)','Latency','Trial onset','Reward miss','Movement time','Block number'};
length(trialOn_ndx)
for t = 1:length(trialOn_ndx)
    if t < length(trialOn_ndx)
        t_data = dataRaw(trialOn_ndx(t):trialOn_ndx(t+1)-1,:);
        
        if strcmp('WithholdingTask', dataParsed.Protocol)
            if ismember(88,t_data(:,1))
                dataParsed.TrialInit(t) = t_data(t_data(:,1)==88,2);
            else
                %                 dataParsed.TrialInit(t) = NaN;
                error('no waiting for cpoke state??? strange')
                
            end
            
        elseif strcmp('MATCHING', dataParsed.Protocol)
            if ismember(73,t_data(:,1))
                dataParsed.TrialInit(t) = t_data(t_data(:,1)==73,2);
            else
                dataParsed.TrialInit(t) = NaN;
                %              display 'Error at detecting trial initiation times: can''t find *wait_Sin* state 25'
            end
            
        elseif strcmp('BULK_big_small_tone_fix', dataParsed.Protocol)
            if ismember(56,t_data(:,1))
                dataParsed.TrialInit(t) = t_data(t_data(:,1)==56,2);
            else
                dataParsed.TrialInit(t) = NaN;
                %              display 'Error at detecting trial initiation times: can''t find *wait_Sin* state 25'
            end
            
        elseif strfind(dataParsed.Protocol, 'SelfReinf')
            if ismember(26,t_data(:,1))
                dataParsed.TrialInit(t) = t_data(t_data(:,1)==26,2);
            elseif ismember(28,t_data(:,1))
                dataParsed.TrialInit(t) = t_data(t_data(:,1)==28,2);
            else
                dataParsed.TrialInit(t) = NaN;
                %              display 'Error at detecting trial initiation times: can''t find *wait_Sin* state 25'
            end
            
        elseif strfind(dataParsed.Protocol, 'TAFCl1')
            if ismember(26,t_data(:,1))
                dataParsed.TrialInit(t) = t_data(t_data(:,1)==26,2);
            elseif ismember(28,t_data(:,1))
                dataParsed.TrialInit(t) = t_data(t_data(:,1)==28,2);
            else
                dataParsed.TrialInit(t) = NaN;
                %              display 'Error at detecting trial initiation times: can''t find *wait_Sin* state 25'
            end
            
            
            
        else
            try
            if ismember(56,t_data(:,1))
                dataParsed.TrialInit(t) = t_data(find(t_data(:,1)==56,1,'first'),2);
            else
                dataParsed.TrialInit(t) = NaN;
                %              display 'Error at detecting trial initiation times: can''t find *wait_Sin* state 25'
            end
            catch
                t
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
    
    
    if strcmp('BULK_big_small_tone_fix', dataParsed.Protocol)
        try
            dataParsed.TrialAvail(t) = t_data(t_data(:,1)==25,2);
        catch err_noState25
            display 'Error at detecting trial availability times for bulk: can''t find *wait_Lin* state 25'
        end
    end
    
    
    dataParsed.tone2Time(t)= NaN;
    if ismember(17,t_data(:,1)) % on time
        dataParsed.tone2Time(t) = t_data(t_data(:,1)==17,2);
    end
  

    dataParsed.PokeTimes.LeftIn{t} = t_data(t_data(:,1)==1,2);
    dataParsed.PokeTimes.LeftOut{t} = t_data(t_data(:,1)==9,2);
    dataParsed.PokeTimes.RightIn{t} = t_data(t_data(:,1)==2,2);
    dataParsed.PokeTimes.RightOut{t} = t_data(t_data(:,1)==10,2);
    dataParsed.PokeTimes.CenterIn{t} = t_data(t_data(:,1)==0,2);
    dataParsed.PokeTimes.CenterOut{t} = t_data(t_data(:,1)==8,2);
    
    dataParsed.firstSidePokeTime(t) = NaN;
    choiceInd = find(ismember(t_data(:,1),[26:29 38 39]),1,'first'); % correct errors and prematures
    if ~isempty(choiceInd)
        dataParsed.firstSidePokeTime(t) = t_data(choiceInd,2);
    end
    %     if  && ismember(38,t_data) && ismember(39,t_data)
    
    if dataParsed.Rev %SS 15-07-2014 to take care of files with reverse contigency (dataParsed.Rev ==1 means right - long and left - short)
        if ismember(37,t_data(:,1))
            dataParsed.Premature(t) = 1;
            dataParsed.PrematureLong(t) = 1;
            dataParsed.PrematureShort(t) = NaN;
        elseif ismember(38,t_data(:,1))
            dataParsed.Premature(t) = 1;
            dataParsed.PrematureLong(t) = 0;
            dataParsed.PrematureShort(t) = 1;
        elseif ismember(39,t_data(:,1))
            dataParsed.Premature(t) = 1;
            dataParsed.PrematureLong(t) = 1;
            dataParsed.PrematureShort(t) = 0;
        else
            dataParsed.Premature(t) = 0;
            dataParsed.PrematureLong(t) = NaN;
            dataParsed.PrematureShort(t) = NaN;
        end
        
    else
        if ismember(37,t_data(:,1))
            dataParsed.Premature(t) = 1;
            dataParsed.PrematureLong(t) = NaN;
            dataParsed.PrematureShort(t) = 1;
        elseif ismember(38,t_data(:,1))
            dataParsed.Premature(t) = 1;
            dataParsed.PrematureLong(t) = 1;
            dataParsed.PrematureShort(t) = 0;
        elseif ismember(39,t_data(:,1))
            dataParsed.Premature(t) = 1;
            dataParsed.PrematureLong(t) = 0;
            dataParsed.PrematureShort(t) = 1;
        else
            dataParsed.Premature(t) = 0;
            dataParsed.PrematureLong(t) = NaN;
            dataParsed.PrematureShort(t) = NaN;
        end
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
    elseif strcmp('BULK_big_small_tone_fix', dataParsed.Protocol)
       if ismember(38,t_data(:,1))
        dataParsed.PrematureFixation(t) = 1;
       else
        dataParsed.PrematureFixation(t) = 0;   
       end 
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
    
    % % SS Stimulation ON
    [temp ind] = ismember(t_data(:,1),1000:1049); % stimulation on codes
    ind = find(ind);
    if ~isempty(ind)
        
        if length(ind)>1 & t >1
            if strcmp('MATCHING',dataParsed.Protocol) % hack because ISI was too short so stimulation sometimes occured in the next trial
                dataParsed.stimulationOnCond(t-1) = t_data(ind(1),1)-999;
                dataParsed.stimulationOnTime(t-1) = t_data(ind(1),2);
                ind = ind(2);
            else
                error('more than one stimulation condition this trial')
            end
        end
        dataParsed.stimulationOnCond(t) = t_data(ind(1),1)-999;
        dataParsed.stimulationOnTime(t) = t_data(ind(1),2);
        
    else
        dataParsed.stimulationOnCond(t) = 0;
        dataParsed.stimulationOnTime(t) = NaN;
    end
 
        
    % % Stimulation OFF
    [temp ind] = ismember(t_data(:,1),1050:1099); % stimulation on codes
    ind = find(ind);
    if ~isempty(ind)
         if length(ind)>1 & t>1
            if strcmp('MATCHING',dataParsed.Protocol) % hack because ISI was too short so stimulation sometimes occured in the next trial
                dataParsed.stimulationOffCond(t-1) = dataParsed.stimulationOnCond(t-1);
                dataParsed.stimulationOnTime(t-1) = t_data(ind(1),2);
                ind = ind(2);
            else
                warning('more than one stimulation condition this trial')
                ind = ind(1)
            end
        end
        dataParsed.stimulationOffCond(t) = t_data(ind(1),1)-1049;
        dataParsed.stimulationOffTime(t) = t_data(ind(1),2);
        
    else
        dataParsed.stimulationOffCond(t) = 0;
        dataParsed.stimulationOffTime(t) = NaN;
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
        try
        if ismember(25,t_data) % this is sloppy but there should be only 1 occurance
            dataParsed.WaitingTimeActual(t) =   t_data(t_data(:,1)==25,2) - t_data(t_data(:,1)==73,2); % time in ms
        elseif ismember(75,t_data)   % this is sloppy but there should be only 1 occurance
            dataParsed.WaitingTimeActual(t) =   t_data(t_data(:,1)==75,2) - t_data(t_data(:,1)==73,2); % time ms
        else             dataParsed.WaitingTimeActual(t) =   NaN;
        end
        catch
            dataParsed.WaitingTimeActual(t) =   NaN;
        end
            
        if ismember(107,t_data)  % this is sloppy but there should be only 1 occurance
            dataParsed.WaitingTimeMin(t) =   t_data(find(t_data(:,1)==107,1),2) ;
        else
            dataParsed.WaitingTimeMin(t) =   NaN ;
        end
    elseif strcmp('TAFC',dataParsed.Protocol)
        
        
        if dataParsed.Rev  %SS 15-07-2014 to take care of files with reverse contigency (dataParsed.Rev ==1 means right - long and left - short)
            if ismember(26,t_data(:,1))
                dataParsed.ChoiceLeft(t) = 0; %actually means choice long
                dataParsed.ChoiceCorrect(t) = 1;
            elseif ismember(27,t_data(:,1))
                dataParsed.ChoiceLeft(t) = 1; %actually means choice long
                dataParsed.ChoiceCorrect(t) = 0;
            elseif ismember(28,t_data(:,1))
                dataParsed.ChoiceLeft(t) = 1; %actually means choice long
                dataParsed.ChoiceCorrect(t) = 1;
            elseif ismember(29,t_data(:,1))
                dataParsed.ChoiceLeft(t) = 0; %actually means choice long
                dataParsed.ChoiceCorrect(t) = 0;
            else
                dataParsed.ChoiceLeft(t) = NaN;
                dataParsed.ChoiceCorrect(t) = NaN;
            end
 
            
        else
            
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
        
        if (t+1)<=length(trialOn_ndx)
            if ismember(108,t_data(:,1))  % BA this is sloppy but there should be only 1 occurance
                dataParsed.reDraw(t+1) =   t_data(find(t_data(:,1)==108,1),2) ;
            else
                dataParsed.reDraw(t+1) =   NaN ;
            end
            
            if ismember(109,t_data(:,1))  % BA
                dataParsed.controlLoop(t+1) =   t_data(find(t_data(:,1)==109,1),2);
            else
                dataParsed.controlLoop(t+1) =   NaN ;
            end
            
            
            dataParsed.intervalIndex(t+1)= NaN;
            if ismember(120,t_data(:,1))
                dataParsed.intervalIndex(t+1) = t_data(find(t_data(:,1)==120,1,'last'),2);
            end
            dataParsed.condIndex(t+1)= NaN;
            if ismember(121,t_data(:,1))
                dataParsed.condIndex(t+1) = t_data(find(t_data(:,1)==121,1,'last'),2);
            end
        end
        
    elseif strcmp('SFI',dataParsed.Protocol)
        
        
    elseif strfind(dataParsed.Protocol, 'SelfReinf')
        
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
        
        
    elseif findstr('TAFCl3',dataParsed.Protocol)  
        
        if ismember(26,t_data(:,1))
            dataParsed.ChoiceLeft(t) = 1;
            dataParsed.ChoiceCorrect(t) = 1;
        elseif ismember(28,t_data(:,1))
            dataParsed.ChoiceLeft(t) = 0;
            dataParsed.ChoiceCorrect(t) = 1;
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
        
        %%SS for Bulk
        if ismember(122,t_data(:,1))
            dataParsed.RewardAmount(t) = t_data(find(t_data(:,1)==122,1),2);
        end
        
    elseif findstr('BULK',dataParsed.Protocol)
        if ismember(26,t_data(:,1))
            dataParsed.ChoiceLeft(t) = 1;
            dataParsed.ChoiceCorrect(t) = 1;
            dataParsed.RewardTime(t) = t_data(find(t_data(:,1)==30,1),2);
   
        elseif ismember(28,t_data(:,1))
            dataParsed.ChoiceLeft(t) = 0;
            dataParsed.ChoiceCorrect(t) = 1;
            dataParsed.RewardTime(t) = t_data(find(t_data(:,1)==30,1),2);

        else
            dataParsed.ChoiceLeft(t) = NaN;
            dataParsed.ChoiceCorrect(t) = NaN;
            dataParsed.RewardTime(t) = NaN;

        end
        
        if ismember(26,t_data(:,1)) && ismember(16,t_data(:,1))
            dataParsed.WaitDelay(t) = t_data(find(t_data(:,1)==26,1),2)-t_data(find(t_data(:,1)==16,1),2);
        else
            dataParsed.WaitDelay(t) = NaN;
        end
        
        %%SS for Bulk
        if ismember(122,t_data(:,1))
            dataParsed.RewardAmount(t) = t_data(find(t_data(:,1)==122,1),2);
        end
        
    else
        
        if ismember(26,t_data(:,1))
            dataParsed.ChoiceLeft(t) = 1;
            dataParsed.ChoiceCorrect(t) = 1;
        elseif ismember(28,t_data(:,1))
            dataParsed.ChoiceLeft(t) = 0;
            dataParsed.ChoiceCorrect(t) = 1;
        else
            dataParsed.ChoiceLeft(t) = NaN;
            dataParsed.ChoiceCorrect(t) = NaN;
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
    
end
if isfield(dataParsed,'TrialInit')
dataParsed.timeToTrialInit = [NaN diff(dataParsed.TrialInit)];
else
    dataParsed.timeToTrialInit  = NaN;
end

%%

% dataParsed = orderfields(dataParsed);
