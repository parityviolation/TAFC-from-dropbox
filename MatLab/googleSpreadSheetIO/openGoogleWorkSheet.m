function s = openGoogleWorkSheet(s)

if nargin <1
    disp('Reading default number of rows and column')
    s.spreadsheetTitle = 'TAFC Mice Weights Table';
    s.worksheetTitle = 'Sheet55';
    s.nColToGet = 6;
    s.nRowToGet = 3; %number of rows from the bottom, counting from the first
%     non empty row
end
if ~isfield(s,'aTokenDocs')
    [aTokenDocs,aTokenSpreadsheet]=connectNAuthorize(s.username);
    s.aTokenDocs = aTokenDocs;
s.aTokenSpreadsheet = aTokenSpreadsheet;

end
s.cellEdited = [];  % row in s.table, row in Google SS, column]



if isempty(s.aTokenDocs) || isempty(s.aTokenSpreadsheet)
    warndlg('Could not obtain authorization tokens from Google.','');
    return;
end

% find spreadsheet
if ~isfield(s,'spreadsheetKey')
    userSpreadsheets=getSpreadsheetList(s.aTokenSpreadsheet);
    for iss = 1:length(userSpreadsheets)
        if isequal(userSpreadsheets(iss).spreadsheetTitle,s.spreadsheetTitle)
            s.spreadsheetKey = userSpreadsheets(iss).spreadsheetKey;
            break;
        end
    end
end

% find worksheet
% if ~isfield(s,'worksheetKey')|~isequal(s.worksheetTitle,s.loadedworksheetTitle)
    spreadsheetWorksheets=getWorksheetList(s.spreadsheetKey,s.aTokenSpreadsheet);
    for iss = 1:length(spreadsheetWorksheets)
        if isequal(spreadsheetWorksheets(iss).worksheetTitle,s.worksheetTitle)
            s.worksheetKey = spreadsheetWorksheets(iss).worksheetKey;
            s.loadedworksheetTitle = s.worksheetTitle;
            break;
        end
    end
% end

% read worksheet
[s.nR s.nC]  = getWorksheetNameAndSize(s.spreadsheetKey,s.worksheetKey,s.aTokenSpreadsheet);

if isfield(s,'table')
    s = rmfield(s,'table');
end
% get column titles
s.header{1,1} = 'Index in GS';
for ic = 1:min(s.nC,s.nColToGet)
s.header{1,ic+1} = getWorksheetCell(s.spreadsheetKey,s.worksheetKey,1,ic,s.aTokenSpreadsheet);
end
bNonEmptyCellFound = 0;
s.stopRow = 2;
ir = s.nR;
while(ir >= s.stopRow) % extract starting at the end of the worksheet until the beginning or the 2nd row that after the first non empty cell
            s.table{ir,1} = ir; % keep track of original index in GS
    for ic = 1:min(s.nC,s.nColToGet)
        [s.table{ir,ic+1}] = getWorksheetCell(s.spreadsheetKey,s.worksheetKey,ir,ic,s.aTokenSpreadsheet);
        if ~isempty(s.table{ir,ic+1}) && ~bNonEmptyCellFound
            s.stopRow  = ir-(s.nRowToGet-1);
            s.nonEmptyRow = ir;
            bNonEmptyCellFound = 1;
        end
%         [ir  ic]
        
    end
    ir = ir-1;
end
s.table = s.table([ir+1:end],:);


% replace all the empty cells with '' so they can be edited 
% otherwise they will be nans when edited on uitable
for ir = 1:size(s.table,1)
    for ic = 1:size(s.table,2)
        if isempty(s.table{ir,ic})
            s.table{ir,ic} = '';
        end
    end
end
