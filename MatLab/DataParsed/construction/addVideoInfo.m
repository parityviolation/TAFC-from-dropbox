function dataParsed = addVideoInfo(dataParsed)
% function dataParsed = addVideoInfo(dataParsed)


%just to get an idea %frameRate = length(dataParsed.video.framesTimes)/(dataParsed.video.framesTimes(end)-dataParsed.video.framesTimes(1));

dataParsed.video.info.meanFrameRate = NaN;
dataParsed.video.info.stdFrameRate =  NaN;
dataParsed.video.info.droppedFrames = NaN;
dataParsed.video.info.medianFrameRate =NaN;
if ~isnan(dataParsed.video.framesTimes)
    
    
    frameInterval = diff(dataParsed.video.framesTimes);
%     frameRate= 1./frameInterval % can cause infinities if frameInterival
%     is very small
    
    dataParsed.video.info.meanFrameRate = 1/mean(frameInterval);
    dataParsed.video.info.medianFrameRate = 1/median(frameInterval);
    dataParsed.video.info.stdFrameRate = 1/std(frameInterval);
    dataParsed.video.info.maxFramesInterval =  max(frameInterval);
        
    dataParsed.video.info.droppedFrames = sum(frameInterval>(median(frameInterval)*1.9));
    dataParsed.video.info.medianDroppedFramesInterval = median(frameInterval(frameInterval>(median(frameInterval)*1.9)));

    dataParsed.video.info.fracDroppedFrames = sum(frameInterval>median(frameInterval)*1.9)/length(frameInterval);
    dataParsed.video.info.frameInterval = frameInterval;

    
    if dataParsed.video.info.droppedFrames > 10
        figure
        plot(frameInterval)
        warning(['VIDEO ' num2str(dataParsed.video.info.fracDroppedFrames) 'of all Video Frames messed up'])
        dataParsed.video.info
    end
    
end
