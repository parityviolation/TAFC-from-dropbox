function [openField,filename] = openFieldLedfiles(fileDir,openField)
%fileDir = 'C:\Users\Bassam\Dropbox\TAFCmice\OpenField\FI12_1013\04302013\led22.csv';

[ledFile_intensity time_sec] = readBonsaiCSV(fileDir);
 
[junk filename junk] = fileparts(fileDir);
openField.(genvarname([filename '_intensity'])) = ledFile_intensity;
openField.(genvarname([filename '_times'])) = time_sec;

end