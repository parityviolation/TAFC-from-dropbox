function createBonsaiClipperFile(bonsaiFilePath,BonsaiSaveFileName,readAviFile,StartStopTimestampsCsv,saveAviPath)
% function createBonsaiAverageFile(BonsaiSaveFileName,readAviFile,saveAviFile,correctCsv,incorrectCsv,threshold)

f = fopen(bonsaiFilePath);
lines = fscanf(f,'%c');
fclose(f);
aString = lines;

fileAvi = readAviFile;

str = '<q1:FileName>';
bStartStr = strfind(aString, str);
bEndStr = bStartStr(1)+length(str)-1;
expressionsq1b = [bStartStr(1),bEndStr];
str = '</q1:FileName>';
eStartStr = strfind(aString, str);
eEndStr = eStartStr(1)+length(str)-1;
expressionsq1e = [eStartStr(1),eEndStr];

expressionq1_indx = [expressionsq1b(1,2)+1, expressionsq1e(1,1)-1];

newLines = strrep(lines, lines(expressionq1_indx(1):expressionq1_indx(2)), fileAvi);

  
EventDescriptorCategory = StartStopTimestampsCsv;

str = '<q1:EventDescriptorCategory>';
bStartStr = strfind(newLines, str);
bEndStr = bStartStr(1)+length(str)-1;
expressions_bedcc = [bStartStr(1),bEndStr];
str = '</q1:EventDescriptorCategory>';
eStartStr = strfind(newLines, str);
eEndStr = eStartStr(1)+length(str)-1;
expressions_eedcc = [eStartStr(1),eEndStr];

expression_edc_indx = [expressions_bedcc(1,2)+1, expressions_eedcc(1,1)-1];

newLines = strrep(newLines, newLines(expression_edc_indx(1):expression_edc_indx(2)), EventDescriptorCategory);


FileNameFinalAverge = fullfile(saveAviPath,'clip.avi');
str = '<q2:FileName>';
bStartStr = strfind(newLines, str);
bEndStr = bStartStr(1)+length(str)-1;
expressionsq2b = [bStartStr(1),bEndStr];
str = '</q2:FileName>';
eStartStr = strfind(newLines, str);
eEndStr = eStartStr(1)+length(str)-1;
expressionsq2e = [eStartStr(1),eEndStr];

expressionq2_indx = [expressionsq2b(1,2)+1, expressionsq2e(1,1)-1];

newLines = strrep(newLines, newLines(expressionq2_indx(1):expressionq2_indx(2)), FileNameFinalAverge);

f = fopen(BonsaiSaveFileName,'w');
fwrite(f,newLines);
fclose(f);
