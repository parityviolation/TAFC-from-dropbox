function dataParsed  = addTrialAvailablity_fr(dataParsed)
% function dstruct  = addTrialAvailablity_fr(dstruct)
% adds dataParsed.video.TrialAvail_fr - a vector of  frame numbers when each
% trial becomes available
%
% note if there are more trials in either the video or the behavior. trials
% are truncated to min(number trial video, number trial behavior)
no_gpio = 1;
% SS 14-03-2013
bplot = 0;
dataParsed.video.TrialAvail_fr = nan(dataParsed.ntrials,1);

rd = brigdefs();
% read file with LED intensity a vector containity intensity in each frame
[junk fname junk] = fileparts(dataParsed.FileName);
filein  = fullfile(rd.Dir.DataBonsai,dataParsed.Animal,[fname '_gpio.csv']);
if  exist(filein,'file') && no_gpio == 0
    disp([filein  ' GPIO exists!']);
    [rising junk  raw_data] = getTTLfromAnalog(filein,1);
    dataParsed.video.TrialAvail_fr = rising;
    equalizeTrials();
else
    disp([filein  ' does not exist']);
    filein  = fullfile(rd.Dir.DataBonsai,dataParsed.Animal,[fname '_led_intensity.csv']);
    if  exist(filein,'file')
        disp([filein  ' LED exists!']);
        [rising junk  raw_data] = getTTLfromAnalog(filein,0);
        dataParsed.video.TrialAvail_fr = rising;
        equalizeTrials();
    else
    
    disp([filein  ' does not exist']);
    disp('*** NO: GPIO or LED trial syncing');
    end
end

    function  equalizeTrials
        
        % check if the first poke is before first Sync (sometimes bonsai
        % starts slowly)
%          dataParsed.video.info.meanFrameRate
         
         % Estimate frame number of first Center Poke
         itrial = 1;
         bloop = 1;
         firstNTrialsMissingSync = 0;
         while (bloop)
             if ~isempty(dataParsed.PokeTimes.CenterIn{itrial}) % HACK can't look for Cpoke on protocols where Cp doesn't occure each trial..
                 
                 centerInTimes = dataParsed.PokeTimes.CenterIn{itrial}+dataParsed.RawData(1,2);
                 centerInFrame = centerInTimes(1)/1000 *dataParsed.video.info.medianFrameRate;
                 
                 if (centerInFrame < dataParsed.video.TrialAvail_fr(1) )
                     firstNTrialsMissingSync =itrial;
                     itrial = itrial +1;
                 else
                     bloop = 0;
                 end
             else
                 itrial = itrial +1;
             end
         end
         
        
          dataParsed = filtbdata_trial(dataParsed,[firstNTrialsMissingSync+1:dataParsed.totalTrials]);
        nBehavTrials = dataParsed.totalTrials;
        nframe_TrialAvailable = length(dataParsed.video.TrialAvail_fr);
        fm_diff = nBehavTrials - nframe_TrialAvailable;
        
        %check if all frames there
        if (abs(fm_diff) > 1) || bplot
            warning('Number of Behavior trials does not match the number of video trials');
            figure;
            plot(raw_data-median(raw_data));
            hold on
            plot(dataParsed.video.TrialAvail_fr,ones(1,length(dataParsed.video.TrialAvail_fr))*range(raw_data-median(raw_data))/2,'.g');
            title(['WARNING Btrials: ' num2str(nBehavTrials) ' videoTrials:' num2str(length(dataParsed.video.TrialAvail_fr))]);
        end
        
        if nframe_TrialAvailable > 50  % only if there are a good number of video trials
            % here we reduce the number of trials to trials that have
            % both video and behavior. Assuming that any missing
            % trials are from the end and not the beginning
            minTrials =  min(nBehavTrials,nframe_TrialAvailable);
            dataParsed.video.TrialAvail_fr = dataParsed.video.TrialAvail_fr(1:minTrials);
            dataParsed = filtbdata_trial(dataParsed,[1:minTrials]);
            dataParsed.behaviorTrials = nBehavTrials;
            dataParsed.removedFirstTrialsMissingSync = firstNTrialsMissingSync;  % note this trials were removed
            dataParsed.videoTrials = nframe_TrialAvailable;
        end
    end
end