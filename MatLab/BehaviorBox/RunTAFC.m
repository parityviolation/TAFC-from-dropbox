
%
% Created on November 2012
%
% @author: sofia
%
%
%1
rd = brigdefs();
% read file with coordinates xy xy for item 1 and 2 in each frame
brunVideo = 1;

experimenterList = {'Zero'; 'SSAB'; 'User 2'; 'User 3'; 'User 4'};
experimenterIndex = input('\n\nINTERVAL DURATION DISCRIMINATION TASK \n\nSelect experimenter and press ENTER:\n\n0. Zero\n1. SSBA\n2. User 2\n3. User 3\n4. User 4\n\n');
experimenterIndex = experimenterIndex+1;
experimenter = cell2mat(experimenterList(experimenterIndex,:));

boxList = {'COM5'; 'COM4'; 'COM6';'COM7'; 'COM16'};
bonsaiFile = ['C:\Users\Behave\Dropbox\TAFCmice\Code\Bonsai\video_acq_pg_timestamped_led_box1.bonsai';
    'C:\Users\Behave\Dropbox\TAFCmice\Code\Bonsai\video_acq_pg_timestamped_led_box2.bonsai';
    'C:\Users\Behave\Dropbox\TAFCmice\Code\Bonsai\video_acq_pg_timestamped_led_box3.bonsai';
    'C:\Users\Behave\Dropbox\TAFCmice\Code\Bonsai\video_acq_pg_timestamped_led_box4.bonsai';
    'C:\Users\Behave\Dropbox\TAFCmice\Code\Bonsai\video_acq_pg_timestamped_led_box5.bonsai'];

boxIndex = input('\n\n Which box is being used?\n\n1 \n2 \n3 \n4 \n5 \n\n');
addr = cell2mat(boxList(boxIndex,:));


mouseList = {'Zero'; 'BI'; 'BII'; 'BIII';...
    'Sert_864'; 'Sert_866'; 'Sert_867'; 'Sert_868';...
    'FI12_912'; 'FI12_916'; 'FI12_1013';...
    'FI12_1019'; 'FI12_1020'; 'FI12_1109'};
mouseIndex = input('\n\n And who is doing the real job?\n\n0. Zero \n1. BI \n2. BII \n3. BIII \n4. Sert_864 \n5. Sert_866 \n6. Sert_867 \n7. Sert_868 \n8. FI12_912 \n9. FI12_916 \n10. FI12_1013 \n11. FI12_1019 \n12. FI12_1020 \n13. FI12_1109 \n\n');
mouseIndex = mouseIndex +1;
mouseName = mouseList(mouseIndex);
mouseName = cell2mat(mouseName);


protocolList = {'TAFCv06_8stim';'TAFCv06_2stim';'TAFCv06_4stim';'TAFCv06_6stim';'TAFCl1'; 'TAFCl2';'TAFCl3';'TAFCl3_more_increment';'Flush_Valves';'TAFCv07';'TAFCv06_8stim_longerTimeout';'MATCHINGvFix02';'TAFCv08_stimulation02';'TAFCv09';'SelfReinf01';'TAFCv08_stimulation03';'TAFCv08_Fixation_stimulation02';''};
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
    '\n14. Self reinforcement code\n'...
    '\n15.  TAFCv08_stimulation03 - with simulation before poke in code\n'...
    '\n16. TAFCv08_Fixation_stimulation02 with fixation in centre poke\n'...
    '\n17. skip upload\n\n']);

protocolIndex = protocolIndex+1;
protocol = protocolList(protocolIndex);
protocol = cell2mat(protocol);


if protocol
    
    protocol_path = fullfile(rd.Dir.CodeArduinoProtocols,[protocol '_box' num2str(boxIndex)],[protocol '_box' num2str(boxIndex) '.ino']);
    
    system(['C:\Software\arduino-1.5.2\arduino --board arduino:avr:mega2560 --port ' addr ' --upload \', protocol_path ' &'])
    str = input('Wait while arduino uploads your script and then press s key.\nTo quit at any time, hit ctrl + c.\n\n', 's');
    
    start = any(ismember(str, {'s','n'}));
    if any(ismember(str, {'n'}))
        brunVideo = 0;
    end
    if start ==1;
        
        disp(['Experimenter ',experimenter(1,:),' is running mouse ',mouseName, ' on the protocol ', protocol '\n\n']);
        
    end
    
end

dat = datestr(date, 'yymmdd');

fdir = fullfile(rd.Dir.DataBehav,mouseName);


fname = [mouseName '_' protocol '_box' num2str(boxIndex) '_' dat '_' experimenter '.txt'];
fvdir = fullfile(rd.Dir.DataVideo,mouseName);
fvdatadir = fullfile(rd.Dir.DataBonsai,mouseName);

if(brunVideo)
    % TODO create directories automatically
    fileAvi = fullfile(fvdir,[mouseName '_' protocol '_box' num2str(boxIndex) '_' dat '_' experimenter '.avi']);
    fileAviTime = fullfile(fvdatadir,[mouseName '_' protocol '_box' num2str(boxIndex) '_' dat '_' experimenter '_vid_time.csv']);
    fileLED = fullfile(fvdatadir,[mouseName '_' protocol '_box' num2str(boxIndex) '_' dat '_' experimenter '_led_intensity.csv']);
    fileTracking = fullfile(fvdatadir,[mouseName '_' protocol '_box' num2str(boxIndex) '_' dat '_' experimenter '_tracking.csv']);
    fileCentroidXY = fullfile(fvdatadir,[mouseName '_' protocol '_box' num2str(boxIndex) '_' dat '_' experimenter '_centroidXY.csv']);
    fileCentroidOrientation = fullfile(fvdatadir,[mouseName '_' protocol '_box' num2str(boxIndex) '_' dat '_' experimenter '_centroidOrientation.csv']);
    
    
    if bonsaiFile(boxIndex)
        changeBonsaiFiles(bonsaiFile(boxIndex,:), fileAvi,fileAviTime,fileLED,fileTracking,fileCentroidXY,fileCentroidOrientation);
        if (boxIndex==2)||(boxIndex==5)
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
    system(fullfile(rd.Dir.BatFile,'batfile.bat &'));
    
    
    % save to log
    logpath = fullfile(rd.Dir.DataLogs,mouseName,dat);
    parentfolder(logpath,1);
    [~, fileonly] = fileparts(bonsaiFile(boxIndex,:));
    copyfile(bonsaiFile(boxIndex,:),fullfile(logpath,fileonly));
    
    
end

%with serial.Serial(addr,baud) as port, open(fdir + fname,fmode) as outf:
fmode = 'ab';
% outf = fopen(fullfile(fdir,fname),fmode);
baud  = 115200;
pythonFile = 'Run_Serial_Port_SSBA_Desktop.py';

s = sprintf('python %s %s %d %s "%s" &', fullfile(rd.Dir.PythonScripts, pythonFile), addr, baud, fmode, fullfile(fdir,fname));

% check if file already exists
if exist(fullfile(fdir,fname),'file')
    str = input(sprintf('Behavior file:\n\t%s \n (r)eplace, (a)ppend:',fullfile(fdir,fname)), 's');
    switch(lower(str))
        case 'r'
            delete(fullfile(fdir,fname))
        otherwise
    end
end
system(s);

% save Aruduino file to log
logpath = fullfile(rd.Dir.DataLogs,mouseName,dat);
parentfolder(logpath,1);
[~, fileonly] = fileparts(protocol_path);
copyfile(protocol_path,fullfile(logpath,fileonly));


%system('python C:\Users\Behave\Run_Serial_Port_SSBA_Desktop.py COM16 115200 ab "C:\Users\Behave\Dropbox\PatonLab\Paton Lab\Data\TAFCmice\Behavior\BII\test.txt" &')

%%

try
    pause(10);
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
% port = serial(addr, 'baudrate', baud);
% if strcmp(port.Status,'closed')
%     fopen(port);
% end
%
% disp('WAIT FOR IT!!!!\n\n');
%
% pause(10);
%
% disp('DONE\n\n');
%
% fprintf(port, 's');


%
% while strcmp(port.Status,'open')
%     if port.BytesAvailable>0
%         try
%             x = fscanf(port);
%             disp (x);
%             fwrite(outf, x);
%
%         catch ME
%             getReport(ME)
%             disp('***********************Error');
%             fwrite(outf, 'Error');
%         end
%     end
%
%     k=waitforbuttonpress;
%     if k
%         fclose(port);
% %     if ~strcmp(get(gcf,'currentcharacter'),'5');
% %         k=0;
% %     end
%     end
%
% end
%
%
