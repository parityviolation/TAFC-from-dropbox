function  [protocol_path lastProtocol lastBox]= getlastArduinoProtocolRun(mouseName,boxIndex)
rd = brigdefs();

% get last arduino code run (DONE) untested whether it can be uploaded
logpath = fullfile(rd.Dir.DataLogs,mouseName);

% date directory
logdir = dirc(logpath,'de','d');
logpath = fullfile(logpath,logdir{end,1});

% number of run directory
logdir = dirc(logpath,'de','d');
logpath = fullfile(logpath,logdir{end,1});

arduinoFile = dirc(logpath,'f');
if isempty(arduinoFile)
    warning('Cannot find Last Arduino Protocol')
    protocol_path = -1;
    return;
end
arduinoFile_only = arduinoFile{1,2}; % get filename

uscore_ndx = regexp(arduinoFile_only,'_');


indBox = strfind(lower(arduinoFile_only),'box');
if isempty(indBox)
    lastBox = 'Unknown';
else
    indend = uscore_ndx(find(uscore_ndx>indBox,1,'first'));
    lastBox = arduinoFile_only(indBox+3:indend-1);
end

lastProtocol = arduinoFile_only(1:indBox-2);
if ~isequal(lastBox,num2str(boxIndex))
    error(['last protocol was run on ' lastBox ' a different box']);
end


% make .ino file and directory
uploadfilename = [lastProtocol '_box' num2str(boxIndex)];
disp(['Last Protocol for ' mouseName ' was ' uploadfilename]);

sourcefile = fullfile(logpath,arduinoFile{1,1});
targetname = uploadfilename;
protocol_path = maketempProtocol(sourcefile,targetname);


