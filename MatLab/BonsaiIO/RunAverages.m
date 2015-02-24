%field should be a field in dp.video

dp = loadBstruct();

% AVERAGE WiLL not work if there are less frames in video then what are
% requested in average. This happens for some reason some times (timestamps
% file has more frames than video.
%        Fix temporary.. make sure works then fix perminent
%%
% CHECK
%   1 - windows cannot overlap
%   2 - time of all window are in the video

nframesInAvi = 1810068; % from bonsai (not sure it is right)
dp.video.nframesInAvi = nframesInAvi;
bGT = 0;
Intv = 0.42;


%field should be a field in dp.video
field = 'pokeIn_fr';

bCorrect = [0 1];
if length(bCorrect)==2
    filterheader = '_';
elseif bCorrect
    filterheader = 'correct_';
else
    filterheader = 'error_';
end


if bGT
    filterheader = 'GT';
    sfun = @(x) x>=Intv;
else
    filterheader = '';
    sfun = @(x) x==Intv;
end

% first filter 
filter1 = [filterheader  num2str(Intv*100,'%d') '_Stim'];
dp1 =  filtbdata(dp,0,{'ChoiceCorrect',bCorrect,'Interval',sfun,'stimulationOnCond',@(x) x~=0});
% second filter 
filter2 = [filterheader num2str(Intv*100,'%d') 'no_Stim'];
dp2=  filtbdata(dp,0,{'ChoiceCorrect',bCorrect,'Interval',sfun,'stimulationOnCond',0});


[~, averageFilename] = fileparts(dp.FileName);
bonsaiFileName = getBonsaiFileForAverages(dp1,dp2,averageFilename,field,filter1,filter2);
createBatBonsaiFile(bonsaiFileName,1,1);

% movieObj = VideoReader(NEED entire path averageFilename); % open file
% get(movieObj) % display all info
% nFrames = movieObj.NumberOfFrames;
% width = movieObj.Width; % get image width
% height = movieObj.Height; 