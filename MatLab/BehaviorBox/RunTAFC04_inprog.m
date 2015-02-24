
%
% Created on November 2012
%1
% @author: sofia1
%
%11
%
bloadSS = 1; % load and record experiments to Google Spreadsheet
bdebug  = 0; % turn logging off (and other things?)
rd = brigdefs();

% add preeformance, trials, bias report
% ad list of yes no questions

brunVideo = 1;

[questions context] = askQuestion;% initialize questions struct
n = 1;
questions(n).text = 'Stimulation (y/n):';
questions(n).fieldname = 'lightStimulation';
questions(n).answer = [];
questions(n).answerAllowEmpty = 0;
questions(n).answerType = 'bool';
questions(n).askIfBox = [1:4];
n = 2;
questions(n).text = 'Fiber Attached (y/n):';
questions(n).fieldname = 'fiber';
questions(n).answer = [];
questions(n).answerAllowEmpty = 0;
questions(n).answerType = 'bool';
questions(n).askIf = [1 0]; % if question number 1 is 0
questions(n).askIfBox = [1:4] ;% if question 1 is 0
n = 3;
questions(n).text = 'Power Measured:';
questions(n).fieldname = 'laserPower';
questions(n).answer = [];
questions(n).answerAllowEmpty = 1;
questions(n).answerType = 'string';
questions(n).askIf = [1 1]; % if question 1 is 1
questions(n).askIfBox = [1:4] ;
n= 4;
questions(n).text = 'Recording?:';
questions(n).fieldname = 'recorded';
questions(n).answer = [];
questions(n).answerAllowEmpty = 1;
questions(n).answerType = 'bool';
questions(n).askIf = []; % if question 1 is 1
questions(n).askIfBox = [1:4] ;
questions(n).askIfAnimal = {'SertxChR2_179'};
n= 5;
questions(n).text = 'Depth of Electrodes:';
questions(n).fieldname = 'recordDepth';
questions(n).answer = [];
questions(n).answerAllowEmpty = 1;
questions(n).answerType = 'string';
questions(n).askIf = [4 1]; % if question 4 is 1
questions(n).askIfBox = [1:4] ;
questions(n).askIfAnimal = {};
n= 6;
questions(n).text = 'Number of yoghurt drops:';
questions(n).fieldname = 'yoghurt';
questions(n).answer = [];
questions(n).answerAllowEmpty = 1;
questions(n).answerType = 'string';
questions(n).askIf = []; % if question 4 is 1
questions(n).askIfBox = [] ;
questions(n).askIfAnimal = {};

% load worksheet0
if bloadSS
    googleWS.username = '';
    googleWS.spreadsheetTitle = 'TAFC Mice Weights Table';
    googleWS.nColToGet = 7;
    googleWS.nRowToGet = 1;%number of rows from the bottom, counting from the first     non empty row
    googleWS.loadedworksheetTitle = [];
end

experimenterList = rd.bbox.experimenterList;
experimenterIndex = input('\n\nINTERVAL DURATION DISCRIMINATION TASK \n\nSelect experimenter and press ENTER:\n\n0. Zero\n1. SSBA\n2. User 2\n3. User 3\n4. User 4\n\n');
experimenterIndex = experimenterIndex+1;
experimenter = cell2mat(experimenterList(experimenterIndex,:));
BonsaiCodePath = rd.Dir.BonsaiCode;

boxList = rd.bbox.COM ;
% bonsaiFile = {[BonsaiCodePath '\video_acq_pg_timestamped_led_box1.bonsai'];
%     [BonsaiCodePath '\BonsaiV2\video_acq_pg_timestamped_ledv4.bonsai'];
%     [BonsaiCodePath '\video_acq_pg_timestamped_led_box3.bonsai'];
%     [BonsaiCodePath '\video_acq_pg_timestamped_led_box4.bonsai'];
%     [BonsaiCodePath '\video_acq_pg_timestamped_led_box5.bonsai'];
%     [BonsaiCodePath '\video_acq_pg_timestamped_led_box6.bonsai'];
%     [BonsaiCodePath '\OpenField_PG_centroid2.bonsai']};

bonsaiFile = {[BonsaiCodePath '\BonsaiV2\video_acq_pg_timestamped_ledv5_box2.bonsai'];
    [BonsaiCodePath '\BonsaiV2\video_acq_pg_timestamped_ledv1_GPIO_box2.bonsai'];
    [BonsaiCodePath '\BonsaiV2\video_acq_pg_timestamped_ledv1_GPIO_box3.bonsai'];
    [BonsaiCodePath '\BonsaiV2\video_acq_pg_timestamped_ledv1_GPIO_box4.bonsai'];
    [BonsaiCodePath '\video_acq_pg_timestamped_led_box5.bonsai'];
    [BonsaiCodePath '\video_acq_pg_timestamped_led_box6.bonsai'];
    [BonsaiCodePath '\OpenField_PG_centroid2.bonsai']};

boxIndex = input('\n\n Which box is being used?\n\n1 \n2 \n3 \n4 \n5 \n6 \nOpenField(7) \n\n');
addr = cell2mat(boxList(boxIndex,:));

mouseList = rd.bbox.mouseList;
str= ['And who is doing the real job?\n\n'];
for imouse = 1:length(mouseList)
    str = sprintf('%s %d-%s\n',str,imouse-1, mouseList{imouse});
end

str = [str '\n\n'];
mouseIndex = input([str]);
mouseIndex = mouseIndex +1;
mouseName = mouseList(mouseIndex);
mouseName = cell2mat(mouseName);

% % yesterdays peformance
fdir = fullfile(rd.Dir.DataBehav,mouseName);
files = dirc(fdir,'f','d');
try
    dp = daily_TAFC_Mice(fullfile(fdir,files{end,1}),0,0);
    % TO DO ADD addFieldtoStruct(animalLog,fld)
    
    if dp.totalTrials > 1
        performSummary = getPerformance(dp);
        
        [animalLog bfound] = addToLocalLog(performSummary,[],dp.FileName);
        % PLOTSUmmary perfornace
        plotLogSummary(dp.Animal)
    end
    
catch ME
    getReport(ME)
end

display(['Weight of ' mouseName ':']);
% % open worksheet
if bloadSS
    googleWS.worksheetTitle = mouseName;
    [googleWS newrow hfigSS] = openAnimal_GoogleWS(googleWS);
    set(hfigSS.hut,'ColumnEditable',false)
end

% % get Animal Weight
clear weight
weight = input('');
context.box = boxIndex;
context.animal = mouseName;
questions = askQuestion(questions(1:6),context);
%% which protocol
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

bedit =0;
if all(regexp(protocolIndex,'[0-9]'))
    protocolIndex = str2num(protocolIndex);
else % string with a<protocol number> e.g. a12 to open config
    bedit = 1;
    protocolIndex =  str2num(protocolIndex(2:end));
end
%% upload arduion
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
    if~bdebug
        
        arduinoPath = rd.Dir.ArduinoPath;
        system(['"' arduinoPath '\arduino"' ' --board arduino:avr:mega2560 --port ' addr ' --upload \', protocol_path ' &'])
        str = input('Wait while arduino uploads your script and then press s key.\nTo quit at any time, hit ctrl + c.\n\n', 's');
    end
    start = any(ismember(str, {'s','n'}));
    if any(ismember(str, {'n'}))
        brunVideo = 0;
    end
    if start ==1;
        disp(['Experimenter ',experimenter(1,:),' is running mouse ',mouseName, ' on the protocol ', protocol '\n\n']);
    end
    
end
%% run behavior and bonsai


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
    NEWREPLACEAPPEND = input(sprintf('Behavior file:\n\t%s \n (n)ew (r)eplace, (a)ppend:',strrep(fullfile(fdir,fname),'\','\\')), 's');
    switch(lower(NEWREPLACEAPPEND))
        case 'r'
            delete(fullfile(fdir,fname))
        case 'n'
            fileIndex = fileIndex+1;
            fname = [fnameheader num2str(fileIndex) '.txt'];
        case 'a'
    end
end
logpath = fullfile(rd.Dir.DataLogs,mouseName,dat,num2str(fileIndex));
if(brunVideo &     ~bdebug)
    
    [~, fn] = fileparts(fname);
    % TODO create directories automatically
    parentfolder(fvdir,1)
    parentfolder(fvdatadir,1)
    fileAvi = fullfile(fvdir,[fn '.avi']);
    fileAviTime = fullfile(fvdatadir,[fn '_vid_time.csv']);
    fileLED = fullfile(fvdatadir,[fn '_led_intensity.csv']);
    fileGPIO = fullfile(fvdatadir,[fn '_gpio.csv']);
    fileTracking = fullfile(fvdatadir,[fn '_tracking.csv']);
    fileCentroidXY = fullfile(fvdatadir,[fn '_centroidXY.csv']);
    fileCentroidOrientation = fullfile(fvdatadir,[fn '_centroidOrientation.csv']);
    
    if bonsaiFile{boxIndex}
        if   boxIndex < 7 & boxIndex~=2 & boxIndex~=4 & boxIndex~=1 & boxIndex~=3
            changeBonsaiFiles(bonsaiFile{boxIndex}, fileAvi,fileAviTime,fileLED,fileTracking,fileCentroidXY,fileCentroidOrientation);
        end
        
        if (boxIndex==2)||(boxIndex==4)||(boxIndex==3) % run NEW NEW bonsai
           camIndex =rd.bbox.cameraIndex;
        
          bF = bonsaiFile{boxIndex};
            led_intensityFile = fileLED;
            gpioFile = fileGPIO;
            vid_timeFile = fileAviTime;
            videoFile = fileAvi;
            markerA = '41';
            markerB = '545';
            markerC = '345';
            markerD = '45';
            markerE = '145';
            markerF = '445';
            
            orientFile  = fullfile(fvdatadir,[fn '_centroidOrientation.csv']);
            centFile  = fullfile(fvdatadir,[fn '_centroidXY.csv']);
            extremesFile  = fullfile(fvdatadir,[fn '_tracking.csv']);
            markerAFile  = fullfile(fvdatadir,[fn '_marker', markerA,'.csv']);
            markerBFile  = fullfile(fvdatadir,[fn '_marker', markerB,'.csv']);
            markerCFile  = fullfile(fvdatadir,[fn '_marker', markerC,'.csv']);
            markerDFile  = fullfile(fvdatadir,[fn '_marker', markerD,'.csv']);
            markerEFile  = fullfile(fvdatadir,[fn '_marker', markerE,'.csv']);
            markerFFile  = fullfile(fvdatadir,[fn '_marker', markerF,'.csv']);
           
%             C:\Software\BonsaiARUCO\Bonsai64.exe
%              C:\Software\BonsaiRC4
            s = ['C:\Software\Bonsai0411\Bonsai64.exe'...
                ' -p:videoFile=' '"' videoFile '"'...
                ' -p:vid_timeFile=' '"' vid_timeFile '"' ...
                ' -p:cameraIndex=' camIndex{boxIndex} ...
                ' -p:led_intensityFile=' '"' led_intensityFile '"'...
                ' -p:gpioFile=' '"' gpioFile '"'...
                ' -p:orientFile=' '"' orientFile '"'...
                ' -p:centFile=' '"' centFile '"'...
                ' -p:extremesFile=' '"' extremesFile '"'...
                ' -p:marker1.markerFile=' '"' markerAFile '"' ...
                ' -p:marker2.markerFile=' '"' markerBFile '"' ...
                ' -p:marker3.markerFile=' '"' markerCFile '"' ...
                ' -p:marker4.markerFile=' '"' markerDFile '"' ...
                ' -p:marker5.markerFile=' '"' markerEFile '"' ...
                ' -p:marker6.markerFile=' '"' markerFFile '"' ...
                ' -p:marker1.marker=' '"' markerA '"' ...
                ' -p:marker2.marker=' '"' markerB '"' ...
                ' -p:marker3.marker=' '"' markerC '"' ...
                ' -p:marker4.marker=' '"' markerD '"' ...
                ' -p:marker5.marker=' '"' markerE '"' ...
                ' -p:marker6.marker=' '"' markerF '"' ...
                ' ' bF ' --start'];
            batfile = fopen(fullfile(rd.Dir.BatFile,'batfile.bat'),'w');
            fwrite(batfile,s);
            fclose(batfile);
             pidname = 'Bonsai64.exe';
        
        
        elseif  (boxIndex==1) % run NEW bonsai
            camIndex = rd.bbox.cameraIndex;
            
            bF = bonsaiFile{boxIndex};
            led_intensityFile = fileLED;
            vid_timeFile = fileAviTime;
            videoFile = fileAvi;
            orientFile  = fullfile(fvdatadir,[fn '_centroidOrientation.csv']);
            centFile  = fullfile(fvdatadir,[fn '_centroidXY.csv']);
            extremesFile  = fullfile(fvdatadir,[fn '_tracking.csv']);
            markerAFile  = fullfile(fvdatadir,[fn '_markerA.csv']);
            markerBFile  = fullfile(fvdatadir,[fn '_markerB.csv']);
            markerCFile  = fullfile(fvdatadir,[fn '_markerC.csv']);
            markerDFile  = fullfile(fvdatadir,[fn '_markerD.csv']);
            markerEFile  = fullfile(fvdatadir,[fn '_markerE.csv']);
            markerFFile  = fullfile(fvdatadir,[fn '_markerF.csv']);
            markerA = '41';
            markerB = '545';
            markerC = '345';
            markerD = '45';
            markerE = '145';
            markerF = '445';
%             C:\Software\BonsaiARUCO\Bonsai64.exe
%              C:\Software\BonsaiRC4
            s = ['C:\Software\BonsaiARUCO\Bonsai64.exe'...
                ' -p:videoFile=' '"' videoFile '"'...
                ' -p:vid_timeFile=' '"' vid_timeFile '"' ...
                ' -p:cameraIndex=' camIndex{boxIndex} ...
                ' -p:led_intensityFile=' '"' led_intensityFile '"'...
                ' -p:orientFile=' '"' orientFile '"'...
                ' -p:centFile=' '"' centFile '"'...
                ' -p:extremesFile=' '"' extremesFile '"'...
                ' -p:markerAFile=' '"' markerAFile '"' ...
                ' -p:markerBFile=' '"' markerBFile '"' ...
                ' -p:markerCFile=' '"' markerCFile '"' ...
                ' -p:markerDFile=' '"' markerDFile '"' ...
                ' -p:markerEFile=' '"' markerEFile '"' ...
                ' -p:markerFFile=' '"' markerFFile '"' ...
                ' -p:markerA=' '"' markerA '"' ...
                ' -p:markerB=' '"' markerB '"' ...
                ' -p:markerC=' '"' markerC '"' ...
                ' -p:markerD=' '"' markerD '"' ...
                ' -p:markerE=' '"' markerE '"' ...
                ' -p:markerF=' '"' markerF '"' ...
                ' ' bF ' --start'];
            batfile = fopen(fullfile(rd.Dir.BatFile,'batfile.bat'),'w');
            fwrite(batfile,s);
            fclose(batfile);
             pidname = 'Bonsai64.exe';

        elseif 0 %(boxIndex==2)%||(boxIndex==5)
            batfile = fopen(fullfile(rd.Dir.BatFile,'batfile.bat'),'w');
            fwrite(batfile,fullfile(rd.Dir.BonsaiEditor86,['Bonsai.Editor.exe ' bonsaiFile{boxIndex} ' --start']));
            fclose(batfile);
        else
            batfile = fopen(fullfile(rd.Dir.BatFile,'batfile.bat'),'w');
            fwrite(batfile,fullfile(rd.Dir.BonsaiEditor64,['Bonsai.Editor.exe ' bonsaiFile{boxIndex} ' --start']));
            fclose(batfile);
            pidname = 'Bonsai.Editor.exe';
        end
    end
    
    %Run Bonsai
    init_PID = getPID(pidname);
    system(fullfile(rd.Dir.BatFile,'batfile.bat &'));
    new_PID = getPID(pidname);
    PID = new_PID(~ismember(new_PID,init_PID));
    setPIDPriority(PID,'high'); % required for  no frame dropping
    
    
    % save to log
    parentfolder(logpath,1);
    [~, fileonly] = fileparts(bonsaiFile{boxIndex});
    fbonsaiLog = fullfile(logpath,[fileonly '_' num2str(now) '.txt']);
    copyfile(bonsaiFile{boxIndex},fbonsaiLog);
    
else
    fbonsaiLog = '';
end

%with serial.Serial(addr,baud) as port, open(fdir + fname,fmode) as outf:
fmode = 'ab';
% outf = fopen(fullfile(fdir,fname),fmode);
baud  = 115200;
pythonFile = 'Run_Serial_Port_SSBA_Desktop.py';

s = sprintf('python %s %s %d %s "%s" &', fullfile(rd.Dir.PythonScripts, pythonFile), addr, baud, fmode, fullfile(fdir,fname));
system(s);

% save Aruduino file to log

if ~bdebug
    parentfolder(logpath,1);
    [~, fileonly] = fileparts(protocol_path);
    fArduinoLog = [fileonly '_' datestr(now,30) '.txt'];
    fArduinoLog = fullfile(logpath,fArduinoLog);
    copyfile(protocol_path,fArduinoLog);
end
%% add row to worksheet

% add case for replace and append different than new NEWREPLACEAPPEND

if isempty(weight)
    weight = '';
end

clear data1
formatOut = 'dd/mmm/yy';
data.date =datestr(now,formatOut);
data.Experimenter = experimenter;
data.name = mouseName;
data.boxIndex = boxIndex;
data.exptFilename = [fnameheader num2str(fileIndex)];
data.weight = weight;
data.brunVideo = brunVideo;
data.arduinoLog = fArduinoLog;
data.bonsaiLog = fbonsaiLog;
nq = length(questions);
for iq = 1:nq
    data.(questions(iq).fieldname) = questions(iq).answer;
end
%%
if ~bdebug
    animalLog =  addToLocalLog(data);   
    % add to google spreadsheet
    
    %%
    data.comment = '';                                                              % construct the comments fields
    if data.fiber==1, data.comment = [data.comment 'Fiber On'];...
    elseif data.fiber==0, data.comment = [data.comment 'Fiber Off']; end
if data.lightStimulation==1, data.comment = [data.comment ' Stim On'];
elseif data.lightStimulation==0, data.comment = [data.comment ' Stim Off']; end
if ~isempty(data.laserPower),data.comment = [data.comment ' ' data.laserPower]; end
if data.recorded==1, data.comment = [data.comment ' ephys On'];end
if ~isempty(data.recordDepth ), data.comment = [data.comment ' ' data.recordDepth]; end

if bloadSS
    [hfigSS.googleWS newrow]= addExptRow(hfigSS.googleWS,data);
    % updateUI1
    
    set(hfigSS.hut,'ColumnEditable',true)
    set(hfigSS.hut,'Data',hfigSS.googleWS.table)
end
end

% make the first column uneditable
% fix the formating of the columns

% kepp list of session run.
