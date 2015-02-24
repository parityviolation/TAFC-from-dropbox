function syncPulseTimesBulk = getBulkSyncPulse(data,threshold)

if ~exist('threshold','var')
threshold = 15;
end


syncThresh = mean(data.Sync) + std(data.Sync)*threshold;
 
 syncPulse = data.Sync > syncThresh;
 
 syncPulse = find(syncPulse == 1);
 
 syncPulseDiff = diff(syncPulse);
 
 syncPulseTimesBulk = syncPulse(find(syncPulseDiff>1)+1);
 
 syncPulseTimesBulk = [syncPulse(1) syncPulseTimesBulk];
 
end