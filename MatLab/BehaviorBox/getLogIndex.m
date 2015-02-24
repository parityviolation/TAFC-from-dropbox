function [ind log] = getLogIndex(dpFileName,animalLog)
% function [ind log] = getLogIndex(dpFileName,animalLog)
% BA
% find the index of the experiment in the local log
boolind  = cell2mat(arrayfun(@(x) ismember(x.exptFilename,dpFileName), animalLog, 'UniformOutput', false));
ind  = find(boolind);

if nargout >1
 animalLog = getAlog(animalLog,ind);
end
