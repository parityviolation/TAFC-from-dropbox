function changeBonsaiFiles(bonsaiFilePath, fileAvi,fileAviTime,fileLED,fileTracking,fileCentroidXY,fileCentroidOrientation)
%%function changeBonsaiFiles(bonsaiFilePath, fileAvi,fileAviTime,fileLED,fileTracking)
%%This function 

f = fopen(bonsaiFilePath);
lines = fscanf(f,'%c');
fclose(f);
aString = lines;


str = '<q2:FileName>';
bStartStr = strfind(aString, str);
bEndStr = bStartStr+length(str)-1;
expressionsq2b = [bStartStr,bEndStr];
str = '</q2:FileName>';
eStartStr = strfind(aString, str);
eEndStr = eStartStr+length(str)-1;
expressionsq2e = [eStartStr,eEndStr];

expressionq2_indx = [expressionsq2b(1,2)+1, expressionsq2e(1,1)-1];

newLines = strrep(lines, lines(expressionq2_indx(1):expressionq2_indx(2)), fileAvi);
  


str = '<q3:FileName>';
bStartStr = strfind(newLines, str);
bEndStr = bStartStr(1)+length(str)-1;
expressionsq3b1 = [bStartStr(1),bEndStr];
str = '</q3:FileName>';
eStartStr = strfind(newLines, str);
eEndStr = eStartStr(1)+length(str)-1;
expressionsq3e1 = [eStartStr(1),eEndStr];

expressionq3_indx = [expressionsq3b1(1,2)+1, expressionsq3e1(1,1)-1];

newLines = strrep(newLines, newLines(expressionq3_indx(1):expressionq3_indx(2)), fileAviTime);

str = '<q3:FileName>';
bStartStr = strfind(newLines, str);
bEndStr = bStartStr(2)+length(str)-1;
expressionsq3b2 = [bStartStr(2),bEndStr];
str = '</q3:FileName>';
eStartStr = strfind(newLines, str);
eEndStr = eStartStr(2)+length(str)-1;
expressionsq3e2 = [eStartStr(2),eEndStr];

expressionq3_indx = [expressionsq3b2(1,2)+1, expressionsq3e2(1,1)-1];

newLines = strrep(newLines, newLines(expressionq3_indx(1):expressionq3_indx(2)), fileLED);
  

str = '<q3:FileName>';
bStartStr = strfind(newLines, str);
bEndStr = bStartStr(3)+length(str)-1;
expressionsq3b3 = [bStartStr(3),bEndStr];
str = '</q3:FileName>';
eStartStr = strfind(newLines, str);
eEndStr = eStartStr(3)+length(str)-1;
expressionsq3e3 = [eStartStr(3),eEndStr];

expressionq3_indx = [expressionsq3b3(1,2)+1, expressionsq3e3(1,1)-1];

newLines = strrep(newLines, newLines(expressionq3_indx(1):expressionq3_indx(2)), fileTracking);
 

str = '<q3:FileName>';
bStartStr = strfind(newLines, str);
bEndStr = bStartStr(4)+length(str)-1;
expressionsq3b4 = [bStartStr(4),bEndStr];
str = '</q3:FileName>';
eStartStr = strfind(newLines, str);
eEndStr = eStartStr(4)+length(str)-1;
expressionsq3e4 = [eStartStr(4),eEndStr];

expressionq4_indx = [expressionsq3b4(1,2)+1, expressionsq3e4(1,1)-1];

newLines = strrep(newLines, newLines(expressionq4_indx(1):expressionq4_indx(2)), fileCentroidXY);
  
str = '<q3:FileName>';
bStartStr = strfind(newLines, str);
bEndStr = bStartStr(5)+length(str)-1;
expressionsq3b5 = [bStartStr(5),bEndStr];
str = '</q3:FileName>';
eStartStr = strfind(newLines, str);
eEndStr = eStartStr(5)+length(str)-1;
expressionsq3e5 = [eStartStr(5),eEndStr];

expressionq5_indx = [expressionsq3b5(1,2)+1, expressionsq3e5(1,1)-1];

newLines = strrep(newLines, newLines(expressionq5_indx(1):expressionq5_indx(2)), fileCentroidOrientation);
  

f = fopen(bonsaiFilePath,'w');
fwrite(f,newLines);
fclose(f);
end