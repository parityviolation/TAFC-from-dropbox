function h = createTable_GoogleWS(googleWS)
% googleWS is a struct created for every worksheet read from google docs
% see openGoogleWorkSheet(aTokenDocs,aTokenSpreadsheet,googleWS)

h.hf = figure('Position',[  0         874        1030         146]);
h.googleWS = googleWS;
set(h.hf,'NumberTitle','off','Name',[h.googleWS.worksheetTitle ' - ' h.googleWS.spreadsheetTitle] );
set(h.hf,'KeyPressFcn',@updateGSW);
set(h.hf,'CloseRequestFcn',@my_closefcn)

h.bautoUpdate = 1;
% create table
pos = round(get(gcf,'Position'))*.99;
h.hut = uitable('Data',h.googleWS.table ,'Position',[0 0 pos(3) pos(4)],'ColumnEditable',[true],...
   'ColumnFormat' ,{'char'},'ColumnWidth', 'auto','ColumnName', h.googleWS.header,...
   'CellEditCallback',@updateGSpreadsheet_Callback) ;
 %   'ColumnWidth', {7*(1+max(cellfun('length',googleWS.table))) },'ColumnName', googleWS.table(1,:)) ;
%     'ColumnWidth', {max(1,7*max(cellfun('length',googleWS.table))) 'auto'}) ;

guidata(h.hf,h);
end

function updateGSpreadsheet_Callback(hObject, eventdata)
if ~isequal(eventdata.PreviousData,eventdata.NewData)
    h = guidata(get(hObject,'Parent'));
    h.googleWS.table = get(hObject,'data');
    tableRow = eventdata.Indices(1);
    Col = eventdata.Indices(2);
    RowIn_GWS = h.googleWS.table{tableRow,1}; % remember the first column of table is the headers
    h.googleWS.cellEdited(end+1,:) = [tableRow RowIn_GWS Col ];
    if h.bautoUpdate
         h.googleWS = updateWorkSheet(h.googleWS);
    end
    guidata(h.hf,h);
end
end

function updateGSW(hObject, eventdata)
h = guidata(hObject);

switch(eventdata.Character)
    case 'a' % toggle auto update
        h.bautoUpdate = ~h.bautoUpdate
    case 'googleWS' % save
        h.googleWS = updateWorkSheet(h.googleWS);
    case 'r' % add new row
        h.googleWS.table{end+1,1} = h.googleWS.table{end,1}+1;
        for ic = 2:size(h.googleWS.table,2)
        h.googleWS.table{end,ic} = '';
        end
        h.googleWS.nR = h.googleWS.table{end,1};
        changeWorksheetNameAndSize(h.googleWS.spreadsheetKey,h.googleWS.worksheetKey,h.googleWS.nR,h.googleWS.nC,h.googleWS.worksheetTitle,h.googleWS.aTokenSpreadsheet)
        set(h.hut,'data',h.googleWS.table)
    otherwise
end
guidata(h.hf,h);

end

function my_closefcn(hObject, eventdata) 
h = guidata(hObject);
try
    if ~isempty(h.googleWS.cellEdited)
    selection = questdlg('Save to GoogleSpreadSheet?',...
        'Close Request Function',...
        'Yes','No','Yes');
    switch(selection)
        case 'Yes'
            h.googleWS = updateWorkSheet(h.googleWS);
    end
    
    end
catch ME
    getReport(ME)
end
delete(gcf)
end
      
