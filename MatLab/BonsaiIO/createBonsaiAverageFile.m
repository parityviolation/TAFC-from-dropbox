function createBonsaiAverageFile(bonsaiFilePath,BonsaiSaveFileName,readAviFile,saveAviFile,correctCsv,incorrectCsv,threshold,framesDisp)
% function createBonsaiAverageFile(BonsaiSaveFileName,readAviFile,saveAviFile,correctCsv,incorrectCsv,threshold)

 % TO DO ADD copy of layout file
 if nargin==0
     saveAviFile = 'C:\Users\Bassam\Dropbox\Patlab protocols (1)\Data\TAFCmice\Bonsai\BII\BII_TAFCv06_130227_SSAB_0.2_pokeIn_times_combined_2.avi';
     readAviFile = 'test1.avi';
     BonsaiSaveFileName =  'C:\Users\Bassam\Dropbox\TAFCmice\Code\Bonsai\test_color_average_crop_colors_2.bonsai';
     correctCsv  = 'C:\Users\Bassam\Dropbox\Patlab protocols (1)\Data\TAFCmice\Bonsai\BII\BII_TAFCv06_130227_SSAB_0.2_1_0_pokeIn_times_test.csv';
     incorrectCsv = 'C:\Users\Bassam\Dropbox\Patlab protocols (1)\Data\TAFCmice\Bonsai\BII\BII_TAFCv06_130227_SSAB_0.2_0_0_pokeIn_times_test.csv';
 end
 
% startStr = '<q1:FileName>'; '<q1:EventDescriptorCategory>'; '<q2:ThresholdValue>'; '<q2:FileName>';
% 
% endStr = '</q1:FileName>'; '</q1:EventDescriptorCategory>'; '</q2:ThresholdValue>'; '</q2:FileName>';
% fvdir = fullfile(rd.Dir.DataVideo,mouseName);

% rd = brigdefs();

f = fopen(bonsaiFilePath);
lines = fscanf(f,'%c');
fclose(f);
aString = lines;

%fileAvi = 'F:\TAFCmiceWaiting\BII\BII_TAFCv06_130227_SSAB.avi';


fileAvi1 = readAviFile;

str = '<q1:FileName>';
bStartStr = strfind(aString, str);
bEndStr = bStartStr(1)+length(str)-1;
expressionsq1b = [bStartStr(1),bEndStr];
str = '</q1:FileName>';
eStartStr = strfind(aString, str);
eEndStr = eStartStr(1)+length(str)-1;
expressionsq1e = [eStartStr(1),eEndStr];

expressionq1_indx = [expressionsq1b(1,2)+1, expressionsq1e(1,1)-1];

newLines = strrep(lines, lines(expressionq1_indx(1):expressionq1_indx(2)), fileAvi1);

fileAvi2 = readAviFile;

str = '<q1:FileName>';
bStartStr = strfind(newLines, str);
bEndStr = bStartStr(2)+length(str)-1;
expressionsq1b = [bStartStr(2),bEndStr];
str = '</q1:FileName>';
eStartStr = strfind(newLines, str);
eEndStr = eStartStr(2)+length(str)-1;
expressionsq1e = [eStartStr(2),eEndStr];

expressionq1_indx = [expressionsq1b(1,2)+1, expressionsq1e(1,1)-1];

newLines = strrep(newLines, newLines(expressionq1_indx(1):expressionq1_indx(2)), fileAvi2);


str = '<Count>';
bStartStr = strfind(newLines, str);
bEndStr = bStartStr(1)+length(str)-1;
expressions_bframes = [bStartStr(1),bEndStr];
str = '</Count>';
eStartStr = strfind(newLines, str);
eEndStr = eStartStr(1)+length(str)-1;
expressions_eframes = [eStartStr(1),eEndStr];

expression_frames_indx = [expressions_bframes(1,2)+1, expressions_eframes(1,1)-1];

newLines = strrep(newLines, newLines(expression_frames_indx(1):expression_frames_indx(2)), num2str(framesDisp));


% str = '<Count>';
% bStartStr = strfind(newLines, str);
% bEndStr = bStartStr(2)+length(str)-1;
% expressions_bframes = [bStartStr(2),bEndStr];
% str = '</Count>';
% eStartStr = strfind(newLines, str);
% eEndStr = eStartStr(2)+length(str)-1;
% expressions_eframes = [eStartStr(2),eEndStr];
% 
% expression_frames_indx = [expressions_bframes(1,2)+1, expressions_eframes(1,1)-1];
% 
% newLines = strrep(newLines, newLines(expression_frames_indx(1):expression_frames_indx(2)), framesDisp);

  
EventDescriptorCategoryCorrect = correctCsv;

str = '<q1:EventDescriptorCategory>';
bStartStr = strfind(newLines, str);
bEndStr = bStartStr(1)+length(str)-1;
expressions_bedcc = [bStartStr(1),bEndStr];
str = '</q1:EventDescriptorCategory>';
eStartStr = strfind(newLines, str);
eEndStr = eStartStr(1)+length(str)-1;
expressions_eedcc = [eStartStr(1),eEndStr];

expression_edc_indx = [expressions_bedcc(1,2)+1, expressions_eedcc(1,1)-1];

newLines = strrep(newLines, newLines(expression_edc_indx(1):expression_edc_indx(2)), EventDescriptorCategoryCorrect);

EventDescriptorCategoryIncorrect = incorrectCsv;

str = '<q1:EventDescriptorCategory>';
bStartStr = strfind(newLines, str);
bEndStr = bStartStr(2)+length(str)-1;
expressions_bedci = [bStartStr(2),bEndStr];
str = '</q1:EventDescriptorCategory>';
eStartStr = strfind(newLines, str);
eEndStr = eStartStr(2)+length(str)-1;
expressions_eedci = [eStartStr(2),eEndStr];

expression_edc_indx = [expressions_bedci(1,2)+1, expressions_eedci(1,1)-1];

newLines = strrep(newLines, newLines(expression_edc_indx(1):expression_edc_indx(2)), EventDescriptorCategoryIncorrect);
  

ThresholdValue1 = num2str(threshold);

str = '<q2:ThresholdValue>';
bStartStr = strfind(newLines, str);
bEndStr = bStartStr(1)+length(str)-1;
expressionsq3b2 = [bStartStr(1),bEndStr];
str = '</q2:ThresholdValue>';
eStartStr = strfind(newLines, str);
eEndStr = eStartStr(1)+length(str)-1;
expressionsq3e2 = [eStartStr(1),eEndStr];

expressionq3_indx = [expressionsq3b2(1,2)+1, expressionsq3e2(1,1)-1];

newLines = strrep(newLines, newLines(expressionq3_indx(1):expressionq3_indx(2)), ThresholdValue1);

ThresholdValue2 = num2str(threshold);
str = '<q2:ThresholdValue>';
bStartStr = strfind(newLines, str);
bEndStr = bStartStr(2)+length(str)-1;
expressionsq3b2 = [bStartStr(2),bEndStr];
str = '</q2:ThresholdValue>';
eStartStr = strfind(newLines, str);
eEndStr = eStartStr(2)+length(str)-1;
expressionsq3e2 = [eStartStr(2),eEndStr];

expressionq3_indx = [expressionsq3b2(1,2)+1, expressionsq3e2(1,1)-1];

newLines = strrep(newLines, newLines(expressionq3_indx(1):expressionq3_indx(2)), ThresholdValue2);
  

FileNameFinalAverge = saveAviFile;
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
