function[s newrow] = addExptRow(s,data)
nextRowTable = size(s.table,1)+1;
nextRowGWS = s.table{size(s.table,1),1}+1;
s.table{nextRowTable,1} = nextRowGWS;  % this column is not in the Google woorksheet but coontains the row in that worksheet

s.table{nextRowTable,2+1} = data.date ;
s.table{nextRowTable,3+1} = num2str(data.weight);
s.table{nextRowTable,4+1} = num2str(data.boxIndex);
s.table{nextRowTable,5+1} = data.exptFilename;
s.table{nextRowTable,6+1} = num2str(data.brunVideo);
s.table{nextRowTable,7+1} = num2str(data.comment);
s.cellEdited(end+1,:) = [nextRowTable nextRowGWS 3];  % row in s.table row in Google SS  column]
s.cellEdited(end+1,:) = [nextRowTable nextRowGWS 4];  % row in s.table row in Google SS  column]
s.cellEdited(end+1,:) = [nextRowTable nextRowGWS 5];  % row in s.table row in Google SS  column]
s.cellEdited(end+1,:) = [nextRowTable nextRowGWS 6];  % row in s.table row in Google SS  column]
s.cellEdited(end+1,:) = [nextRowTable nextRowGWS 7];  % row in s.table row in Google SS  column]
s.cellEdited(end+1,:) = [nextRowTable nextRowGWS 8];  % row in s.table row in Google SS  column]
s = updateWorkSheet(s);

for ir = 1:size(s.table,1)
    for ic = 1:size(s.table,2)
        if isempty(s.table{ir,ic})
            s.table{ir,ic} = '';
        end
    end
end

newrow = s.table(nextRowTable,:);