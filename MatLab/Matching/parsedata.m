function [ dataParsed ] = parsedata( varargin )
%PARSEDATA   Add condition test to create task-specific fields (such as
%interval duration, reward probabilities, block info, ...)
if isunix
    slash = '/';
else
    slash = '\';
end

if nargin==1 && isnumeric(varargin{1})
    dataParsed.FileName = 'Unknown';
    dataParsed.Animal = 'Unknown';
    dataParsed.AnimalSpecies = 'Unknown';
    dataRaw = varargin{1};
    dataParsed.RawData  = dataRaw;
    dataParsed.Protocol = 'TAFC'; % a hack
else
    if nargin==0
        [FileName,PathName] = uigetfile('*.txt','Select behavioral data file to be read');
        FullPath = [PathName FileName];
        try
            dataRaw = dlmread(FullPath);
        catch
            display 'Corrupted text file'
        end
    else
        FullPath = varargin{1};
        slash_ndx = regexp(FullPath,slash);
        FileName = FullPath(slash_ndx(end)+1:end);
        dataRaw = dlmread(FullPath);
    end
    uscore_ndx = regexp(FileName,'_');
    dataParsed.FileName = FileName;
    dataParsed.Animal = FileName(1:uscore_ndx(1)-1);
    dataParsed.AnimalSpecies = 'Unknown';
    dataParsed.RawData = dataRaw;
    try
        dataParsed.Experimenter = FileName(uscore_ndx(3)+1:end-4);
    catch
        dataParsed.Experimenter = 'Unknown';
    end
    dataParsed.Date = FileName(uscore_ndx(2)+1:uscore_ndx(2)+6); % YYMMDD
    Protocol = FileName(uscore_ndx(1)+1:uscore_ndx(2)-1);
    if ismember('v',Protocol)
        dataParsed.Protocol = Protocol(1:find(Protocol=='v')-1);
        dataParsed.ProtocolVersion = Protocol(find(Protocol=='v')+1:end);
    else
        dataParsed.Protocol = Protocol;
        dataParsed.ProtocolVersion = 'Unknown';
    end
    if strcmp('2AFC',dataParsed.Protocol)
        dataParsed.Protocol = 'TAFC';
    end
end

if strcmp('TAFC',dataParsed.Protocol)
    if any(dataRaw(:,1)==106)
        dataParsed.Scaling = dataRaw(dataRaw==106,2);
    else
        dataParsed.Scaling = 3000;
    end
end

%% Trial-based variables
% (reconst)
timeStamps_ndx = find(dataRaw(:,1)<=100 | dataRaw(:,1)>200);
dataRaw(timeStamps_ndx,2) = dataRaw(timeStamps_ndx,2)-dataRaw(timeStamps_ndx(1),2);

trialOn_ndx = find(dataRaw(:,1)==22);
dataParsed.TrialNumber = 1:length(trialOn_ndx);
blockCount = 0;

%labels = {'Left p(rwd)','Right p(rwd)','Latency','Trial onset','Reward miss','Movement time','Block number'};

for t = 1:length(trialOn_ndx)
    if t < length(trialOn_ndx)
        t_data = dataRaw(trialOn_ndx(t):trialOn_ndx(t+1),:);
        try
            dataParsed.TrialInit(t) = t_data(t_data(:,1)==25,2);
        catch err_noState25
            % display(err_noState25)
            display 'Error at detecting trial initiation times: can''t find *wait for side in* state 25'
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
    
    if any(ismember(t_data(:,1),23))
        try
            dataParsed.Latency(t) = t_data(find(t_data(:,1)==11,1),2) - t_data(find(t_data(:,1)==3,1),2);
        catch
            dataParsed.Latency(t) = nan;
        end
    end
    
    if any(ismember(t_data(:,1),61))
        dataParsed.SyncPulse(t) = t_data(t_data==61,2);
    else
        dataParsed.SyncPulse(t) = nan;
    end
    
    if strcmp('866',dataParsed.Protocol)
        
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
        
        if dataParsed.ProbRwdLeft(t) > dataParsed.ProbRwdRight(t)
            dataParsed.LeftHigh(t) = 1;
        elseif dataParsed.ProbRwdLeft(t) < dataParsed.ProbRwdRight(t)
            dataParsed.LeftHigh(t) = 0;
        else
            dataParsed.LeftHigh(t) = NaN;
        end
        
        dataParsed.BlockNumber(t) = blockCount;
        
        if ismember(83,t_data(:,1)) % 83 = laser_onset
            dataParsed.IsLaser(t) = 1;
            dataParsed.LaserDur(t) = t_data(t_data(:,1)==105,2);
        else
            dataParsed.IsLaser(t) = 0;
            dataParsed.LaserDur(t) = 0;
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
        
    elseif strcmp('SFI',dataParsed.Protocol)
        
        
    end
    
    
    %     % 8- Trial onsets
    %     matrix(t,7) = t_data(find(t_data(:,1)==22,1),2);
    %     % 9- Rwd miss
    %     if ismember(54,t_data(:,1))
    %         matrix(t,9) = 1;
    %     else
    %         matrix(t,9) = 0;
    %     end
end

%% Session-based variables

if strcmp('TAFC',dataParsed.Protocol)
    [dataParsed.Interval, dataParsed.IntervalSet, dataParsed.IntervalLong, fixcount] = roundstim(dataParsed.IntervalPrecise,dataParsed.Scaling);
    if fixcount > 0
        display(['Attention: Forced rounding needed in ' num2str(fixcount) ' trials.'])
    end
end
%%
dataParsed = orderfields(dataParsed);
end