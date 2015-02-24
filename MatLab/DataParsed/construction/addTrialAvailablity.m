function dstruct  = addTrialAvailablity(dstruct)
bplot = 1;
LED_intensity_threshold = 90000; % USER set may vary from FIND BETTEr way?

rd = brigdefs();
% read file with LED intensity a vector containity intensity in each frame
[junk fname junk] = fileparts(dstruct.filename);
raw_data = dlmread(fullfile(rd.Dir.DataBonsai,[fname '_led_intensity.csv']),' ');
raw_data = raw_data(:,1); % get just the grayscale intensity
%
thesh_intensity=find(raw_data>=LED_intensity_threshold);
frame_TrialAvailable = notsync(thesh_intensity,thesh_intensity,-5,-.5);

    nBehavTrials = size(dstruct.matrix,1);
if bplot
    figure
    plot(raw_data)
    hold on
    plot(frame_TrialAvailable,ones(1,length(frame_TrialAvailable)),'.g')
    title(['Btrials: ' num2str(nBehavTrials) ' videoTrials:' num2str(length(frame_TrialAvailable))])
end


dstruct.TrialAvail_fr = frame_TrialAvailable;

% check if all frames there
if (nBehavTrials~=length(frame_TrialAvailable))
    warning('Number of Behavior trials does not match the number of video trials')
end

end