function fullfilename = createTimestampCSV(dp,field,desc,framesAfter)
%field should be a field in dp.video

% framesAfter is the number of frames after the event with the specifc
% Timestamp that 
rd = brigdefs();

% read file with timestamps for each video frame
[~,fname,~] = fileparts(dp.FileName);

f = fopen(fullfile(rd.Dir.DataBonsaiVideo,dp.Animal,[fname '_vid_time.csv']));
a = textscan(f,'%s');
fclose(f);

fmTimes = a{:};

alignCondFrames = dp.video.(field);


% remove frameTimes that doesn't exist in Avi
if isfield(dp.video,'nframesInAvi')
    if ~isempty(dp.video.nframesInAvi)
        fmTimes = fmTimes(1:dp.video.nframesInAvi);
        alignCondFrames(alignCondFrames>dp.video.nframesInAvi) = [];  % exclude The times greater than nframesInAvi
    end
end


alignCondTimes = fmTimes(alignCondFrames(~isnan(alignCondFrames)));
alignCondTimes = cell2mat(alignCondTimes);

outputstring = alignCondTimes';

fullfilename = fullfile(rd.Dir.DataBonsaiVideo,dp.Animal,[fname '_' field '_'  desc '.csv']);

f = fopen(fullfilename,'wt');


for i = 1:size(outputstring,2)
    fprintf(f,'%s\n',outputstring(:,i));
end
fclose(f);


end