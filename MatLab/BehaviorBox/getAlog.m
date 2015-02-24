function animalLog = getAlog(animalLog,index)

r = brigdefs;
savefile = r.FullPath.animalLog;

if nargin == 0
     load(savefile)
     return
end
if isempty(animalLog) % load log
    load(savefile)
end


nEntries = length(animalLog.exptFilename);
boolind = zeros(nEntries,1);
boolind(index) = 1;

fld = fieldnames(animalLog);
for ifld = 1:length(fld)
    fld{ifld}
    length(animalLog.(fld{ifld}))
    animalLog.(fld{ifld})(~boolind)= [];
end