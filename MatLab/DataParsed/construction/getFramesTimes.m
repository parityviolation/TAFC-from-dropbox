function dataParsed = getFramesTimes(dataParsed,filein)
% function dataParsed = getFramesTimes(dataParsed)
%  This function gets the timestamps for each frame in the video file
% and adds the dataParsed.video.framesTimes

% filein = 'C:\Users\User\Desktop\testBonsai\timestamp1.csv'

rd = brigdefs();
buigetfile = 1;
if nargin <2
    buigetfile = 0;
    % read file with timestamps for each video frame
    [~, fname, ~] = fileparts(dataParsed.FileName);
    filein = fullfile(rd.Dir.DataBonsaiVideo,dataParsed.Animal,[fname '_vid_time.csv']);
end


if ~exist(filein,'file') && buigetfile
    [FileName,PathName] = uigetfile(filein,'Select CSV file frameTimes');
    filein = [PathName FileName];    
end

dataParsed.video.framesTimes = NaN;

if exist(filein,'file')
    f = fopen(filein);
    a = textscan(f,'%11c %16c %6c');
    if isempty(a{1})
        error('file is empty')
    end
    fclose(f);
    
    initial_hour = str2double(a{2}(1,1:2));
    
    temp  = cell2mat(a(2));
    time_sec = (str2num(temp(:,1:2))-initial_hour)*60*60; % convert hours to secs
    time_sec = time_sec + str2num(temp(:,4:5))*60; % convert minutes to secs
    time_sec = time_sec + str2num(temp(:,7:16));
    dataParsed.video.framesTimes = time_sec;

else
    disp([filein  ' does not exist'])
    disp('*** NO: Video Frame times');

end

