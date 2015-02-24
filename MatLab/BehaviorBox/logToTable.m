function animalTable = logToTable(animalLog,includefldnames,sortByfldnames)

if nargin < 2
includefldnames = {'date','Experimenter','boxIndex','name'};
end

if nargin < 3
sortByfldnames = 'boxIndex';
end

nRows = length(animalLog.exptFilename);
nCol = length(includefldnames);
animalTable = cell(nRows,nCol);

for ifld = 1:nCol
    thisField = animalLog.(includefldnames{ifld});
    if iscell(thisField)
        animalTable(:,ifld)= deal(thisField);
    else
        animalTable(:,ifld)= num2cell(thisField);
    end
end

% sort
% for ifld = 1:length(sortByfldnames)
    ind = find(ismember(includefldnames,sortByfldnames));
    if ~isempty(ind)
        if iscell(animalLog.(sortByfldnames))
        [~,isorted] = sort(animalTable(:,ind));
        else
            [~,isorted] = sort(cell2mat(animalTable(:,ind)));
        end
    end
% end

animalTable = animalTable(isorted,:);