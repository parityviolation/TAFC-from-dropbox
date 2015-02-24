function runBonsai_onAvi(videoFullPath,markerA,markerB,markerC)
% runs Bonsai V2 on Avi file, does led, marker center tracking etc.
% BA
% NOTE LED ROI may need to be specified manually
%
% videoFullPath = 'D:\TAFCmiceWaiting\SertxChR2_179\SertxChR2_179_TAFCv08_stimulation02_box2_140303_SSAB_(I)1.avi';

if nargin <2
    markerA = '41';
    markerB = '545';
    markerC = '345';
    markerD = '45';
    markerE = '145';
    markerF = '445';
end

rd = brigdefs;
BonsaiCodePath = rd.Dir.BonsaiCode;

bonsaiExePath = 'C:\Users\Behave\AppData\Local\Bonsai\Bonsai64.exe';
bonsaiFile = [BonsaiCodePath '\BonsaiV2\video_acq_FILE.bonsai'];

s = input('HAVE you reset to the ROI for the LED in bonsai, Have you set the threshold? (c to cancel)','s');

if isequal(s,'c')
    disp('Quiting')
    return;
end

[FileName PathName mouseName ...
    Date Protocol ProtocolVersion Box Experimenter FileNumber] = getBfileparts(videoFullPath);

fvdatadir = fullfile(rd.Dir.DataBonsai,mouseName);
parentfolder(fvdatadir,1)

videoFile = videoFullPath;
led_intensityFile = fullfile(fvdatadir,[FileName '_led_intensity.csv']);

orientFile  = fullfile(fvdatadir,[FileName '_centroidOrientation.csv']);
centFile  = fullfile(fvdatadir,[FileName '_centroidXY.csv']);
extremesFile  = fullfile(fvdatadir,[FileName '_tracking.csv']);

markerAFile  = fullfile(fvdatadir,[FileName '_marker', markerA,'.csv']);
markerBFile  = fullfile(fvdatadir,[FileName '_marker', markerB,'.csv']);
markerCFile  = fullfile(fvdatadir,[FileName '_marker', markerC,'.csv']);
markerDFile  = fullfile(fvdatadir,[FileName '_marker', markerD,'.csv']);
markerEFile  = fullfile(fvdatadir,[FileName '_marker', markerE,'.csv']);
markerFFile  = fullfile(fvdatadir,[FileName '_marker', markerF,'.csv']);


s = [bonsaiExePath...
    ' -p:videoFile=' '"' videoFile '"'...
    ' -p:led_intensityFile=' '"' led_intensityFile '"'...
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
        ' ' bonsaiFile ' --start'];

batfile = fopen(fullfile(rd.Dir.BatFile,'batfile.bat'),'w');
fwrite(batfile,s);
fclose(batfile);


%Run Bonsai
% pidname = 'Bonsai64.exe';
%     init_PID = getPID(pidname);
system(fullfile(rd.Dir.BatFile,'batfile.bat &'));
%     new_PID = getPID(pidname);
%     PID = new_PID(~ismember(new_PID,init_PID));
% %     setPIDPriority(PID,'high'); % required for  no frame dropping


logpath = fullfile(rd.Dir.DataLogs,mouseName,Date,FileNumber);
parentfolder(logpath,1);

% save to log
parentfolder(logpath,1);
[~, fileonly] = fileparts(bonsaiFile);
fbonsaiLog = fullfile(logpath,[fileonly '_' num2str(now) '.txt']);
copyfile(bonsaiFile,fbonsaiLog);




