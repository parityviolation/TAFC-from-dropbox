function dp = addQR_Ref(dp,nReferenceMarker,max_frames_disp)
% function dp = addQR_Ref(dp,nReferenceMarker,max_frames_disp)

% requires addBonsaiMarker to be run first

% find all moments when each of the marker is simultaneous with marker 1.
%   % catch case when this doesn't happen
% calcuate InveseM1 * MX fo all instances (what is the std)
% take the Median this is the transformation between these two markers
% translate all by Median

% for each frame take the nanmean of all the marker positions


binterpolate = 1;

if nargin <2
    nReferenceMarker = 3;
end

if isempty(dp.video.qr)
    disp('No QRmarker CSV files found, already told you!!');    
    return
end

nmarkers = length(dp.video.qr);
nframes = length(dp.video.framesTimes);

if nargin <3
    max_frames_disp = 2000; % for parsed trajectors
end

refNonNan= ~isnan(dp.video.qr(nReferenceMarker).modelViewMatrix(:,1));
makeMV = @(X) reshape(X',[4,4,size(X,1)]); % helper function to convert to modelviewmatrix

% matrix with all the estimates of the RefMarker modelViewMatrix
refMarkerMV = nan(nframes,16,nmarkers,'single');

% find the average position of the markers and reference marker (uses the
% average of all frames that both were detected)
for imarker = 1:nmarkers
    if imarker ~=nReferenceMarker % find frames where maker and ref marker both are found
        thisMarkerNonNan = ~isnan(dp.video.qr(imarker).modelViewMatrix(:,1));
        bothNonNan = refNonNan &thisMarkerNonNan;
        dp.video.qr(imarker).deltaRef = NaN;
        if any(bothNonNan)
            % make all these into MVmatrix
            thisrefMV = makeMV(dp.video.qr(nReferenceMarker).modelViewMatrix(bothNonNan,:));
            thismarkerMV =  makeMV(dp.video.qr(imarker).modelViewMatrix(bothNonNan,:));
            delta = zeros(4,4,size(thismarkerMV,3));
            for i = 1:size(thismarkerMV,3)
                delta(:,:,i) = thismarkerMV(:,:,i)\ thisrefMV(:,:,i); % transformation Delta from marker to ref
            end
            dp.video.qr(imarker).deltaRef = median(delta,3); % I am not certain that taking the mean is reasonable for the rotation matrix since treats all elements independly (but should be cause is a linear transformation?)
            
            
            % transform all positions to be referencepostions
            ind = find(thisMarkerNonNan);
            for thisframe = 1:length(ind) % replace with mtimesx (need .mex compiled)
                refMarkerMV(thisframe,:,imarker) = reshape(makeMV(dp.video.qr(imarker).modelViewMatrix(thisframe,:))*dp.video.qr(imarker).deltaRef,16,1);
            end
        end
    else
        dp.video.qr(imarker).deltaRef = eye(4,4);
        refMarkerMV(:,:,imarker) = dp.video.qr(imarker).modelViewMatrix;
    end
    
end

% Parse into trials
dp.video.qrRef.modelViewMatrix = nanmean(refMarkerMV,3);


dp.video.qrRef.modelViewMatrixParsed= nan(dp.ntrials,max_frames_disp,16);
dp.video.qrRef.framesParsed = nan(dp.ntrials,max_frames_disp);
dp.video.qrRef.mVMPInterp = nan(dp.ntrials,max_frames_disp,16);
pokeIn_fr = dp.video.pokeIn_fr;

for itrial = 1:dp.ntrials
    if pokeIn_fr(itrial)+max_frames_disp<nframes
        
        
        
        dp.video.qrRef.modelViewMatrixParsed(itrial,:,:)=...
            [dp.video.qrRef.modelViewMatrix(pokeIn_fr(itrial):pokeIn_fr(itrial)+(max_frames_disp-1),:)];
        
        dp.video.qrRef.framesParsed(itrial,:)  = pokeIn_fr(itrial):pokeIn_fr(itrial)+(max_frames_disp-1); % this is the same for all markers..
    end
    if binterpolate
        for iele = 1: 16 % interpolate NaNs
            dp.video.qrRef.mVMPInterp(itrial,:,iele) = NaN;
            if any(~isnan(dp.video.qrRef.modelViewMatrixParsed(itrial,:,iele)))
                dp.video.qrRef.mVMPInterp(itrial,:,iele) = inpaint_nans(dp.video.qrRef.modelViewMatrixParsed(itrial,:,iele));
            end
            % extrapolations may cause some errors TO DO REMOVE or use
            % other method
            
            
        end
    end
end

% not plotting all the trials
if 0 % check interpolation
    figure
    for itrial =1 :dp.ntrials
        clf
        plot(dp.video.qrRef.mVMPInterp(itrial,1:220,13),dp.video.qrRef.mVMPInterp(itrial,1:220,14),'k')
        hold on;
        
        plot(dp.video.qrRef.modelViewMatrixParsed(itrial,1:220,13),dp.video.qrRef.modelViewMatrixParsed(itrial,1:220,14),'r')
        
        pause;
    end
end
