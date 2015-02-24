function [ind animalLog] = getLogIndexAnimal(dpAnimal,animalLog)
% function [ind animalLog] = getLogIndex(dpFileName,animalLog)
% BA
% find the index of the experiment in the local log
if nargin < 2
    animalLog = loadAnimalLog;
end
boolind  = cell2mat(arrayfun(@(x) ismember(x.name,dpAnimal), animalLog, 'UniformOutput', false));
ind  = find(boolind);

if nargout >1
 animalLog = getAlog(animalLog,ind);
end
