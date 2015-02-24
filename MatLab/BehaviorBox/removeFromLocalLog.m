function animalLog = removeFromLocalLog(animalLog,ind)

r = brigdefs;
savefile = r.FullPath.animalLog;

if nargin < 1 | isempty(animalLog) % load log
    load(savefile);
end

fdLog = fieldnames(animalLog);
for i = 1:length(ind)
    for ifld = 1:length(fdLog)
        if length(animalLog.(fdLog{ifld}))<=ind(i)
            animalLog.(fdLog{ifld})(ind(i)) = [];
        end
        
    end
end
disp([ num2str(length(ind)) ' Entries removed from ' savefile]);
save(savefile,'animalLog');
