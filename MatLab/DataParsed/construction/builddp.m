function dp = builddp(brecomputeDP,bDoNotLoadVideoData,varargin)
% function dp = builddp(brecomputeDP,bDoNotLoadVideoData,varargin)
if nargin ==0
    brecomputeDP = 0; % if 1  reload dp
end

if nargin <2
    bDoNotLoadVideoData = 0; % if 1  reload video csv files
end
bsave = 0;
if ~bDoNotLoadVideoData
    bsave = 1;
end
if brecomputeDP
    dp = helper(bDoNotLoadVideoData,varargin{:});
else
    [bexists FullPath] = existBstruct(varargin{:});
    if bexists
        dp= loadBstruct(varargin{:});
        bsave = 0;
    else
        dp = helper(bDoNotLoadVideoData,varargin{:});
    end
end

if bsave
    saveBstruct(dp);
end


function dp = helper(bDoNotLoadVideoData,varargin)
dp = custom_parsedata(varargin{:});

if ~bDoNotLoadVideoData
    disp('******** adding Video Frame times');
    dp = getFramesTimes(dp);            % frame times of video (and LED intensity)
    dp = addVideoInfo(dp);
    disp('******** adding LED trial syncing');
    dp  = addTrialAvailablity_fr(dp);   % read LED intensity file synced with trial availablity
    disp('******** adding FrameTime of Events');
    dp = addEventFrameTimes(dp);        % add event times of events like pokeIn 2nd beep etc
    disp('******** adding Position of QR');
    dp = addBonsaiMarker(dp);
    disp('******** adding Reference QR');
    nReferenceMarker = 3;
    dp = addQR_Ref(dp,nReferenceMarker);
    disp('******** adding Position of Extremum');
    dp = addExtremes(dp);               % read in a csv file with extremum positions
    disp('******** adding Position of Center of Mass');
    dp = addcm(dp);
end

switch(lower(dp.Protocol))
    
    case 'tafc'
        dp = addPsyfit(dp);
end




