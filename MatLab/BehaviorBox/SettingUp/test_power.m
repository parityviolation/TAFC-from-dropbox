rd = brigdefs();

brunVideo = 1;

protocol = 'Flush_Valves';
protocol_path = fullfile(rd.Dir.CodeArduinoProtocols,protocol,[protocol '.ino']);

boxList = {'COM5'; 'COM4'; 'COM6';'COM7'; 'COM21'; 'COM23'};

for i=1:length(boxList)

    addr = cell2mat(boxList(i)); 

    system(['C:\Software\arduino-1.5.2\arduino --board arduino:avr:mega2560 --port ' addr ' --upload \', protocol_path ' &']);

end
