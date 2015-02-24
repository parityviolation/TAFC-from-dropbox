function flush_all(boxes_to_flush)

rd = brigdefs();

boxList = rd.bbox.COM;

if nargin==0
    boxes_to_flush = [1:length(boxList)];
end
      

protocol = 'Flush_Valves';
protocol_path = fullfile(rd.Dir.CodeArduinoProtocols,protocol,[protocol '.ino']);
arduinoPath = rd.Dir.ArduinoPath;
for i=boxes_to_flush

    addr = cell2mat(boxList(i)); 
    
    system([arduinoPath '\arduino --board arduino:avr:mega2560 --port ' addr ' --upload \', protocol_path ' &']);
pause(1);
end


    