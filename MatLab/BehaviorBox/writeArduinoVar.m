function arduinoFile = writeArduinoVar(protocolFullPath, varSource)
% function arduinoFile = writeArduinoVar(protocolFullPath, varSource)
% varSource is either a cell or the fullfilepath of the file containing ArduinoVar settings

% protocolFullPath = 'C:\Users\Bassam\Dropbox\TAFCmice\Code\Arduino\TAFCTEST\TAFCTEST.ino';
% loadFilePath = 'C:\Users\Bassam\Dropbox\TAFCmice\Code\Arduino\LogFiles\Animals\Zero\Zero.txt'
%f = fopen('C:\Users\Behave\Dropbox\TAFCmice\Code\Arduino\TAFCTEST\TAFCv07.ino');
% rd = brigdefs();
sSEMICOLON = ';';

[arduinoFilePath, originalArduinoFilename, arduinoExtension] = fileparts(protocolFullPath);

f = fopen(protocolFullPath);
arduinoFile = fscanf(f,'%c');
fclose(f);

[variableNames variableValues] =   loadArduinoVar(varSource);


variableNamesSearch = variableNames;

for i = 1:length(variableNames)
    variableNames{i} = strtrim(variableNames{i});
    % check if variable is an array
    [yo,ye]=regexp(variableNames{i},'\[]');
    if yo
        variableNamesSearch{i} = strrep(variableNames{i}, variableNames{i}(yo:ye), '\[]' );
    else
        variableNamesSearch{i} =variableNames{i};
    end
    
    % find variable in arduinoFile
    [arduinoStartndx,arduinoEndndx] = regexp(arduinoFile,variableNamesSearch{i});
    if ~isempty(arduinoStartndx)
        arduinoStartVarIndex(i) = arduinoStartndx(1);
        arduinoEndVarIndex(i) = arduinoEndndx(1);
        
        [arduinoEndndx] = regexp(arduinoFile(arduinoEndVarIndex(i):end),sSEMICOLON);
        
        arduinoEndValIndex(i) = arduinoEndndx(1) + arduinoEndVarIndex(i);
        
        arduinoFile = strrep(arduinoFile, arduinoFile(arduinoEndVarIndex(i)+1:arduinoEndValIndex(i)), sprintf('%s\r\n',variableValues{i}) );     
    end
    
    
end
f = fopen(protocolFullPath,'w');
fwrite(f,arduinoFile);
fclose(f);


