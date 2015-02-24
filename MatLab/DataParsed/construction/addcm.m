function dataParsed = addcm(dataParsed,filein)
% function dataParsed = addcm(dataParsed)
% This function gets the xy coordinates
% dataParsed.video.extremes, a 3D matrix: [trials, number of frames displayed, xExtr1 yExtr1 xExtr2 yExtr2]
max_frames_disp = 2000;

rd = brigdefs();
% read file with coordinates xy xy for item 1 and 2 in each frame
if nargin<2
    [junk fname junk] = fileparts(dataParsed.FileName);
    filein = fullfile(rd.Dir.DataBonsai,dataParsed.Animal,[fname '_centroidXY.csv']);
end

if ~exist(filein,'file')
    [FileName,PathName] = uigetfile(fullfile(rd.Dir.BStruct,'*.csv'),'Select CSV file with CM x y coordinates');
    filein = [PathName FileName];
end

if ~ischar(filein) || ~exist(filein,'file')
    dataParsed.video.cm.xy = NaN;
    dataParsed.video.cm.speed = NaN;
    dataParsed.video.cm.file  = NaN;
    disp([filein ' does not exist'])
    disp('*** NO: Position of Center of Mass ');
    
else
    %open csv file with 2 columns, representing x and y coordinates cmd
    raw_coordinates = dlmread(filein,' ');
    
    dataParsed.video.cm.file = filein;
    dataParsed.video.cm.xy = raw_coordinates(:,1:2);
    dataParsed.video.cm.speed = [sqrt(sum(diff(dataParsed.video.cm.xy)'.^2)) NaN]';
    
    % Parse on marker on trial by trial basis
    nframe = length(dataParsed.video.framesTimes);
    pokeIn_fr = dataParsed.video.pokeIn_fr;
    dataParsed.video.cm.xyParsed = single(nan(dataParsed.ntrials,max_frames_disp,2));
    dataParsed.video.cm.framesParsed = single(nan(dataParsed.ntrials,max_frames_disp));
end
for itrial = 1:dataParsed.ntrials
    if pokeIn_fr(itrial)+max_frames_disp<nframe
        
        dataParsed.video.cm.xyParsed(itrial,:,:)=...
            dataParsed.video.cm.xy(pokeIn_fr(itrial):pokeIn_fr(itrial)+(max_frames_disp-1),:);
        
        dataParsed.video.cm.framesParsed(itrial,:)  = pokeIn_fr(itrial):pokeIn_fr(itrial)+(max_frames_disp-1); % this is the same for all markers..
        
    end
end
end


