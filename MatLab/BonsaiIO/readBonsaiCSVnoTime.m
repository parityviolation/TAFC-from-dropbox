function [ledFile_intensity] = readBonsaiCSVnoTime(filein)
% function [ledFile_intensity time_sec] = readBonsaiCSV(filein)
% read CSV with 1 col of a value and 2nd col of timestamp

%SS

f = fopen(filein);
ledFile = textscan(f,'%s');
fclose(f);


ledFile = ledFile{1};
ledFile_intensity_cell = ledFile(1:end);
ledFile_intensity = str2double(ledFile_intensity_cell);

