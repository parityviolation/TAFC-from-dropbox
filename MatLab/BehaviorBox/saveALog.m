function saveALog(animalLog)
r = brigdefs;
savefile = r.FullPath.animalLog;

nEntries = length(animalLog.exptFilename);

fdLog = fieldnames(animalLog);
ind = ~ismember(structfun(@length,animalLog),nEntries);
if any(ind)
    fdLog{ind};
    error('are not the same length')
end

save(savefile,'animalLog');
disp(['saving ' savefile])
