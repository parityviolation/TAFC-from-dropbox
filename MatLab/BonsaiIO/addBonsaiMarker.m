function [dp] = addBonsaiMarker(dp,markerNameFooter)
% read in QRMarker CSV and parses by trial
% max_frames_disp = 2000; % number of frames to take starting at the beginning of each trial
rd = brigdefs;

if nargin <2 % read all MarkerFiles
    % find all Markerfiles
    files = dir(fullfile(rd.Dir.DataBonsai,dp.Animal,[dp.FileName '_Marker*.csv']));
    
    if isempty(files)
        disp('No QRmarker CSV files found');
        dp.video.qr = [];
        return
    end
    
    for i = 1:length(files)
        markerName{i}= files(i).name;
    end
    
else
    
    if isstr(markerNameFooter)  % convert to cell
        temp = markerNameFooter;
        clear markerNameFooter;
        markerNameFooter{1} = temp;
    end
    
    for imarker  = 1:length(markerNameFooter)
        markerName{imarker} = [dp.FileName '_' markerNameFooter{imarker} '.csv'] ;
    end
end



for imarker  = 1:length(markerName)
    dp = readfilehelper(dp,markerName{imarker});
end


% Parse on marker on trial by trial basis
if 0
    nframe = length(dp.video.framesTimes);
    nmarker = length(dp.video.qr);
    pokeIn_fr = dp.video.pokeIn_fr;
    for imarker = 1:nmarker % declare variables
        dp.video.qr(imarker).modelViewMatrixParsed = single(nan(dp.ntrials,max_frames_disp,16));
        dp.video.qr(imarker).framesParsed = single(nan(dp.ntrials,max_frames_disp));
    end
    for itrial = 1:dp.ntrials
        if pokeIn_fr(itrial)+max_frames_disp<nframe
            
            for imarker = 1:nmarker
                
                dp.video.qr(imarker).modelViewMatrixParsed(itrial,:,:)=...
                    [dp.video.qr(imarker).modelViewMatrix(pokeIn_fr(itrial):pokeIn_fr(itrial)+(max_frames_disp-1),:)];
                
                dp.video.qr(imarker).framesParsed(itrial,:)  = pokeIn_fr(itrial):pokeIn_fr(itrial)+(max_frames_disp-1); % this is the same for all markers..
            end
        end
    end
end


function dp = readfilehelper(dp,sMarkerName)

rd = brigdefs;
filein = fullfile(rd.Dir.DataBonsai,dp.Animal,sMarkerName);

if exist(filein,'file')
    s = sprintf('\tAdding QR: %s',sMarkerName);
    disp(s);
    markerFile = dlmread(filein,' ');
    markerFile = markerFile(:,1:16);
    % find all the rows that are all zero .. this is when on marker is found
    % replace with NaNs
    indNoMarker = sum(markerFile,2)==0;
    markerFile(indNoMarker,:)= nan(sum(indNoMarker),16);
    
    % check if number of timestamps is the same
    nframe = length(dp.video.framesTimes);
    nmarkerpos = size(markerFile,1);
    
    if nmarkerpos ~= nframe
         warning(['framesTimes ' nframe ' and QRmarker ' nmarkerpos ' are not the same'])        
         
        if nframe < nmarkerpos; % drop markers that have no frametimes
            nkeepMarker =  min(nframe,nmarkerpos);
           markerFile =   markerFile(1: nkeepMarker,:)    ;   
        else % add nans for frametimes with no markerss]
            nkeepMarker =  nframe;
            markerFile =   [markerFile; nan(nkeepMarker-nmarkerpos,16) ];
        end
    end
    if isfield(dp.video,'qr')
        n = length(dp.video.qr)+1;
    else
        n = 1;
    end
dp.video.qr(n).filename = filein;
dp.video.qr(n).name = sMarkerName;
dp.video.qr(n).modelViewMatrix = single(markerFile);

    
   
else
    disp([filein ' does not exist'])
end


