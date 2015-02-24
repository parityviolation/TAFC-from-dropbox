function [animalLog bfound]=  addToLocalLog(data,animalLog,dpFileName)
% function animalLog =  addToLocalLog(data,animalLog,dpFileName)
%
% update log file with animal data
% if dpFileName is specified will replace the existing log with new data
bStartNewLog = 0; % WATCHOUT This will delete the OLD LOG!!!
bUpdate = 0;
bfound = NaN;

if nargin < 3% if it is not an Update
    if isempty(data.exptFilename) | isempty(data.name)
        error('data.exptFilename and data.name cannot be empty');
    end
end

r = brigdefs;
savefile = r.FullPath.animalLog;
% animalLog.Experimenter
% animalLog.name
% animalLog.boxIndex
% animalLog.exptFilename
% animalLog.brunVideo
% animalLog.weight
% animalLog.arduinoLog
% animalLog.bonsaiLog

if nargin < 2 | isempty(animalLog) % load log
   animalLog = loadAnimalLog;
end

if nargin > 2
    
    logInd = getLogIndex(dpFileName,animalLog);
    if isempty(logInd)
        disp([dpFileName ' log not found'])
        bfound = 0;
        return;
    else
        bUpdate = 1;
    end
end


fd = fieldnames(data);

if bStartNewLog
    for ifld = 1:length(fd)
        if  isscalar(data.(fd{ifld}))&&isnumeric(data.(fd{ifld}))
            animalLog.(fd{ifld}) = [];
        else
            animalLog.(fd{ifld}) = {};
        end
    end
end

animalLog = addFieldtoStruct(animalLog,data); % this is necessary to take care of fields in data that may not exist in animalLog

%     currentFieldLength = length(animalLog.(fdLog{ifld}));

fdLog = fieldnames(animalLog);
if ~bUpdate % add a new field don't change an existing one.
    logInd = length(animalLog.exptFilename)+1;
end

for ifld = 1:length(fdLog)
    
    thisEntry = [];
    if isfield(data,fdLog{ifld})
        thisEntry = data.(fdLog{ifld});        
    elseif bUpdate
        if iscell(animalLog.(fdLog{ifld}))
            thisEntry = animalLog.(fdLog{ifld}){logInd};
        else
            thisEntry = animalLog.(fdLog{ifld})(logInd);
        end
        
    end
    
    %  put a NaN in for empty fields
    if (isempty( thisEntry))
        if ~iscell(animalLog.(fdLog{ifld}))
            thisEntry = NaN;
        end
    end
    
    try
        if iscell(animalLog.(fdLog{ifld}))
            animalLog.(fdLog{ifld}){logInd} = thisEntry;
        else
            
            if iscell(thisEntry)
                error([fdLog{ifld} ' this Entry is Numeric it cannot be a cell'])
            end
            
            animalLog.(fdLog{ifld})(logInd) = thisEntry;
        end
        
    catch
        fdLog{ifld}
    end

    
end

if bStartNewLog
    if (exist(savefile,'file'))
        disp('WATCHOUT LOG file exists and will be replaced')
        keyboard;
    end
end


% check all fields are the same size
nEntries = length(animalLog.exptFilename);

fdLog = fieldnames(animalLog);
ind = ~ismember(structfun(@length,animalLog),nEntries);
if any(ind)
    fdLog{ind};
    error('are not the same length')
end

% % REMOVE extra entreies fieelds
% ind = find(ind);
% for i = 1:length(ind)
%     animalLog.(fdLog{ind(i)})(end) = [];
% end
%     
save(savefile,'animalLog');


function newStruct = addFieldtoStruct(animalLog,data)
fld = fieldnames(data);
b = fieldnames(animalLog);

if any(~ismember(fld,b))
    [fd]= unique({b{:} fld{:}});
    
else
    newStruct = animalLog;
    return
end

% make a new struct with all the right fields
for ifld = 1:length(fd)
    
    newStruct.(fd{ifld}) = [];
    
end

nEntries = length(animalLog.exptFilename);
% add the old entries to the new struct
for ifld = 1:length(fd)
    if isfield(animalLog,fd{ifld})
        newStruct.(fd{ifld}) = animalLog.(fd{ifld});
    else
        if  isnumeric(data.(fd{ifld}))
            newStruct.(fd{ifld}) = nan(1,nEntries);
        else
            newStruct.(fd{ifld}) = cell(1,nEntries);
            
        end
    end
    
end
