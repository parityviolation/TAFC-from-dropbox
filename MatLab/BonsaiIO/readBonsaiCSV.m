function [ledFile_intensity time_sec] = readBonsaiCSV(filein)
% function [ledFile_intensity time_sec] = readBonsaiCSV(filein)
% read CSV with 1 col of a value and 2nd col of timestamp

%SS

f = fopen(filein);
ledFile = textscan(f,'%s');
fclose(f);


ledFile = ledFile{1};
ledFile_intensity_cell = ledFile(1:2:end);
ledFile_times_cell = ledFile(2:2:end);
ledFile_intensity = str2double(ledFile_intensity_cell);
ledFile_times = cell(length(ledFile_times_cell),3);

for i = 1:length(ledFile_times_cell)
ledFile_times(i,1:3) = textscan(ledFile_times_cell{i},'%11c %16c %6c');
end

initial_hour = str2num(ledFile_times{1,2}(1,1:2));

temp  = cell2mat(ledFile_times(:,2));
ledFile_framesTimes = nan(1,length(length(temp)));
time_sec = (str2num(temp(:,1:2))-initial_hour)*60*60; % convert hours to secs
time_sec = time_sec + str2num(temp(:,4:5))*60; % convert minutes to secs
time_sec = time_sec + str2num(temp(:,7:16));
