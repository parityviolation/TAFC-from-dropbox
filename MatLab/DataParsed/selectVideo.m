function [FullPathVideo, PathNameVideo] = selectVideo(dp)
% function [FullPathVideo, PathNameVideo] = selectVideo( (optional) dp)
rd = brigdefs();
videoDatadir = rd.Dir.DataVideoLoad;

bloadvideoname = 0;

if nargin ==1
    [~,FileName,~] = fileparts(dp.FileName);
    FileNameVideo = fullfile(videoDatadir,dp.Animal,[FileName '.avi']);
    if exist(FileNameVideo,'file')
        [PathNameVideo  FileNameVideo Ext] =  fileparts(FileNameVideo);
        bloadvideoname = 0;
    end
end

if bloadvideoname
    [FileNameVideo,PathNameVideo] = uigetfile(fullfile(videoDatadir,'*.avi'),'Select Video File to analyze');
end

FullPathVideo = fullfile(PathNameVideo,[FileNameVideo Ext]);



