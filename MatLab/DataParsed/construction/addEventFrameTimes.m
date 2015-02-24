function dataParsed = addEventFrameTimes(dataParsed)
% function dataParsed = addEventFrameTimes(dataParsed)
%  This function add .choice_fr, .pokeIn_fr, .TrialAvail_fr and others

if all(isnan(dataParsed.video.framesTimes))
    dataParsed.video.pokeIn_fr = NaN;
    dataParsed.video.secondStim_fr = NaN;
    dataParsed.video.choice_fr = NaN;
    dataParsed.video.stimOn_fr = NaN;
    dataParsed.video.stimOff_fr = NaN;
    disp('*** NO: FrameTime of Events ');
    
elseif dataParsed.ntrials ~= length(dataParsed.video.TrialAvail_fr)
    dataParsed.video.pokeIn_fr = NaN;
    dataParsed.video.secondStim_fr = NaN;
    dataParsed.video.choice_fr = NaN;
    dataParsed.video.stimOn_fr = NaN;
    dataParsed.video.stimOff_fr = NaN;
    disp('*** Different number of videoTrials vs trials in dataparsed');
    disp('*** NO: FrameTime of Events ');
else
    
    framesTimes = dataParsed.video.framesTimes;
    
    tfirstVidAvail = framesTimes(dataParsed.video.TrialAvail_fr)';
    
    latency = (dataParsed.TrialInit-dataParsed.TrialAvail)/1000; %load latency and convert to seconds (relative poke in time)
    tlatency_Video = tfirstVidAvail(1:end) + latency;
    
    stimDur = dataParsed.Interval * unique(dataParsed.Scaling)/1000; %load stimulus duration
    
    tsecondStim_Video =  tlatency_Video + stimDur; %get time of the second stimulus from the video timestamps
    RT = dataParsed.ReactionTime/1000; %load RT and convert to seconds
    tChoice_Video =  tsecondStim_Video + RT; %get time of the animal's choice
    
    dataParsed.video.pokeIn_fr = nan(length(dataParsed.video.TrialAvail_fr),1);
    dataParsed.video.secondStim_fr = nan(length(dataParsed.video.TrialAvail_fr),1);
    dataParsed.video.choice_fr = nan(length(dataParsed.video.TrialAvail_fr),1);
    dataParsed.video.stimOn_fr = nan(length(dataParsed.video.TrialAvail_fr),1);
    dataParsed.video.stimOff_fr = nan(length(dataParsed.video.TrialAvail_fr),1);
    dataParsed.video.firstSidePokeTime_fr = nan(length(dataParsed.video.TrialAvail_fr),1);

    
    latency_StimOn = (dataParsed.stimulationOnTime-dataParsed.TrialAvail)/1000; %load latency and convert to seconds (relative poke in time)
    tlatency_StimOn = tfirstVidAvail(1:end) + latency_StimOn;
    latency_StimOff = (dataParsed.stimulationOffTime-dataParsed.TrialAvail)/1000; %load latency and convert to seconds (relative poke in time)
    tlatency_firstSidePokeTime = tlatency_Video +(dataParsed.firstSidePokeTime-dataParsed.TrialAvail)/1000; 
    tlatency_StimOff = tfirstVidAvail(1:end) + latency_StimOff;
    %try vectorizing t to check if it runs faster
    
    fldout = {'pokeIn_fr','secondStim_fr','choice_fr','stimOn_fr','stimOff_fr','firstSidePokeTime_fr'};
    varlatency = {tlatency_Video,tsecondStim_Video,tChoice_Video,tlatency_StimOn,tlatency_StimOff,tlatency_firstSidePokeTime};
    
    progress_bar(0, max(floor(length(tlatency_Video)/100),1), ['Trial number: '] )
    
    for i = 1: length(tlatency_Video)
        progress_bar(i/length(tlatency_Video)); % BA
        for ifield = 1 : length(fldout);
            %
            if isnan(varlatency{ifield}(i))
                dataParsed.video.(fldout{ifield})(i,1) = NaN;
            else
                
                [junk dataParsed.video.(fldout{ifield})(i,1)] = min(abs(framesTimes - varlatency{ifield}(i)));
            end
            
        end
        %e
    end
    
end


% for ease and compatablity make some redundant fields with the names
% that match those in dp
dataParsed.video.tone2Time_fr = dataParsed.video.secondStim_fr;
dataParsed.video.TrialInit_fr = dataParsed.video.pokeIn_fr;

%  ismember(dataParsed.video.secondStim_fr,dataParsed.video.framesTimes)
%  dataParsed.video.secondStim_fr