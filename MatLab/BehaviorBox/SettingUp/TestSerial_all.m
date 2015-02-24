function TestSerial_all(boxes_to_flush)

rd = brigdefs();

boxList = {'COM5'};% 'COM4'; 'COM6';'COM7'; 'COM8'; 'COM9'};

if nargin==0
    boxes_to_flush = [1:length(boxList)];
end
      

protocol = 'Test_Arduino_Serial';
protocol_path = fullfile(rd.Dir.CodeArduinoProtocols,protocol,[protocol '.ino']);
arduinoPath = rd.Dir.ArduinoPath;
for i=boxes_to_flush

    addr = cell2mat(boxList(i)); 
    
    system([arduinoPath '\arduino --board arduino:avr:mega2560 --port ' addr ' --upload \', protocol_path ' &']);
pause(20);


%%%%saving

dat = datestr(date, 'yymmdd');
fdir = fullfile(rd.Dir.DataBehav,'Serial_Test');

fnameheader = ['Serial_Test_' protocol '_box' num2str(i) '_' dat];

parentfolder(fdir,1);
% Augment FileNumber (index)

fname = [fnameheader '.txt'];

logpath = fullfile(rd.Dir.DataLogs,'Serial_Test',dat);

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
copyfile(protocol_path,fullfile(logpath,[fileonly '_' num2str(now)]));


%system('python C:\Users\Behave\Run_Serial_Port_SSBA_Desktop.py COM16 115200 ab "C:\Users\Behave\Dropbox\PatonLab\Paton Lab\Data\TAFCmice\Behavior\BII\test.txt" &')

%%

end
end















    