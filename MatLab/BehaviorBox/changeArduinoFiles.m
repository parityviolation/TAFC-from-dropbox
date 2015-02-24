function r = changeArduinoFiles(uploaded_ProtocolPath, log_ProtocolFilename)
% function changeArduinoFiles(arduinoProtocolPath, fileAvi,fileAviTime,fileLED,fileTracking)
% %%function changeArduinoFiles(bonsaiFilePath, fileAvi,fileAviTime,fileLED,fileTracking)
% %%This function 


%f = fopen('C:\Users\Behave\Dropbox\TAFCmice\Code\Arduino\TAFCv07\TAFCv07.ino');
rd = brigdefs();
newArduinoFilePath = rd.Dir.CodeArduinoProtocols;
originalArduinoFile = arduinoProtocolPath;
textFilePath = rd.Dir.CodeArduinoProtocols;

[arduinoFilePath, originalArduinoFilename, arduinoExtension] = fileparts(uploaded_ProtocolPath);

f = fopen(originalArduinoFile);
arduinoFile = fscanf(f,'%c');
fclose(f);


ff = fopen(fullfile(textFilePath,'arduinotest.txt'));
textFile = fscanf(ff,'%c');
fclose(ff);

str1 = '=';
alleqndxs = strfind(textFile, str1);
str2 = ';';
allendndxs = strfind(textFile, str2);
str3 = '//';
comndxs = strfind(textFile, str3);

eqndxs = alleqndxs(alleqndxs<comndxs(1));
endndxs = allendndxs(allendndxs<comndxs(1));
variableNames = cell(1,length(eqndxs));
variableValues = cell(1,length(eqndxs));
variableNamesSearch = variableNames;

for i = 1:length(eqndxs)
if i == 1
   variableNames{i} = textFile(1:eqndxs(1));
   variableValues{i} = textFile(eqndxs(i)+1:endndxs(i));
   
else
   variableNames{i} = textFile(endndxs(i-1)+2:eqndxs(i));
   variableValues{i} = textFile(eqndxs(i)+1:endndxs(i));
   
end

   [yo,ye]=regexp(variableNames{i},'\[]');
   if yo
   variableNamesSearch{i} = strrep(variableNames{i}, variableNames{i}(yo:ye), '\[]' );
   else
   variableNamesSearch{i} = variableNames{i};    
   end
   
   [arduinoStartndx,arduinoEndndx] = regexp(arduinoFile,variableNamesSearch{i});
   
   arduinoStartVarIndex(i) = arduinoStartndx(1);
   arduinoEndVarIndex(i) = arduinoEndndx(1);
   
   [arduinoEndndx] = regexp(arduinoFile(arduinoEndVarIndex(i):end),str2);
   
   arduinoEndValIndex(i) = arduinoEndndx(1) + arduinoEndVarIndex(i);
   
   arduinoFile = strrep(arduinoFile, arduinoFile(arduinoEndVarIndex(i)+1:arduinoEndValIndex(i)), sprintf('%s\n',variableValues{i}) );
 
end

f = fopen(arduinoFilePath,'w');
fwrite(f,arduinoFile);
fclose(f);

