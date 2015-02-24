function dp = loadBstruct(dp,bnoGui)
% function dp = loadBstruct(dp)
% Note dp can be a string with the filename of the Bstruct (path not included)

if isunix
    slash = '/';
else
    slash = '\';
end
r = brigdefs();

if nargin <2
bgui = 1;
elseif bnoGui
    bgui = 0;
end

    FullPath = [];

if nargin==1
    % check if Bstruct file exists
    [bexists FullPath] = existBstruct(dp);
    if bexists
        bgui = 0;
        disp(['******** loading existing dataparsed: ' FullPath]);        
    elseif exist(dp,'file')% behavior datafile exists so macke the struct
        bgui = 0;
        dp = builddp(1,0,dp);
    end
end

if bgui
    [FileName,PathName] = uigetfile(fullfile(r.Dir.BStruct,slash,'*.mat'),'Select Behavior Struct file to load');
    FullPath = [PathName FileName];
end

if ~isempty( FullPath)
    load(FullPath, 'dp');
end



