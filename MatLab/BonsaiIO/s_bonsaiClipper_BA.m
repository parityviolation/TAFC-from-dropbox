%Bonsai clipper script SS 30-12-13
% BA 04-16-13

rd = brigdefs();
dp = loadBstruct();
%dp = builddp(1);


% fixAvi(dp) % if avi has wrong length f

%%
bsplitStimCond = 1;
bsplitAllStimCond = 0;

timeBefore = 2; %time before align condition in seconds
framesBefore = timeBefore*round(dp.video.info.medianFrameRate);
timeAfter = 3; %time after align condition in seconds
framesAfter = timeAfter*round(dp.video.info.medianFrameRate);


dpValid=  filtbdata(dp,0,{'ChoiceCorrect', [0 1]});
alignCond = 'pokeIn_fr';
alignCond_fr = dpValid.video.(alignCond);
desc = 'StartStopTimestamps';


cond(1).val = dp.IntervalSet;
cond(1).name = 'interval duration';

cond(2).val = [0 1];
cond(2).name = 'incorrect/correct';

if bsplitStimCond
    % no stimulation, valid, no correction loop
    ncond = unique(dpValid.stimulationOnCond);
    ncond = ncond(ncond>0);
    cond(3).val = unique(dpValid.stimulationOnCond);
    cond(3).name = 'stimulation parameters';
    cond(3).ncond = 2;
    
    if bsplitAllStimCond
        % TODO Add description string to arduino output
        
        cond(3).ncond = length(cond(3).val);
        
    end
else
    cond(3).ncond = 1;
    cond(3).val = unique(dp.stimulationOnCond);
    
end

start_fr = alignCond_fr-framesBefore;
end_fr = alignCond_fr+framesAfter;

[~,fname,~] = fileparts(dp.FileName);

f = fopen(fullfile(rd.Dir.DataBonsaiVideo,dp.Animal,[fname '_vid_time.csv']));
a = textscan(f,'%s');
fclose(f);

fmTimes = a{:};

startTimes = fmTimes(start_fr(~isnan(start_fr)));

endTimes = fmTimes(end_fr(~isnan(end_fr)));

startTimes = cell2mat(startTimes);
endTimes = cell2mat(endTimes);

[m n] = size(startTimes);
WindowOpening = repmat(' WindowOpening', m, 1);
[m n] = size(endTimes);
WindowClosing = repmat(' WindowClosing', m, 1);

startTimestamp = [startTimes(1:end,:) WindowOpening];
endTimestamp = [endTimes(1:end,:) WindowClosing];


outputstringStart = startTimestamp';
outputstringEnd = endTimestamp';


fullfilename = fullfile(rd.Dir.DataBonsaiVideo,dp.Animal,[fname '_' alignCond '_'  desc '.csv']);

f = fopen(fullfilename,'wt');


for i = 1:(size(outputstringStart,2))
    fprintf(f,'%s\n',outputstringStart(:,i));
    fprintf(f,'%s\n',outputstringEnd(:,i));
end
fclose(f);

bonsaiTemplateFilePath = fullfile(rd.Dir.BonsaiCode, 'Template_clip_recorder.bonsai');
[FullPathVideo, PathNameVideo] = selectVideo(dp); % note video for both dps must be the same

path = fullfile(PathNameVideo,'Clips For Asma',dp.Date);
parentfolder(path,1);

bonsaiFileName = fullfile(rd.Dir.BonsaiCode,'Generated',[ 'clip_recorder' datestr(now,'dSSFFF') '.bonsai']);

createBonsaiClipperFile(bonsaiTemplateFilePath,bonsaiFileName,FullPathVideo,fullfilename,path)

% copy the timestamps file the same directory and same name (Necessary for
% bonsai)
[~, fname, ~] = fileparts(dp.FileName);
filein = fullfile(rd.Dir.DataBonsaiVideo,dp.Animal,[fname '_vid_time.csv']);
[fpath, fname, ~] = fileparts(FullPathVideo);
copyfile(filein,fullfile(fpath,[fname '.csv']));

createBatBonsaiFile(bonsaiFileName,1,1);

%% to rename the files - MouseName_Protocol_Date_SSAB_stim20_correct_0-Clip1_trial1
%- example

listFilesNew = cell(dpValid.ntrials,1);
stim = dpValid.Interval*100;
correct = dpValid.ChoiceCorrect;
counter = zeros(length(dpValid.IntervalSet),1);

for i = 1:dpValid.ntrials
    ind = find(dpValid.IntervalSet == dpValid.Interval(i));
    counter(ind) = counter(ind)+1;
    laser = dpValid.stimulationOnCond(i);
    if laser ~= 0;
        if ~bsplitStimCond
            laser = 0;
        else
            if ~bsplitAllStimCond
                laser = 1: cond(3).ncond-1;
            end
        end
    end
    listFilesNew{i,:} = [fname '_stim' num2str(stim(i)) '_correct_' num2str(correct(i)) '_laser_' num2str(laser,'%d') '-Clip' num2str(counter(ind)) '_trial' num2str(i) '.avi'];
end

% do the actual renaming

directory = path;
listFilesOld = dirc(fullfile(directory, '*.avi'),'','d');

listFilesOld = listFilesOld(:,1);

% listFilesNew = {'Clip1.avi'; 'Clip2.avi';'Clip3.avi';'Clip4.avi';'Clip5.avi';'Clip6.avi'};
% 

for i = 1:size(listFilesOld,1)
    
    movefile(fullfile(directory,cell2mat(listFilesOld(i,:))),fullfile(directory,cell2mat(listFilesNew(i,:))))
    
end

% 








