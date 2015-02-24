
%
% Created on November 2012
%
% @author: sofia1
%
%11
%

rd = brigdefs();

% read file with coordinate1s xy xy for item 1 and 2 in each frame

brunVideo = 1;

experimenterList = {'Zero'; 'SSAB'; 'User 2'; 'User 3'; 'User 4'};
experimenterIndex = input('\n\nINTERVAL DURATION DISCRIMINATION TASK \n\nSelect experimenter and press ENTER:\n\n0. Zero\n1. SSBA\n2. User 2\n3. User 3\n4. User 4\n\n');
experimenterIndex = experimenterIndex+1;
experimenter = cell2mat(experimenterList(experimenterIndex,:));
BonsaiCodePath = rd.Dir.BonsaiCode;

boxList = {'COM5'; 'COM4'; 'COM6';'COM7'; 'COM11'; 'COM8';'COM14'};
bonsaiFile = [BonsaiCodePath '\video_acq_pg_timestamped_led_box1.bonsai';
    BonsaiCodePath '\video_acq_pg_timestamped_led_box2.bonsai';
    BonsaiCodePath '\video_acq_pg_timestamped_led_box3.bonsai';
    BonsaiCodePath '\video_acq_pg_timestamped_led_box4.bonsai';
    BonsaiCodePath '\video_acq_pg_timestamped_led_box5.bonsai';
    BonsaiCodePath '\video_acq_pg_timestamped_led_box6.bonsai';
    BonsaiCodePath '\video_acq_pg_timestamped_led_box6.bonsai'];

boxIndex = input('\n\n Which box is being used?\n\n1 \n2 \n3 \n4 \n5 \n6 \nOpenField(7) \n\n');
addr = cell2mat(boxList(boxIndex,:));

%  'Sert_864'; 'Sert_866'; 'Sert_868';...
mouseList = {'Zero';'Sert_1422';'FI12xArch_116';'SertxChR2_1481';'FI12_24';'SertxChR2_227';'FI12xArch_115';...
    'Sert_1421';'FI12xArch_117';'SertxChR2_1485'; 'FI12_1109';'SertxChR2_181';'SertxChR2_179';...
   'SertxChR2_185';'FI12xArch_1447';'FI12xArch_121';'SertxChR2_190';'SertxChR2_188'; ...
    };
% 'FI12_28';...
%     'FI12xArch_20';
%     'VGATCHR2_207';'VGATCHR2_208'
% 
str= ['And who is doing the real job?\n\n'];
for imouse = 1:length(mouseList)
    str = sprintf('%s %d-%s\n',str,imouse-1, mouseList{imouse});
end

str = [str '\n\n'];
mouseIndex = input([str]);
mouseIndex = mouseIndex +1;
mouseName = mouseList(mouseIndex);
mouseName = cell2mat(mouseName);

% pull up yesterdays peformance
fdir = fullfile(rd.Dir.DataBehav,mouseName);
files = dirc(fdir,'f','d');
try
    daily_TAFC_Mice(fullfile(fdir,files{end,1}),0,0)
catch
end
protocolList = {'TAFCv06_8stim';'TAFCv06_2stim';'TAFCv06_4stim';'TAFCv06_6stim';'TAFCl1'; 'TAFCl2';'TAFCl3';'TAFCl3_more_increment';'Flush_Valves';'TAFCv07';'TAFCv06_8stim_longerTimeout';'MATCHINGvFix02_Stimulation1';'TAFCv08_stimulation02';'TAFCv09';'SelfReinf01';'SelfReinf01_water';'TAFCv08_stimulation03';'TAFCv08_Fixation_stimulation02';'MATCHINGvFix02_Stimulation_Blocks1';'IntervalStimulation03';''};
protocolIndex = input(['\nWhich task protocol do you want to load on Arduino? \n' ...
    '\n0. TAFCv06_8stim (regular task with 8 stimuli)\n'...
    '\n1. TAFCv06_2stim (regular task with 2 stimuli)\n'...
    '\n2. TAFCv06_4stim (regular task with 4 stimuli)\n'...
    '\n3. TAFCv06_6stim (regular task with 6 stimuli)\n'...
    '\n4. TAFCl1 (learning there is water on side pokes)\n'...
    '\n5. TAFCl2 (learning to center poke first)\n'...
    '\n6. TAFCl3 (introducing the delay period)\n'...
    '\n7. TAFCl3_more_increment (delay period starts at 1300ms and increases 15ms per correct trial)\n'...
    '\n8. Flush_Valves\n'...
    '\n9. TAFCv07\n'...
    '\n10. TAFCv06_8stim_longerTimeout 18sec rather than 12 sec\n'...
    '\n11. MATCHINGvFix02 - training center poked in\n'...
    '\n12. TAFCv08_stimulation02 - with simulation code\n'...
    '\n13. TAFCv09_rats code\n'...
    '\n14. Self reinforcement code without water\n'...
    '\n15. Self reinforcement code with water\n'...
    '\n16.  TAFCv08_stimulation03 - with simulation before poke in code\n'...
    '\n17. TAFCv08_Fixation_stimulation02 with fixation in centre poke\n'...
    '\n18. MATCHINGvFix02_Stimulation_Blocks1\n'...
    '\n19. IntervalStimulation\n'...
    '\n20. skip upload\n\n'],'s');
%%
bedit =0;
if all(regexp(protocolIndex,'[0-9]'))
    protocolIndex = str2num(protocolIndex);
else % string with a<protocol number> e.g. a12 to open config
    bedit = 1;
    protocolIndex =  str2num(protocolIndex(2:end));
end
%%
if protocolIndex~=length(protocolList)
    
    if protocolIndex == -1 % use last protcol
        [protocol_path lastProtocol lastBox]= getlastArduinoProtocolRun(mouseName,boxIndex);
        protocol = lastProtocol;
    elseif  protocolIndex == -2 % use last protocol with editing
        [protocol_path lastProtocol lastBox]= getlastArduinoProtocolRun(mouseName,boxIndex);
        hf = setArduinoParametersGUI(protocol_path,protocol_path); % this allows editing of arduino paramters
        waitfor(hf);
        protocol = lastProtocol;
    else
        protocolIndex = protocolIndex+1;
        protocol = protocolList(protocolIndex);
        protocol = cell2mat(protocol);
        targetname = [protocol '_box' num2str(boxIndex) '.ino'];
        protocol_path = fullfile(rd.Dir.CodeArduinoProtocols,[protocol '_box' num2str(boxIndex)],targetname);
        if bedit
            target_path = maketempProtocol(protocol_path,targetname);
            hf = setArduinoParametersGUI(protocol_path,target_path); % this allows editing of arduino paramters
            waitfor(hf);
            protocol_path = target_path; % use the temp protocol just created
        end
    end
    
    arduinoPath = rd.Dir.ArduinoPath;
    system([arduinoPath '\arduino --board arduino:avr:mega2560 --port ' addr ' --upload \', protocol_path ' &'])
    str = input('Wait while arduino uploads your script and then press s key.\nTo quit at any time, hit ctrl + c.\n\n', 's');
  start = any(ismember(str, {'s','n'}));
    if any(ismember(str, {'n'}))
        brunVideo = 0;
    end
    if start ==1;
        disp(['Experimenter ',experimenter(1,:),' is running mouse ',mouseName, ' on the protocol ', protocol '\n\n']);
    end
    
end
%%
dat = datestr(date, 'yymmdd');
fdir = fullfile(rd.Dir.DataBehav,mouseName);
fvdir = fullfile(rd.Dir.DataVideo,mouseName);
fvdatadir = fullfile(rd.Dir.DataBonsai,mouseName);

fnameheader = [mouseName '_' protocol '_box' num2str(boxIndex) '_' dat '_' experimenter '_(I)'];
files = dir(fullfile(fdir,[fnameheader '*']));
parentfolder(fdir,1);
% Augment FileNumber (index)
fileIndex = 1;
if ~isempty(files)
    for ifile = 1:length(files)
        fileIndex(ifile) = str2num(files(ifile).name(length(fnameheader)+1:end-4));
    end
    fileIndex = max(fileIndex);
end
fname = [fnameheader num2str(fileIndex) '.txt'];

% check if file already exists
if exist(fullfile(fdir,fname),'file')
    str = input(sprintf('Behavior file:\n\t%s \n (n)ew (r)eplace, (a)ppend:',strrep(fullfile(fdir,fname),'\','\\')), 's');
    switch(lower(str))
        case 'r'
            delete(fullfile(fdir,fname))
        case 'n'
            fileIndex = fileIndex+1;
            fname = [fnameheader num2str(fileIndex) '.txt'];
        case 'a'
    end
end
logpath = fullfile(rd.Dir.DataLogs,mouseName,dat,num2str(fileIndex));
if(brunVideo)
    [~, fn] = fileparts(fname);
    % TODO create directories automatically
    parentfolder(fvdir,1)
    parentfolder(fvdatadir,1)
    fileAvi = fullfile(fvdir,[fn '.avi']);
    fileAviTime = fullfile(fvdatadir,[fn '_vid_time.csv']);
    fileLED = fullfile(fvdatadir,[fn '_led_intensity.csv']);
    fileTracking = fullfile(fvdatadir,[fn '_tracking.csv']);
    fileCentroidXY = fullfile(fvdatadir,[fn '_centroidXY.csv']);
    fileCentroidOrientation = fullfile(fvdatadir,[fn '_centroidOrientation.csv']);
    
    if bonsaiFile(boxIndex)
        changeBonsaiFiles(bonsaiFile(boxIndex,:), fileAvi,fileAviTime,fileLED,fileTracking,fileCentroidXY,fileCentroidOrientation);
        if 0 %(boxIndex==2)||(boxIndex==5)
            batfile = fopen(fullfile(rd.Dir.BatFile,'batfile.bat'),'w');
            fwrite(batfile,fullfile(rd.Dir.BonsaiEditor86,['Bonsai.Editor.exe ' bonsaiFile(boxIndex,:) ' --start']));
            fclose(batfile);
        else
            batfile = fopen(fullfile(rd.Dir.BatFile,'batfile.bat'),'w');
            fwrite(batfile,fullfile(rd.Dir.BonsaiEditor64,['Bonsai.Editor.exe ' bonsaiFile(boxIndex,:) ' --start']));
            fclose(batfile);
        end
    end
    
    %Run Bonsai
    init_PID = getPID('Bonsai.Editor.exe');
    system(fullfile(rd.Dir.BatFile,'batfile.bat &'));
    new_PID = getPID('Bonsai.Editor.exe');
    PID = new_PID(~ismember(new_PID,init_PID));
    setPIDPriority(PID,'high'); % required for  no frame dropping
    
    
    % save to log
    parentfolder(logpath,1);
    [~, fileonly] = fileparts(bonsaiFile(boxIndex,:));
    copyfile(bonsaiFile(boxIndex,:),fullfile(logpath,[fileonly '_' num2str(now) '.txt']));
    
    
end

%with serial.Serial(addr,baud) as port, open(fdir + fname,fmode) as outf:
fmode = 'ab';
% outf = fopen(fullfile(fdir,fname),fmode);
baud  = 115200;
pythonFile = 'Run_Serial_Port_SSBA_Desktop.py';

s = sprintf('python %s %s %d %s "%s" &', fullfile(rd.Dir.PythonScripts, pythonFile), addr, baud, fmode, fullfile(fdir,fname));


system(s);

% save Aruduino file to log
parentfolder(logpath,1);
[~, fileonly] = fileparts(protocol_path);
copyfile(protocol_path,fullfile(logpath,[fileonly '_' datestr(now,30) '.txt']));


%system('python C:\Users\Behave\Run_Serial_Port_SSBA_Desktop.py COM16 115200 ab "C:\Users\Behave\Dropbox\PatonLab\Paton Lab\Data\TAFCmice\Behavior\BII\test.txt" &')

%%

try
    pause(5);
    dstruct.dataParsed = custom_parsedata(fullfile(fdir,fname));
    % dstruct.dataParsed  = filtbdata_trial(dstruct.dataParsed,[1:500]);
    if strcmp('TAFC',dstruct.dataParsed.Protocol)
        ss_daily_report(dstruct,1); %for stimulated sessions
        %     ss_daily_report(dstruct);
        
    else strcmp('MATCHING',dstruct.dataParsed.Protocol)
        figure('WindowStyle','docked'); plot(dstruct.dataParsed.WaitingTimeActual) ;
        hold all; plot(dstruct.dataParsed.WaitingTimeMin)
        [junk name ] = fileparts(dstruct.dataParsed.FileName);
        title(name,'Interpreter','none');
    end
    
catch
end
