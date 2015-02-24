if isunix
    slash = '/';
else
    slash = '\';
end

rd = brigdefs();
videoDatadir = rd.Dir.DataVideo;
[FileNameVideo,PathNameVideo] = uigetfile(fullfile(videoDatadir,slash,'*.avi'),'Select Video File to analyze');
FullPathVideo = [PathNameVideo FileNameVideo];
readAviFile = FullPathVideo;

dstruct.dataParsed = custom_parsedata;
FileName = dstruct.dataParsed.FileName;
[pathstr, FileName, ext] = fileparts(FileName);
date = dstruct.dataParsed.Date;
intervalSet = dstruct.dataParsed.IntervalSet;
Animal =  dstruct.dataParsed.Animal;
%threshold = 26; %for BII day 0227 
%threshold = 79;  %for BII day 0325
%threshold = 48; %for BII day 0526
threshold = 166; %for FI12_1013 day 0529

bonsaiFilePath = fullfile(rd.Dir.BonsaiCode, 'TEMPLATE_test_color_average_crop_colors_2.bonsai');

for i = 1:length(intervalSet)
path = fullfile(PathNameVideo,'Averages',date);
parentfolder(path,1);
saveAviFile{i} = fullfile(path,[FileName '_pokeIn_times_combined_' num2str(intervalSet(i)) '.avi']);
correctCsv{i}  = fullfile(rd.Dir.DataBonsai, Animal, [FileName '_' num2str(intervalSet(i)) '_1_1_pokeIn_times.csv']);
incorrectCsv{i} = fullfile(rd.Dir.DataBonsai, Animal, [FileName '_' num2str(intervalSet(i)) '_1_0_pokeIn_times.csv']);
BonsaiSaveFileName{i} = fullfile(rd.Dir.BonsaiCode, ['test_color_average_crop_colors_' num2str(intervalSet(i)) '.bonsai']);

createBonsaiAverageFile(bonsaiFilePath,BonsaiSaveFileName{i},readAviFile,saveAviFile{i},correctCsv{i},incorrectCsv{i},threshold);
% batfile = fopen(fullfile(rd.Dir.BatFile,'batfile.bat'),'w');
% fwrite(batfile,fullfile(rd.Dir.BonsaiEditor64,['Bonsai.Editor.exe ' BonsaiSaveFileName{i} ' --start']));
% fclose(batfile);

%%Run Bonsai
%system(fullfile(rd.Dir.BatFile,'batfile.bat &'));
 end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% datadir = rd.Dir.DataBehav;
% [FileName,PathName] = uigetfile(fullfile(datadir,slash,'*.txt'),'Select Behavior file to analyze');
% FullPath = [PathName FileName];
% [pathstr, FileName, ext] = fileparts(FullPath);
% slash_ndx = regexp(FullPath,slash);
% uscore_ndx = regexp(FileName,'_');
% mouseName = PathName(slash_ndx(end-1)+1:slash_ndx(end)-1);
% day = FileName(uscore_ndx(end-1)+1:uscore_ndx(end)-1);